from matplotlib.patches import Patch
import matplotlib.pyplot as plt
import numpy as np, os, random
import cv2

COLOR_PALETTE = {
    0: (0, 0, 0),       # Nero
    1: (34, 139, 34),   # Auto - Green forest
    2: (205, 133, 63),  # Ruote - Peru 
    3: (255, 215, 0),   # Fanali - Gold
    4: (0, 191, 255)    # Finestrini - Deep sky blu
}

IMG_DIR = './archive/images'
MASK_DIR = './archive/masks'
CLASSES = ['Sfondo', 'Scocca', 'Ruote', 'Fanali', 'Finestrini']

def loading(img_path: str, mask_path: str, extension=('.png',), n_images=3) -> tuple:
    '''Selezione random di n immagini e relative maschere (convertite)'''

    files = [f for f in os.listdir(img_path) if f.endswith(extension)]
    selected_files = random.sample(files, n_images)

    images, masks = [], []
    for file in selected_files:
        image = cv2.imread(os.path.join(img_path, file))
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        mask = cv2.imread(os.path.join(mask_path, file), cv2.IMREAD_GRAYSCALE)
        
        images.append(image)
        masks.append(mask)
    
    return images, masks

def color_mask(mask: np.ndarray, palette: dict) -> np.ndarray:
    '''Conversione di una marchera in immagine RGB usando una palette'''

    mask_rgb = np.zeros((mask.shape[0], mask.shape[1], 3), dtype=np.uint8)
    for i, color in palette.items():
        mask_rgb[mask == i] = color
    return mask_rgb

def plotting(images: list, masks: list, classes: list, palette: dict) -> None:
    '''Plot delle immagini originali e delle ground truth'''
    
    n = len(images)
    legend = [Patch(facecolor=np.array(color)/255, label=cls) for cls, color in zip(classes, palette.values())]

    plt.figure(figsize=(5*n, 8))
    for i in range(n):
        plt.subplot(2, n, i+1)
        plt.imshow(images[i]); plt.title(f'Immagine {i+1}'); plt.axis('off')

        plt.subplot(2, n, i+1+n)
        plt.imshow(masks[i]); plt.title(f'Maschera {i+1}'); plt.axis('off')

    plt.legend(handles=legend, bbox_to_anchor=(1.05, 1), loc='upper left')
    plt.tight_layout()
    plt.show()

def main():    
    images, masks = loading(IMG_DIR, MASK_DIR, n_images=3)
    masks_rgb = [color_mask(m, COLOR_PALETTE) for m in masks]
    plotting(images, masks_rgb, CLASSES, COLOR_PALETTE)

if __name__ == '__main__':
    main()