from sklearn.model_selection import train_test_split
import numpy as np
import os, collections

def load_dataset(data_dir):
    '''Function per l'upload del dataset'''

    X = np.load(os.path.join(data_dir, 'X.npy'))
    Y = np.load(os.path.join(data_dir, 'Y.npy'))
    print(f'Dataset originale: {X.shape[0]} immagini')
    return X, Y

def split(X, Y, test_size=0.15, val_size=0.15, random_state=42):
    '''Function per lo split del dataset in train, validation, test'''

    X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=test_size, stratify=Y, random_state=random_state)
    X_train, X_val, y_train, y_val = train_test_split(X_train, y_train, test_size=val_size, stratify=y_train, random_state=random_state)  
    return X_train, X_val, X_test, y_train, y_val, y_test

def save(output_dir, X_train, X_val, X_test, y_train, y_val, y_test):
    '''Function per salvare i dataset divisi'''

    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    np.save(os.path.join(output_dir, 'X_train.npy'), X_train)
    np.save(os.path.join(output_dir, 'y_train.npy'), y_train)
    np.save(os.path.join(output_dir, 'X_val.npy'), X_val)
    np.save(os.path.join(output_dir, 'y_val.npy'), y_val)
    np.save(os.path.join(output_dir, 'X_test.npy'), X_test)
    np.save(os.path.join(output_dir, 'y_test.npy'), y_test)
    print(f'Train: {X_train.shape[0]} immagini, Validation: {X_val.shape[0]} immagini, Test: {X_test.shape[0]} immagini')


if __name__ == "__main__":
    X, Y = load_dataset('./list')
    X_train, X_val, X_test, y_train, y_val, y_test = split(X, Y)
    save('./dataset', X_train, X_val, X_test, y_train, y_val, y_test)