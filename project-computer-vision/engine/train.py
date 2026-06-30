import torch
import numpy as np
from engine.metrics import IoU, dice_score

def training(model: torch.nn.Module, loader: torch.utils.data.DataLoader, optimizer: torch.optim.Optimizer, criterion: torch.nn.Module, device: torch.device):
    '''Esecuzione di una epoca di training'''

    # Modalità training
    model.train()
    total_loss = 0
    iou, dice = [], []

    for images, masks in loader:
        images, masks = images.to(device), masks.to(device)
        
        optimizer.zero_grad()                       # Azzero i gradienti
        outputs = model(images)                     # Forward pass
        
        loss = criterion(outputs, masks)            # Calcolo la loss
        loss.backward()                             # Backpropagation
        optimizer.step()

        total_loss += loss.item()                   # Accumulo della loss

        preds = outputs.argmax(1)                   # Predizione delle classi
        
        # Calcolo delle metriche
        iou.append(np.nanmean(IoU(preds, masks)))
        dice.append(np.nanmean(dice_score(preds, masks)))
    
    return total_loss / len(loader), np.nanmean(iou), np.nanmean(dice)

def validating(model: torch.nn.Module, loader: torch.utils.data.DataLoader, criterion: torch.nn.Module, device: torch.device):
    '''Esecuzione di una epoca di validazione'''

    # Modalità valutazione
    model.eval()
    total_loss = 0
    iou, dice = [], []

    # Disabilito il calcolo dei gradienti
    with torch.no_grad():

        for images, masks in loader:
            images, masks = images.to(device), masks.to(device)
            
            outputs = model(images)                 # Forward pass

            loss = criterion(outputs, masks)        # Calcolo la loss
            total_loss += loss.item()

            preds = outputs.argmax(1)               # Predizione delle classi
            
            # Calcolo delle metriche
            iou.append(np.nanmean(IoU(preds, masks)))
            dice.append(np.nanmean(dice_score(preds, masks)))

    return total_loss / len(loader), np.nanmean(iou), np.nanmean(dice)
