from tensorflow.keras.preprocessing import image
from tensorflow.keras.models import load_model
import matplotlib.pyplot as plt
import numpy as np

def load_images(img_path, size=(32, 32)):
    '''Function per caricare e preprocessare una immagine'''

    img = image.load_img(img_path, target_size=size)
    img = image.img_to_array(img) / 255.0
    return np.expand_dims(img, axis=0)

def predictions(model, image_dictionary):
    '''Function per le previsioni su un dizionario'''

    results = {}
    for img_name, img_path in image_dictionary.items():
        img = load_images(img_path)
        pred = model.predict(img, verbose=0)
        results[img_name] = np.argmax(pred)
    return results

def shows(results):
    '''Function per i risultati'''

    for name, pred in results.items():
        print(f"{name}: Classe predetta {pred}")

def shows_predictions(image_dictionary, results):
    '''Function per mostrare le immagini con la previsione'''

    for name, path in image_dictionary.items():
        img = image.load_img(path)
        plt.imshow(img)
        plt.title(f"{name}: Classe predetta {results[name]}")
        plt.axis('off')
        plt.show()

if __name__ == "__main__":
    
    test_set = {
        "Personal": {
            "Cartello 3": "./images/test/personal/sign_3.jpg",
            "Cartello 9": "./images/test/personal/sign_9.jpg",
            "Cartello 17": "./images/test/personal/sign_17.jpg",
            "Cartello 31": "./images/test/personal/sign_31.jpg",            
            "Cartello 39": "./images/test/personal/sign_39.jpg"
        },
        "Internet": {
            "Cartello 13": "./images/test/internet/sign_13.jpg",
            "Cartello 19": "./images/test/internet/sign_19.jpg",
            "Cartello 25 (doppio)": "./images/test/internet/sign_25_double.jpg",
            "Cartello 25": "./images/test/internet/sign_25.jpeg",
            "Cartello 39": "./images/test/internet/sign_39.jpg"
        },
        "Particular": {
            "Cartello 1": "./images/test/particular/sign_1.jpg",
            "Cartello 4": "./images/test/particular/sign_4.jpg",
            "Cartello 9": "./images/test/particular/sign_9.jpg",
            "Cartello 18": "./images/test/particular/sign_18.jpg",
            "Cartello 25": "./images/test/particular/sign_25.jpg",
            "Cartello 29": "./images/test/particular/sign_29.jpg",
            "Cartello 30": "./images/test/particular/sign_30.jpg",
            "Cartello 33": "./images/test/particular/sign_33.jpg",
            "Cartello 40": "./images/test/particular/sign_40.jpg"
        }
    }
    
    model = load_model('./models/lenetpro.h5')
    #model = load_model('./models/lenetplus.h5')
    #model = load_model('./models/lenet.h5')
    
    for name, dictionary in test_set.items():
        print(f"Risultati per: {name}")
        results = predictions(model, dictionary)
        #shows(results)
        shows_predictions(dictionary, results)
        print("\n")
