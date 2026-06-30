import torch
import numpy as np
from architecture.unet_mit import Unet
from dataset.loader import dataloader

DEVICE = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
NUM_CLASSES = 5
MODEL_PATH = './model/unet_mit.pth'
IMG_DIR = './archive/images'
MASK_DIR = './archive/masks'

def load_model(model_path: str, device: str, num_classes: int=5) -> torch.nn.Module:
    '''Caricamento del modello in modalita' valutazione'''
    
    #model = Unet(num_classes=num_classes).to(device)
    model = Unet().to(device)
    model.load_state_dict(torch.load(model_path, map_location=device))
    model.eval()
    
    print(f'Modello caricato da {model_path} su {device}')
    return model

def confusion_matrix(confusion: np.ndarray, preds: torch.Tensor, masks: torch.Tensor) -> np.ndarray:
    '''Aggiornamento della matrice di confusione a partire da predizioni e maschere reali'''
    
    preds, masks = preds.cpu().numpy(), masks.cpu().numpy()
    
    for real, pred in zip(masks, preds):
        for r in range(NUM_CLASSES):
            for p in range(NUM_CLASSES):
                
                # Num. pixel con classe reale R e predizione P
                confusion[r, p] += np.logical_and(real == r, pred == p).sum()
    
    return confusion

def compute_metrics(confusion: np.ndarray) -> tuple[list, list]:
    '''IoU e Dice per ciascuna classe a partire dalla matrice di confusione'''
    
    ious, dices = [], []
    
    for c in range(NUM_CLASSES):
        TP = confusion[c, c]                    # True positive
        FP = confusion[:, c].sum() - TP         # False positive
        FN = confusion[c, :].sum() - TP         # False negative
        
        den_iou = TP + FP + FN
        den_dice = 2 * TP + FP + FN
        iou = TP / den_iou if den_iou != 0 else 'nan'
        dice = 2 * TP / den_dice if den_dice != 0 else 'nan'

        ious.append(iou)
        dices.append(dice)
    
    return ious, dices

def evaluate(model: torch.nn.Module, test_loader: torch.utils.data.DataLoader, device: str) -> tuple[list, list]:
    '''Valutazione del modello sul test set, costruendo matrice di confusione e calcolando IoU e Dice'''
    
    confusion = np.zeros((NUM_CLASSES, NUM_CLASSES))
    model.eval()

    # Disabilito il calcolo dei gradienti
    with torch.no_grad():
        for images, masks in test_loader:
            images, masks = images.to(device), masks.to(device)

            outputs = model(images)                 # Forward pass
            preds= torch.argmax(outputs, dim=1)     # Predizione
            confusion = confusion_matrix(confusion, preds, masks)
    
    return compute_metrics(confusion)

def main():

    _, _ , test_loader = dataloader(IMG_DIR, MASK_DIR)
    model = load_model(MODEL_PATH, DEVICE, num_classes=NUM_CLASSES)
    ious, dices = evaluate(model, test_loader, DEVICE)
    print(
        f'IoU per classe: {ious}.\n'
        f'IoU medio: {np.nanmean(ious):.4f}.\n'
        f'Dice per classe: {dices}.\n'
        f'Dice medio:{np.nanmean(dices):.4f}.\n'
    )

if __name__ == '__main__':
    main()