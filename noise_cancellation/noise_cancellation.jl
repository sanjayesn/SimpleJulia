
using WAV
using Plots

ntracks = 3;
sec = 5;
Fs = 44100; # Sampling frequency

# Ambient measurements
A = zeros(sec*Fs, ntracks); # K=3 noise samples of five sec each
A[:,1], Fs = wavread("resources/tsunami_cut.wav");
A[:,2], Fs = wavread("resources/static_cut.wav");
A[:,3], Fs = wavread("resources/symphony_cut.wav");

# Noisy signal we want to estimate
n, Fs = wavread("resources/n_train.wav");

# Sound to denoise:
noisy, Fs = wavread("resources/noisy_target.wav");

plot((1:length(noisy))/Fs, noisy,  title="Noisy Signal", xlabel="Time (seconds)", label="")

# Generate theta to minimize noise in signal
theta = zeros(Fs)
theta = A \ -n
;

# Generate denoised audio signal
denoised = zeros(Fs)
c = A * theta
denoised = noisy + c

plot((1:length(denoised))/Fs, denoised,  title="Denoised Signal", xlabel="Time (seconds)", label="")
