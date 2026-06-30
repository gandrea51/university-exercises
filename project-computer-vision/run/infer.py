import torch
import albumentations as A
from albumentations.pytorch import ToTensorV2
from architecture.unet_mit import Unet
import cv2, os, numpy as np

COLOR_PALETTE = {
    0: (0, 0, 0),       # Nero
    1: (34, 139, 34),   # Auto - Green forest
    2: (205, 133, 63),  # Ruote - Peru 
    3: (255, 215, 0),   # Fanali - Gold
    4: (0, 191, 255)    # Finestrini - Deep sky blu
}

DEVICE = 'cuda' if torch.cuda.is_available() else 'cpu'
EXTENSIONS = ('.png',)
TARGET_SIZE = (512, 512)
MODEL_PATH = './model/unet_mit.pth'
INPUT_DIR = './images/cars'
OUTPUT_DIR = './images/mit'

def load_model(model_path: str, device: str, num_classes: int=5) -> torch.nn.Module:
    '''Caricamento del modello in modalita' valutazione'''

    model = Unet().to(device)
    model.load_state_dict(torch.load(model_path, map_location=device))
    model.eval()

    print(f'Modello caricato da {model_path} su {device}')
    return model

def create_transform(target_size: tuple) -> A.Compose:
    '''Pipeline di preprocessing per le immagini'''

    return A.Compose([
        A.Resize(target_size[0], target_size[1], interpolation=cv2.INTER_LINEAR),
        A.Normalize(mean=(0.485, 0.456, 0.406), std=(0.229, 0.224, 0.225)),
        ToTensorV2()
    ])

def color_map(mask_tensor: torch.Tensor) -> np.ndarray:
    '''Conversione della maschera in immagine RGB'''

    if isinstance(mask_tensor, torch.Tensor):
        mask_array = mask_tensor.cpu().numpy()
    else:
        mask_array = mask_tensor
    
    H, W = mask_array.shape
    image = np.zeros((H, W, 3), dtype=np.uint8)

    for id, color in COLOR_PALETTE.items():
        image[mask_array == id] = color
    return image

def process_image(model: torch.nn.Module, img_path: str, transform: A.Compose, output_dir: str) -> None:
    '''Inferenza su una immagine'''

    image = cv2.cvtColor(cv2.imread(img_path), cv2.COLOR_BGR2RGB)
    processed = transform(image=image)
    image_tensor = processed['image'].to(DEVICE).unsqueeze(0)

    with torch.no_grad():
        output = model(image_tensor)
        pred_mask = torch.argmax(output, dim=1).squeeze(0)
        color_mask = color_map(pred_mask)
    
    # Resize della maschera alla risoluzione originale
    mask_resized = cv2.resize(color_mask, (image.shape[1], image.shape[0]), interpolation=cv2.INTER_NEAREST)
    # Sovrapposizione
    overlay = cv2.addWeighted(image, 0.5, mask_resized, 0.5, 0)

    os.makedirs(output_dir, exist_ok=True)
    name = os.path.basename(img_path)
    cv2.imwrite(os.path.join(output_dir, f'mask_{name}'), cv2.cvtColor(mask_resized, cv2.COLOR_RGB2BGR))
    cv2.imwrite(os.path.join(output_dir, f'cover_{name}'), cv2.cvtColor(overlay, cv2.COLOR_RGB2BGR))

def run_inference(model: torch.nn.Module, input_dir: str, output_dir: str, transform: A.Compose) -> None:
    '''Inferenza su tutte le immagini della directory'''

    files = [f for f in os.listdir(input_dir) if f.lower().endswith(EXTENSIONS)]
    if not files:
        print(f'Nessuna immagine in {input_dir}.')
        return
    print(f'Inferenza su {len(files)}.')

    for file in files:
        process_image(model, os.path.join(input_dir, file), transform, output_dir)

def main():
    if not os.path.exists(MODEL_PATH):
        print(f'Modello non trovato nel path: {MODEL_PATH}.')
        return
    
    model = load_model(MODEL_PATH, DEVICE)
    transform = create_transform(TARGET_SIZE)
    run_inference(model, INPUT_DIR, OUTPUT_DIR, transform)
    print(f'Inferenza completata, output: {OUTPUT_DIR}.')

if __name__ == '__main__':
    main()