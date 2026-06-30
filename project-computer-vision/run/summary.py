from torchinfo import summary
from architecture.unet_deep import Unet

def main():
    model = Unet()
    summary(model, (1, 3, 512, 512))
  
if __name__ == '__main__':
    main()
