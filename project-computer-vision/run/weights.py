import torch
import numpy as np, cv2, os

MASK_DIR = './archive/masks'
NUM_CLASSES = 5

def load_masks():
    '''Caricamento della lista dei nomi delle maschere'''

    return [f for f in os.listdir(MASK_DIR) if f.lower().endswith('.png')]

def count_pixel(mask_dir, mask_files):
    '''Calcolo del num. totale di pixel per ogni classe del dataset e quello complessivo'''

    count = np.zeros(NUM_CLASSES, dtype=np.int64)
    total = 0

    for f in mask_files:
        path = os.path.join(mask_dir, f)
        mask = cv2.imread(path, cv2.IMREAD_GRAYSCALE)
        if mask is None:
            continue

        # Conteggio pixel per classe
        for c in range(NUM_CLASSES):
            count[c] += int((mask == c).sum())
        
        # Totale pixel dell'immagine
        total += mask.size
    
    return count, total

def class_weights(count, total):
    '''
        Calcolo delle frequenze delle classi ed i pesi bilanciati
        Due possibilita' di pesi: IF, LS
    '''
    # Frequenza relativa di ogni classe
    freq = count / total
    print(f'Frequenze: {freq}.\n')

    # Inverse frequency
    ift = 1.0 / (freq + 1e-6)
    ift = ift / np.mean(ift)
    print(f'Pesi Ift: {ift} | Tensor: {torch.tensor(ift, dtype=torch.float32)}\n')

    # Log-Smoothed
    ls = 1.0 / np.log(1.02 + freq)
    ls = ls / np.mean(ls)    
    print(f'Pesi Ls: {ls} | Tensor: {torch.tensor(ls, dtype=torch.float32)}\n')


def main():
    mask_files = load_masks()
    count, total = count_pixel(MASK_DIR, mask_files)
    print(f'Count: {count}.\nTotal: {total}.')
    class_weights(count, total)

if __name__ == '__main__':
    main()