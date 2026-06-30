import torch
from typing import Optional, Union, List
from segmentation_models_pytorch.encoders import get_encoder
from segmentation_models_pytorch.base import SegmentationHead, SegmentationModel
from segmentation_models_pytorch.decoders.unet.decoder import UnetDecoder

class Unet(SegmentationModel):

    def __init__(self, 
                 encoder_name: str = 'resnet34', encoder_depth: int = 5, encoder_weights: Optional[str] = 'imagenet',
                 decoder_use_batchnorm: bool = True, decoder_channels: List[int] = (256, 128, 64, 32, 16),
                 in_channels: int = 3, classes: int = 5, activation: Optional[Union[str, callable]] = None):
        
        super().__init__()
        
        self.encoder = get_encoder(encoder_name, in_channels, encoder_depth, encoder_weights)
        self.decoder = UnetDecoder(self.encoder.out_channels, decoder_channels, encoder_depth, decoder_use_batchnorm)
        self.segmentation_head = SegmentationHead(decoder_channels[-1], classes, kernel_size=3, activation=activation)
        self.classification_head = None
        
        self.name = f'unet_{encoder_name}'
        self.initialize()

    def forward(self, x):
        features = self.encoder(x)
        x = self.decoder(features)
        return self.segmentation_head(x)

