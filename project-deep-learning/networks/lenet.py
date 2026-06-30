import tensorflow as tf
from tensorflow.keras import models, layers
from sklearn.metrics import confusion_matrix, classification_report
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

def load_data(data_dir, classes):
    '''Function per il caricamento dei dati'''

    X_train = np.load(f'{data_dir}/X_augmented.npy')
    y_train = np.load(f'{data_dir}/y_augmented.npy')
    X_val = np.load(f'{data_dir}/X_val.npy')
    y_val = np.load(f'{data_dir}/y_val.npy')
    X_test = np.load(f'{data_dir}/X_test.npy')
    y_test = np.load(f'{data_dir}/y_test.npy')

    y_train = tf.keras.utils.to_categorical(y_train, classes)
    y_val = tf.keras.utils.to_categorical(y_val, classes)
    y_test = tf.keras.utils.to_categorical(y_test, classes)

    return X_train, y_train, X_val, y_val, X_test, y_test

def LeNet5(input_shape, classes):
    '''LeNet 5 structure'''

    model = models.Sequential([
        layers.Input(shape=input_shape),
        layers.Conv2D(6, kernel_size=(5, 5), activation='relu', padding='same'),
        layers.AveragePooling2D(pool_size=(2, 2), strides=2),
        layers.Conv2D(16, kernel_size=(5, 5), strides=1, activation='relu'),
        layers.AveragePooling2D(pool_size=(2, 2), strides=2),

        layers.Flatten(),
        layers.Dense(units=120, activation='relu'),
        layers.Dense(units=84, activation='relu'),
        layers.Dense(units=classes, activation='softmax')
    ])
    return model

def CnnPlus(input_shape, classes):
    '''LeNet 5 Plus structure'''

    model = models.Sequential([
        layers.Input(shape=input_shape),
        
        layers.Conv2D(32, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.MaxPooling2D(pool_size=(2, 2), strides=2),
        
        layers.Conv2D(64, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.MaxPooling2D(pool_size=(2, 2), strides=2),
        
        layers.Conv2D(128, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.MaxPooling2D(pool_size=(2, 2), strides=2),
        
        layers.Flatten(),
        layers.Dense(256, activation='relu'),
        layers.Dropout(0.5),
        layers.Dense(128, activation='relu'),
        layers.Dropout(0.5),
        layers.Dense(classes, activation='softmax')
    ])
    return model

def CnnPro(input_shape, classes):
    '''LeNet 5 Pro structure'''

    model = models.Sequential([
        layers.Input(shape=input_shape),
        
        layers.Conv2D(32, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.Conv2D(32, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.AveragePooling2D(pool_size=(2, 2), strides=2),
        
        layers.Conv2D(64, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.Conv2D(64, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.AveragePooling2D(pool_size=(2, 2), strides=2),
        
        layers.Conv2D(128, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.Conv2D(128, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.AveragePooling2D(pool_size=(2, 2), strides=2),
        
        layers.Conv2D(256, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.Conv2D(256, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.AveragePooling2D(pool_size=(2, 2), strides=2),

        layers.Conv2D(512, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.Conv2D(512, kernel_size=(3, 3), activation='relu', padding='same'),
        layers.BatchNormalization(),
        layers.AveragePooling2D(pool_size=(2, 2), strides=2),

        layers.GlobalAveragePooling2D(),        
        layers.Dense(512, activation='relu'),
        layers.BatchNormalization(),
        layers.Dropout(0.5),
        layers.Dense(256, activation='relu'),
        layers.BatchNormalization(),
        layers.Dropout(0.5),
        layers.Dense(128, activation='relu'),
        layers.BatchNormalization(),
        layers.Dropout(0.5),
        layers.Dense(classes, activation='softmax')
    ])
    return model

# layers.GlobalAveragePooling2D() al posto di layers.Flatten() per una variante

def compile_net(model):
    '''Compile method'''

    model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=['accuracy'])
    #model.compile(optimizer='adam', loss='categorical_crossentropy', metrics=[tf.keras.metrics.Recall()])
    return model

def train_net(model, X_train, y_train, X_val, y_val, epochs=20, batch_size=128):
    '''Training'''

    history = model.fit(X_train, y_train, epochs=epochs, batch_size=batch_size, validation_data=(X_val, y_val), verbose=1)
    return history

def evaluate_net(model, X_test, y_test):
    '''Evaluate'''

    score = model.evaluate(X_test, y_test, verbose=0)
    print('\nTest loss:', score[0])
    print('Test accuracy:', score[1])
    #print('Test recall:', score[1])
    return score

def plot_history(history):
    plt.figure(figsize=(12, 5))
    plt.subplot(1, 2, 1)
    plt.plot(history.history['accuracy'], label='Train acc')
    plt.plot(history.history['val_accuracy'], label='Validation acc')
    #plt.plot(history.history['recall'], label='Train recall')
    #plt.plot(history.history['val_recall'], label='Validation recall')
    plt.title('Accuracy')
    #plt.title('Recall')
    plt.legend()

    plt.subplot(1, 2, 2)
    plt.plot(history.history['loss'], label='Train')
    plt.plot(history.history['val_loss'], label='Val')
    plt.title('Loss')
    plt.legend()
    plt.show()

def confusion(model, X_test, y_test, labels=None):
    
    y_pred = model.predict(X_test, verbose=0)
    y_pred_classes = np.argmax(y_pred, axis=1)
    y_true_classes = np.argmax(y_test, axis=1)

    confusion = confusion_matrix(y_true_classes, y_pred_classes)

    plt.figure(figsize=(10, 8))
    sns.heatmap(confusion, annot=True, fmt='d', cmap='Blues',
                xticklabels=labels if labels is not None else range(confusion.shape[0]),
                yticklabels=labels if labels is not None else range(confusion.shape[0]))
    plt.xlabel('Predicted')
    plt.ylabel('True')
    plt.title('Confusion Matrix')
    plt.show()
    print(classification_report(y_true_classes, y_pred_classes, target_names=labels))

if __name__ == "__main__":
    X_train, y_train, X_val, y_val, X_test, y_test = load_data('./dataset', 43)

    #model = LeNet5((32, 32, 3), 43)
    #model = CnnPlus((32, 32, 3), 43)
    model = CnnPro((32, 32, 3), 43)

    model = compile_net(model)
    model.summary()

    history = train_net(model, X_train, y_train, X_val, y_val)
    evaluate_net(model, X_test, y_test)
    plot_history(history)
    #confusion(model, X_test, y_test)

    #model.save('./models/lenet.h5')
    #model.save('./models/lenetplus.h5')
    model.save('./models/lenetpro.h5')