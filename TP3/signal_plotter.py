import numpy as np
import matplotlib.pyplot as plt

# Original loader: reads 16-bit binary strings as uint16
def load_signal(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    data = np.array([int(line.strip(), 2) for line in lines], dtype=np.uint16)
    return data

# New loader: reads 16-bit binary strings and applies two's-complement → int16
def load_signal_signed(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()
    data = np.array([twos_complement(line.strip()) for line in lines], dtype=np.int16)
    return data

def twos_complement(binary_str):
    bits = len(binary_str)
    value = int(binary_str, 2)
    if value & (1 << (bits - 1)):
        value -= (1 << bits)
    return value

# File names (adjust paths as needed).
noisy_signal_file    = "./TP3/data/noisy_signal.txt"
filtered_signal_file = "./TP5/filtered_signal_output.txt"

# Load the signals:
noisy_signal    = load_signal_signed(noisy_signal_file)      # stays as uint16 (no two's-complement)
filtered_signal = load_signal_signed(filtered_signal_file)  # int16, two's-complement applied

# Sampling frequency.
Fs = 10000

# Time vectors (cast filtered_signal to int32 to remove bias if needed later).
t_noisy    = np.linspace(0, len(noisy_signal)   / Fs, len(noisy_signal),   endpoint=False)
t_filtered = np.linspace(0, len(filtered_signal)/ Fs, len(filtered_signal), endpoint=False)

# FFT computation (remove bias for analysis).
def compute_fft(signal, Fs):
    dc_offset = 32768
    centered = signal.astype(np.int32) - dc_offset
    fft_vals = np.fft.fft(centered.astype(np.float64))
    fft_mag  = np.abs(fft_vals)
    freqs    = np.fft.fftfreq(len(signal), 1/Fs)
    pos_mask = freqs >= 0
    return freqs[pos_mask], fft_mag[pos_mask]

# Compute FFT of the filtered (signed) signal
f_filtered, fft_filtered = compute_fft(filtered_signal.astype(np.uint16), Fs)

##############################################
# Plotting: Compare Noisy vs. Filtered Signal & FFT.
##############################################
fig, axs = plt.subplots(3, 1, figsize=(12, 12))

axs[0].plot(t_noisy, noisy_signal, label='Noisy Signal (biased)', color='purple')
axs[0].set_xlim(0, 0.1)
axs[0].set_xlabel('Time [s]')
axs[0].set_ylabel('Amplitude')
axs[0].set_title('Noisy Signal (uint16)')
axs[0].legend()

axs[1].plot(t_filtered, filtered_signal, label='Filtered Signal (signed)', color='red')
axs[1].set_xlim(0, 0.1)
axs[1].set_xlabel('Time [s]')
axs[1].set_ylabel('Amplitude')
axs[1].set_title('Filtered Signal (int16)')
axs[1].legend()

axs[2].plot(f_filtered, fft_filtered, label='FFT of Filtered Signal', color='blue')
axs[2].set_xlim(0, 1000)
axs[2].set_xlabel('Frequency [Hz]')
axs[2].set_ylabel('Magnitude')
axs[2].set_title('FFT of Filtered Signal (after bias removal)')
axs[2].legend()

fig.suptitle('Figure: Noisy vs. Filtered Signal & FFT', fontsize=16)
plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.show()

fig.savefig("../plots/filtered_signal.png", dpi=300, bbox_inches="tight")
