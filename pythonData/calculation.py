import csv
import pprint
import numpy as np
from numpy.fft import fftn, ifftn, fftfreq
import scipy.signal as signal
import matplotlib.pyplot as plt
import matplotlib.pyplot as plt2

import os

output_dir = './fft_vis'
os.makedirs(output_dir, exist_ok=True)

def save_fig(fig, name):
    p = os.path.join(output_dir, name)
    print(f'save to {p}')
    fig.tight_layout()
    fig.savefig(p, dpi=120)

#CSVデータ取得
with open("./testExp/100Hz_ave_前脛骨筋_修理後3M2.csv","r",encoding="UTF-8") as data:
    reader = csv.reader(data)
    l = [row for row in reader]

#取得したCSVデータは文字列として扱われるので、floatに変換
floatData= [[0] * 2000 for i in range(2)]
for i in range(2000):
    time=0+(i)/100
    floatData[0][i]=time
    floatData[1][i]=float(l[i][0])

#グラフプロット
plt2.title('FreqTime-Time constant(Tibialis anterior)')
#前脛骨筋（Tibialis anterior）
plt2.xlabel('time(s)')
plt2.ylabel('time constant(us)')
plt2.plot(floatData[0],floatData[1],marker='.')
#plt2.show()

#fft計算
# 単位時間あたりに, いくつのデータ点が存在しているか. 
sampling_rate = 100
z=fftn(floatData[1])
freq = fftfreq(len(floatData[1]), d=1 / sampling_rate)

fig, axes = plt.subplots(figsize=(10, 5), ncols=2, sharey=True)
ax = axes[0]
ax.plot(freq[1:int(len(floatData[1]) / 2)], abs(z[1:int(len(floatData[1]) / 2)]))
ax.set_yscale('log')
ax.set_xlabel('Freq(周波数) Hz')
ax.set_ylabel('Power')

# 周波数 f → 周期 T に直して表示する
# 周期は fT = 1 を満たすので単に逆数にすれば良い
ax = axes[1]
ax.plot(1 / freq[1:int(len(floatData[1]) / 2)], abs(z[1:int(len(floatData[1]) / 2)]))
ax.set_yscale('log')
ax.set_xlabel('T(周期) s')
ax.set_xscale('log')

save_fig(fig, name='sample_wave_fft.png')

#以下、参考：https://org-technology.com/posts/low-pass-filter.html

dt=1/100                        # サンプリング間隔
fn = 1/(2*dt)                   # ナイキスト周波数
# パラメータ設定
fp = 2                          # 通過域端周波数[Hz]
fs = 3                          # 阻止域端周波数[Hz]
# 正規化
Wp = fp/fn
Ws = fs/fn

# ローパスフィルタで波形整形
# バターワースフィルタ
y1 = signal.lfilter(l[0], 1, x)