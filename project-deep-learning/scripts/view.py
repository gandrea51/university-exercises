import matplotlib.pyplot as plt
from PIL import Image
import numpy as np
import os, random, collections

def load_dataset(data_dir):
    '''Function per l'upload del dataset'''

    X_before = np.load(os.path.join(data_dir, 'X_train.npy'))
    Y_before = np.load(os.path.join(data_dir, 'y_train.npy'))
    X_after = np.load(os.path.join(data_dir, 'X_augmented.npy'))
    Y_after = np.load(os.path.join(data_dir, 'y_augmented.npy'))

    return X_before, Y_before, X_after, Y_after

def get_image(X, Y, class_id):
    '''Function per recuperare la prima immagine di una classe'''

    for i in range(len(Y)):
        if Y[i] == class_id:
            return X[i]
    return None

def plot_image(X_bef, Y_bef, X_aft, Y_aft, classes):
    '''Function per il confronto tra immagini'''

    fig, axes = plt.subplots(2, len(classes), figsize=(10, 6))
    fig.suptitle('Confronto immagini prima e dopo la Data Augm.', fontsize=14)
    
    for index, class_id in enumerate(classes):
        img_initial = get_image(X_bef, Y_bef, class_id)
        img_augmented = get_image(X_aft, Y_aft, class_id)

        axes[0, index].imshow(img_initial)
        axes[0, index].set_title(f'Classe {class_id}: Prima')
        axes[0, index].axis('off')

        axes[1, index].imshow(img_augmented)
        axes[1, index].set_title(f'Classe {class_id}: Augm.')
        axes[1, index].axis('off')
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    X_train, Y_train, X_augmented, Y_augmented = load_dataset('./dataset')

    #classes = [15, 24, 41]
    #classes = [21, 26, 27]
    classes = [0, 32, 37]
    plot_image(X_train, Y_train, X_augmented, Y_augmented, classes)
