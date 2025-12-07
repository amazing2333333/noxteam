import librosa
import librosa.display
import numpy as np
import matplotlib.pyplot as plt

# 加载音频文件
# sr:保留原始采样率
y, sr = librosa.load('Mel_Spectrogram/audio.mp3', sr=None)

# S梅尔谱矩阵，n_mels梅尔滤波器数量，fmax计算时考虑的最高频率
# 计算梅尔频谱图
S = librosa.feature.melspectrogram(y=y, sr=sr, n_mels=128, fmax=8000)

# 对梅尔频谱图取对数--适合机器学习，范围小
log_S = librosa.power_to_db(S, ref=np.max)

# 计算MFCC:梅尔倒谱系数
mfccs = librosa.feature.mfcc(S=log_S, n_mfcc=13)

# 可视化梅尔频谱图
plt.figure(figsize=(12, 6))
plt.subplot(2, 1, 1)
librosa.display.specshow(log_S, sr=sr, x_axis='time', y_axis='mel')
plt.title('Mel Spectrogram')
plt.colorbar(format='%+02.0f dB')

# 可视化MFCC
plt.subplot(2, 1, 2)
librosa.display.specshow(mfccs, sr=sr, x_axis='time')
plt.title('MFCC')
plt.colorbar()
plt.tight_layout()
plt.show()

