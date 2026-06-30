import numpy as np
import os, collections

def load_dataset(data_dir):
    '''Function per l'upload del dataset'''

    X = np.load(os.path.join(data_dir, 'X_augmented.npy'))
    Y = np.load(os.path.join(data_dir, 'y_augmented.npy'))
    print(f'Dataset originale: {X.shape[0]} immagini')
    return X, Y


def distribution(Y):
    '''Function per mostrare la distribuzione delle classi'''

    count = collections.Counter(Y)
    print('Distribuzione classi:')
    for key, value in sorted(count.items()):
        print(f'Classe {key}: {value} immagini')

if __name__ == "__main__":
    X, Y = load_dataset('./dataset')
    distribution(Y)