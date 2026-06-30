import torch

def IoU(preds: torch.Tensor, masks: torch.Tensor, num_classes: int=5) -> list:
    '''Intersection over union per classe'''

    preds, masks = preds.detach().cpu(), masks.detach().cpu()
    ious = []

    for c in range(num_classes):
        # Intersezione, Unione
        intersect = ((preds == c) & (masks == c)).sum().item()
        union = ((preds == c) | (masks == c)).sum().item()

        if union == 0:
            # Se una classe non è presente
            ious.append(float('nan'))
        else:
            # IoU
            ious.append(intersect / union)
    
    return ious

def dice_score(preds: torch.Tensor, masks: torch.Tensor, num_classes: int=5) -> list:
    '''Dice score per classe'''

    preds, masks = preds.detach().cpu(), masks.detach().cpu()
    dices = []

    for c in range(num_classes):
        # Intersezione, Denominatore (somma dei predetti e reali per la classe c)
        intersect = ((preds == c) & (masks == c)).sum().item()
        denom = (preds == c).sum().item() + (masks == c).sum().item()

        if denom == 0:
            # Se una classe non è presente
            dices.append(float('nan'))
        else:
            # Dice score
            dices.append(2 * intersect / denom)
    
    return dices
