import albumentations as A
from albumentations.pytorch import ToTensorV2
import cv2

def transformation():
    '''
        Trasformazioni per training e validation/test set
        Maschere: interpolazione Nearest, non normalizzate, etichette mantenute
    '''

    # Training: Data Augmentation
    train_transform = A.Compose([
        A.HorizontalFlip(p=0.5),
        A.Affine(translate_percent=0.05, scale=(0.85, 1.15), rotate=(-10, 10), 
                 border_mode=cv2.BORDER_CONSTANT, p=0.5),

        A.RandomBrightnessContrast(0.2, 0.2, p=0.5),    # Variazioni di luminosità e contrasto
        A.GaussNoise(std_range=(0.02, 0.05), p=0.2),
        A.ColorJitter(0.2, 0.2, 0.2, 0.1, p=0.3),       # Alterazione di luminosità, contrasto, saturazione e tonalità
    
        A.Resize(512, 512),
        A.Normalize(mean=(0.485, 0.456, 0.406), std=(0.229, 0.224, 0.225)),
        ToTensorV2()
    ])

    # Val / Test: Trasformazioni
    val_transform = A.Compose([
        A.Resize(512, 512),
        A.Normalize(mean=(0.485, 0.456, 0.406), std=(0.229, 0.224, 0.225)),
        ToTensorV2()
    ])

    return train_transform, val_transform