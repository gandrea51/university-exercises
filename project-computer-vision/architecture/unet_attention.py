import torch
import torch.nn as nn

class Unet(nn.Module):

    def __init__(self, num_classes: int = 5):
        super().__init__()

        self.enc1 = self.conv_block(3, 32)
        self.enc2 = self.conv_block(32, 64)
        self.enc3 = self.conv_block(64, 128)
        self.enc4 = self.conv_block(128, 256)

        self.pool = nn.AvgPool2d(2)
        self.dropout = nn.Dropout(0.3)

        self.bottleneck = self.conv_block(256, 512)

        self.up4 = nn.ConvTranspose2d(512, 256, 2, stride=2)
        self.ag4 = AttentionGate(256, 256, 128)
        self.dec4 = self.conv_block(512, 256)

        self.up3 = nn.ConvTranspose2d(256, 128, 2, stride=2)
        self.ag3 = AttentionGate(128, 128, 64)
        self.dec3 = self.conv_block(256, 128)

        self.up2 = nn.ConvTranspose2d(128, 64, 2, stride=2)
        self.ag2 = AttentionGate(64, 64, 32)
        self.dec2 = self.conv_block(128, 64)

        self.up1 = nn.ConvTranspose2d(64, 32, 2, stride=2)
        self.ag1 = AttentionGate(32, 32, 16)
        self.dec1 = self.conv_block(64, 32)

        self.classifier = nn.Conv2d(32, num_classes, 1)

    def forward(self, x):

        x1 = self.enc1(x)
        x2 = self.enc2(self.pool(x1))
        x3 = self.enc3(self.pool(x2))
        x4 = self.enc4(self.pool(x3))

        latent = self.dropout(self.bottleneck(self.pool(x4)))

        d4 = self.up4(latent)
        x4 = self.ag4(x4, d4)
        d4 = self.dec4(torch.cat([d4, x4], dim=1))

        d3 = self.up3(d4)
        x3 = self.ag3(x3, d3)
        d3 = self.dec3(torch.cat([d3, x3], dim=1))

        d2 = self.up2(d3)
        x2 = self.ag2(x2, d2)
        d2 = self.dec2(torch.cat([d2, x2], dim=1))

        d1 = self.up1(d2)
        x1 = self.ag1(x1, d1)
        d1 = self.dec1(torch.cat([d1, x1], dim=1))

        return self.classifier(d1)

    def conv_block(self, in_channels: int, out_channels: int) -> nn.Sequential:
        return nn.Sequential(
            nn.Conv2d(in_channels, out_channels, 3, padding=1),
            nn.BatchNorm2d(out_channels),
            nn.ReLU(True),
            nn.Conv2d(out_channels, out_channels, 3, padding=1),
            nn.BatchNorm2d(out_channels),
            nn.ReLU(True),
        )

class AttentionGate(nn.Module):
    '''
    Decide quali parti delle feature dell'encoder sono importanti usando il decoder
    '''
    def __init__(self, decoder_channels, encoder_channels, channels):
        super().__init__()

        self.decoder = nn.Sequential(           # Cosa sto cercando
            nn.Conv2d(decoder_channels, channels, kernel_size=1),
            nn.BatchNorm2d(channels)
        )

        self.encoder = nn.Sequential(           # Cosa vedo
            nn.Conv2d(encoder_channels, channels, kernel_size=1),
            nn.BatchNorm2d(channels)
        )
        
        # Attention map
        self.attention = nn.Sequential(
            nn.Conv2d(channels, 1, kernel_size=1),
            nn.BatchNorm2d(1),
            nn.Sigmoid()
        )

        self.relu = nn.ReLU(inplace=True)

    def forward(self, enc, dec):
        att = self.relu(self.decoder(dec) + self.encoder(enc))
        att = self.attention(att)
        return enc * att