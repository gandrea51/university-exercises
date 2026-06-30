from PIL import Image, ImageEnhance, ImageOps
import numpy as np
import random, collections, os

def load_dataset(data_dir):
    '''Function per l'upload del dataset'''

    X = np.load(os.path.join(data_dir, 'X_train.npy'))
    Y = np.load(os.path.join(data_dir, 'y_train.npy'))
    print(f'Dataset originale: {X.shape[0]} immagini')
    return X, Y

def zoom(image):
    '''Operazione di D.A.'''

    w, h = image.size
    cropped = random.uniform(0.85, 0.95)
    width, height = int(w*cropped), int(h*cropped)
    left = random.randint(0, w - width)
    top = random.randint(0, h - height)
    image = image.crop((left, top, left+width, top+height))
    return image.resize((w, h))

def saturation(image):
    '''Function per variare i colori'''

    return ImageEnhance.Color(image).enhance(random.uniform(0.7, 1.3))

def augmentation(image):
    '''Function per l'applicazione delle trasformazioni'''

    operation = [
        lambda x: x.rotate(random.uniform(-15, 15)),
        zoom,
        lambda x: ImageEnhance.Brightness(x).enhance(random.uniform(0.7, 1.3)),
        lambda x: ImageEnhance.Contrast(x).enhance(random.uniform(0.7, 1.3)),
        saturation,
    ]
    for o in random.sample(operation, k=random.randint(1, 3)):
        image = o(image)
    return image

def get_distribution(labels):
    '''Function per il conteggio delle classi'''

    return collections.Counter(labels)

def resize_image(image, size=(32, 32)):
    '''Funzion per il resize dell'immagine'''

    image = image.resize(size)
    return np.array(image) / 255.0

def generate_augmentation(images, number, size=(32, 32)):
    '''Function per generare immagini augmentate'''

    augmented = []
    for i in range(number):
        img = random.choice(images)
        aug = augmentation(img)
        resized = resize_image(aug, size)
        augmented.append(resized)

    return augmented

def data_augmentation(X, Y, treshold=420, size=(32, 32)):
    '''Function per la data augmentation sulle sotto-rappresentate'''

    count = get_distribution(Y)

    X_augmented = []
    y_augmented = []

    for id in range(43):
        current = count[id]
        if current >= treshold:
            continue

        needed = treshold - current
        print(f'Classe {id}: {current} vere + {needed} da generare')

        images = [Image.fromarray((X[i] * 255).astype(np.uint8)) for i in range(len(Y)) if Y[i] == id]
        
        augmented = generate_augmentation(images, needed, size)
        
        X_augmented.extend(augmented)
        y_augmented.extend([id] * needed)
    
    return np.array(X_augmented), np.array(y_augmented)

def save(X_init, Y_init, X_aug, Y_aug, output_dir):
    '''Function per salvare il dataset nuovo'''

    X_new = np.concatenate([X_init, X_aug], axis=0)
    Y_new = np.concatenate([Y_init, Y_aug], axis=0)

    idx = np.arange(len(X_new))
    np.random.shuffle(idx)
    X_new = X_new[idx]
    Y_new = Y_new[idx]

    np.save(os.path.join(output_dir, 'X_augmented.npy'), X_new)
    np.save(os.path.join(output_dir, 'y_augmented.npy'), Y_new)
    print(f'Dataset augmentato. {X_new.shape[0]} immagini')

if __name__ == "__main__":
    X, Y = load_dataset('./dataset')
    X_augmented, Y_augmented = data_augmentation(X, Y, treshold=420, size=(32, 32))
    save(X, Y, X_augmented, Y_augmented, './dataset')