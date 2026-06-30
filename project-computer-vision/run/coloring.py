import matplotlib.pyplot as plt
import torch, cv2
from run.infer import color_map

MASK_DIR = './archive/masks'
N = 10
PALETTE = {
    0: (0, 0, 0),        # Sfondo - Nero
    1: (34, 139, 34),    # Auto - Forest Green
    2: (205, 133, 63),   # Ruote - Peru
    3: (255, 215, 0),    # Fanali - Gold
    4: (0, 191, 255)     # Finestrini - Deep Sky Blue
}

def plot(mask):
    plt.figure(figsize=(6, 6)); plt.imshow(mask); plt.axis('off'); plt.show()

def main():    
    plot(color_map(torch.from_numpy(cv2.imread('./test/mask_test.png', cv2.IMREAD_GRAYSCALE)).long()))

if __name__ == '__main__':
    main()