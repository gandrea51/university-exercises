import torch
import numpy as np, random
import matplotlib.pyplot as plt
from dataset.loader import dataloader
from run.evaluate_metrics import load_model
from run.infer import color_map

DEVICE = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
CLASSES = 5
SAMPLES = 3
MODEL_PATH = './model/unet_mit.pth'
IMG_DIR = './archive/images'
MASK_DIR = './archive/masks'

def get_sample(loader):
    '''Estrazione di 3 immagini random dal test set'''

    all_images, all_masks = [], []
    for image, mask in loader:
        for i, m in zip(image, mask):
            all_images.append(i), all_masks.append(m)
    
    index = random.sample(range(len(all_images)), SAMPLES)
    images = torch.stack([all_images[i] for i in index])
    masks = torch.stack([all_masks[i] for i in index])
    return images.to(DEVICE), masks.to(DEVICE)

def predict(model, images):
    '''Predict delle maschere date le immagini'''

    model.eval()
    with torch.no_grad():
        outputs = model(images)
        preds = torch.argmax(outputs, dim=1)
    return preds

def plotting(images, preds):

    mean = np.array([0.485, 0.456, 0.406])
    std = np.array([0.229, 0.224, 0.225])
    
    plt.figure(figsize=(12, 6))
    for i in range(SAMPLES):
        image = images[i].cpu().permute(1, 2, 0).numpy()
        image = std * image + mean 
        image = np.clip(image, 0, 1)
        pred = color_map(preds[i])

        ax1 = plt.subplot(2, SAMPLES, i + 1)
        ax1.imshow(image); ax1.set_title(f'Immagine {i + 1}'); ax1.axis('off')
        ax2 = plt.subplot(2, SAMPLES, SAMPLES + i + 1)
        ax2.imshow(pred); ax2.set_title(f'Predizione {i + 1}'); ax2.axis('off')
    plt.tight_layout()
    plt.show()

def main():

    _, _, test = dataloader(IMG_DIR, MASK_DIR)
    model = load_model(MODEL_PATH, DEVICE)
    
    images, _ = get_sample(test)
    preds = predict(model, images)
    plotting(images, preds)

if __name__ == '__main__':
    main()
