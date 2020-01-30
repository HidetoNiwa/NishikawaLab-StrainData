import csv
import pprint
import numpy as np
from numpy.fft import fftn, ifftn, fftfreq
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
floatData= [[0] * 4000 for i in range(2)]
for i in range(4000):
    time=0+(i)/100
    floatData[0][i]=time
    floatData[1][i]=float(l[i][0])

#fft計算
# 単位時間あたりに, いくつのデータ点が存在しているか.
sampling_rate = 100
z=fftn(floatData[1])
freq = fftfreq(len(floatData[1]), d=1 / sampling_rate)

fig, axes = plt.subplots(figsize=(10, 5), ncols=2, sharey=True)
ax = axes[0]
ax.plot(freq[1:int(len(floatData[1]) / 2)], abs(z[1:int(len(floatData[1]) / 2)]))
ax.set_yscale('log')
ax.set_xlabel('Freq(周波数) Hz',fontname="MS Gothic")
ax.set_ylabel('Power')

# 周波数 f → 周期 T に直して表示する
# 周期は fT = 1 を満たすので単に逆数にすれば良い
ax = axes[1]
ax.plot(1 / freq[1:int(len(floatData[1]) / 2)], abs(z[1:int(len(floatData[1]) / 2)]))
ax.set_yscale('log')
ax.set_xlabel('T(周期) s',fontname="MS Gothic")
ax.set_xscale('log')

save_fig(fig, name='sample_wave_fft.png')

G=z.copy()

fc = 10        # カットオフ周波数
fs = 100     # サンプリング周波数
fm = (1/2) * fs # アンチエリアジング周波数
fc_upper = fs - fc # 上側のカットオフ　fc～fc_upperの部分をカット

# ローパス
G[((freq > fc)&(freq< fc_upper))] = 0 + 0j

# 高速逆フーリエ変換
g = np.fft.ifft(G)

# 実部の値のみ取り出し
g = g.real

#plt2.subplot(121)
#グラフプロット
plt2.title('経過時間-時定数(前脛骨筋)', fontname="MS Gothic")
#前脛骨筋（Tibialis anterior）
plt2.xlabel('経過時間(s)', fontname="MS Gothic")
plt2.ylabel('時定数(us)', fontname="MS Gothic")
plt2.plot(floatData[0],floatData[1],marker='.',linewidth = 0.1)
#plt2.subplot(122)
plt2.plot(floatData[0], g,marker='.',linewidth = 0.1)
plt2.legend(["元データ","ローパス適用後"], prop={"family":"MS Gothic"})
plt2.show()
