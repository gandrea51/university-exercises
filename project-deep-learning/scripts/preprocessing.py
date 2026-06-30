import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from PIL import Image
import os, random, collections

def load_image(image):
    '''Function per l'upload dell'immagine'''

    try:
        img = Image.open(image)
        return img
    except Exception as exp:
        print(f'Error while uploading image: {exp}')
        return None

def rectangle_area(image, roi):
    '''Function per mostrare la ROI sull'immagine'''

    x1, y1, x2, y2 = roi
    width = x2 - x1
    height = y2 - y1

    plt.imshow(image)
    plt.gca().add_patch(plt.Rectangle((x1, y1), width, height, linewidth=1, edgecolor='g', facecolor='none'))
    plt.axis('off')
    plt.show()

def crop_image(image, roi):
    '''Function per ritagliare l'immagine secondo le ROI'''

    x1, y1, x2, y2 = roi
    cropped = image.crop((x1, y1, x2, y2))
    return cropped

def resize_image(image, size=(32, 32)):
    '''Function per il resize dell'immagine'''

    resized = image.resize(size)
    return np.array(resized) / 255.0

def distribution(Y):
    '''Function per mostrare la distribuzione delle classi'''

    count = collections.Counter(Y)
    print('Distribuzione classi:')
    for key, value in sorted(count.items()):
        print(f'Classe {key}: {value} immagini')

def save_dataset(X, Y, output_dir):
    '''Function per salvare immagini e etichette'''

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    np.save(os.path.join(output_dir, 'X.npy'), X)
    np.save(os.path.join(output_dir, 'Y.npy'), Y)
    print(f'Dati salvati in {output_dir}')


if __name__ == '__main__':

    # List per immagini e per le etichette
    X = []
    Y = []

    # Loop per ogni cartella
    for folder in range(43):
        class_path = os.path.join('./data', f'{folder:05d}')
        file_path = os.path.join(class_path, f'GT-{folder:05d}.csv')

        if not os.path.exists(file_path):
            print(f'File non trovato: {file_path}')
            continue

        # Open del file CSV
        f = pd.read_csv(file_path, sep=";")
        
        if not f.empty:
            for i, row in f.iterrows():
                image_path = os.path.join(class_path, row['Filename'])
                roi = (row['Roi.X1'], row['Roi.Y1'], row['Roi.X2'], row['Roi.Y2'])
                image = load_image(image_path)

                # Mostro solo la prima immagine
                if i == 0:
                    rectangle_area(image, roi)
                
                # Preprocessing
                cropped = crop_image(image, (row['Roi.X1'], row['Roi.Y1'], row['Roi.X2'], row['Roi.Y2']))
                resized = resize_image(cropped)

                X.append(resized)
                Y.append(row['ClassId'])

    # Conversione delle liste a numpy arrays
    X = np.array(X)
    Y = np.array(Y)
    print(f'{X.shape[0]} immagini, {Y.shape[0]} etichette')
    distribution(Y)
    save_dataset(X, Y, './list')