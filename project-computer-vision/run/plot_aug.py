import matplotlib.pyplot as plt
import albumentations as A
import random, os, cv2

IMG_DIR = './archive/images'
MASK_DIR = './archive/masks'

def loading():
    file = random.choice([f for f in os.listdir(IMG_DIR) if f.endswith('.png')])
    
    image = cv2.cvtColor(cv2.imread(os.path.join(IMG_DIR, file)), cv2.COLOR_BGR2RGB)
    mask = cv2.imread(os.path.join(MASK_DIR, file), cv2.IMREAD_GRAYSCALE)
    return image, mask

def main():
    image, mask = loading()

    transform = A.Compose([
        A.HorizontalFlip(p=0.5),
        A.Affine(translate_percent=0.05, scale=(0.85, 1.15), rotate=(-10, 10), border_mode=cv2.BORDER_CONSTANT, p=0.4),
        A.GaussNoise(std_range=(0.02, 0.05), p=0.8),
    ])

    augmented = []
    for _ in range(3):
        output = transform(image=image, mask=mask)
        augmented.append((output['image'], output['mask']))
    
    plt.figure(figsize=(16, 8))
    plt.subplot(2, 4, 1); plt.imshow(image); plt.title('Immagine originale'); plt.axis('off')
    plt.subplot(2, 4, 5); plt.imshow(mask, cmap='gray'); plt.title('Maschera originale'); plt.axis('off')

    for i, (image_aug, mask_aug) in enumerate(augmented):
        plt.subplot(2, 4, i + 2)
        plt.imshow(image_aug); plt.title(f'Augment {i+1}'); plt.axis('off')
        plt.subplot(2, 4, i + 6)
        plt.imshow(mask_aug, cmap='gray'); plt.axis('off')
    
    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    main()
