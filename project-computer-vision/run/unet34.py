import torch
import numpy as np
from architecture.unet_resnet import Unet
from dataset.loader import dataloader
from kornia.losses import FocalLoss, DiceLoss
from engine.train import training, validating
from engine.early_stopping import early_stopping
from engine.visualization import plot_history
import numpy as np

DEVICE = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
IMG_DIR = './archive/images'
MASKS_DIR = './archive/masks'
MODEL_PATH = './model/unet_resnet34.pth'

NUM_CLASSES = 5
EPOCHS = 40
PATIENCE = 8
FREEZE = 8
LR_ENCODER = 1e-4
LR_DECODER = 1e-3
DECAY = 1e-4

HISTORY = {'train_loss': [], 'val_loss': [], 'train_iou': [], 'val_iou': [], 'train_dice': [], 'val_dice': []}

def main():
    print(f'Using: {DEVICE}')

    # Dataloaders
    train_loader, val_loader, _ = dataloader(IMG_DIR, MASKS_DIR)

    # Modello, Ottimizzatore, Scheduler e Metriche
    model = Unet(encoder_name='resnet34', encoder_weights='imagenet', classes=NUM_CLASSES).to(DEVICE)

    # --- Fase 1: Freeze encoder ---
    for p in model.encoder.parameters():
        p.requires_grad = False
    
    # LS's weights
    weights = np.array([0.1225, 0.2824, 0.9484, 2.5958, 1.0509])
    ls = torch.tensor(weights, dtype=torch.float32).to(DEVICE)
    focal = FocalLoss(alpha=0.25, gamma=1.5, reduction='mean', weight=ls)  
    dice = DiceLoss()
    def criterion(logits, targets): return focal(logits, targets) + dice(logits, targets)
    
    optimizer = torch.optim.Adam(filter(lambda p: p.requires_grad, model.parameters()), lr=LR_DECODER, weight_decay=DECAY)
    scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(optimizer, mode='min', factor=0.5, patience=4)
    
    # Parametri early stopping
    best_val_loss = float("inf")
    patience_count = 0

    # --- Inizio training ---
    for epoch in range(EPOCHS):
        print(f'\nEpoch {epoch + 1}/{EPOCHS}')

        if epoch == FREEZE - 1:
            print(f'Unfreeze encoder.')
            for p in model.encoder.parameters():
                p.requires_grad = True
            
            optimizer = torch.optim.AdamW(
                [
                    {'params': model.encoder.parameters(), 'lr': LR_ENCODER},
                    {'params': model.decoder.parameters(), 'lr': LR_DECODER},
                    {'params': model.segmentation_head.parameters(), 'lr': LR_DECODER},   
                ], weight_decay=DECAY
            )

        # Training e Validation step
        train_loss, train_iou, train_dice = training(model, train_loader, optimizer, criterion, DEVICE)
        val_loss, val_iou, val_dice = validating(model, val_loader, criterion, DEVICE)
        scheduler.step(val_loss)
        
        # Salvataggio metriche
        HISTORY['train_loss'].append(train_loss); HISTORY['val_loss'].append(val_loss)
        HISTORY['train_iou'].append(train_iou); HISTORY['val_iou'].append(val_iou)
        HISTORY['train_dice'].append(train_dice); HISTORY['val_dice'].append(val_dice)

        # Stampa dei risultati
        print(f"Train Loss: {train_loss:.4f} | Train IoU: {train_iou:.4f} | Train Dice: {train_dice:.4f} | "
              f"Val Loss: {val_loss:.4f} | Val IoU: {val_iou:.4f} | Val Dice: {val_dice:.4f}")
        
        # Controllo early stopping
        best_val_loss, patience_count, stop = early_stopping(model, MODEL_PATH, val_loss, best_val_loss, patience_count, PATIENCE)
        if stop:
            break

    # --- Fine training ---
    print(f'Modello salvato in {MODEL_PATH} - Plot delle curve...')
    plot_history(HISTORY)

if __name__ == '__main__':
    main()