import numpy as np, cv2, random, os
import matplotlib.pyplot as plt

MASK_DIR = './archive/masks'
CLASSES = ['Sfondo', 'Scocca', 'Ruote', 'Fanali', 'Finestrini']

def get_mask(mask_path: str, extension=('.png',)) -> str:
    '''Selezione random di una maschera'''

    mask_file = [f for f in os.listdir(mask_path) if f.endswith(extension)]
    if not mask_file:
        raise FileNotFoundError(f'Nessun file in {mask_path} con estensione {extension}.')
    return os.path.join(mask_path, random.choice(mask_file))

def load_mask(mask_path: str) -> np.ndarray:
    '''Lettura di una maschera in scala di grigi'''
    
    mask = cv2.imread(mask_path, cv2.IMREAD_GRAYSCALE)
    if mask is None:
        raise ValueError(f'Lettura del file {mask_path} non riuscita.')
    return mask

def count_pixels(mask: np.ndarray, num_classes: int) -> list:
    '''Conteggio dei pixel di ogni classe'''

    return [np.sum(mask == i) for i in range(num_classes)]

def plot_pixel(pixel_counts: list, classes: list, title: str) -> None:
    '''Plot della distribuzione dei pixel in una maschera'''

    print(f'Conteggio dei pixel: {pixel_counts}.')
    plt.figure(figsize=(8, 5))
    plt.bar(classes, pixel_counts, color='skyblue')
    plt.title(title)
    plt.xlabel('N. pixel')
    plt.ylabel('Classe')
    plt.show()

def main():
    mask_path = get_mask(MASK_DIR)
    title = f'Distribuzione pixel per {os.path.basename(mask_path)}'
    mask = load_mask(mask_path)
    pixel_counts = count_pixels(mask, len(CLASSES))
    plot_pixel(pixel_counts, CLASSES, title)

if __name__ == '__main__':
    main()