
using WAV
using Plots

# Read audio file
x, f = wavread("resources/imperial_march.wav")
x = vec(x)
t = (1:length(x))/f

plot(t, x,  title="Original Signal", xlabel="Time (seconds)", label="")

# Create audio filter to smooth signal

# 1 millisecond moving average of x
h_smooth = 1/44 * ones(44)

# Convolve h_smooth and x to filter audio 
sm_output = conv(h_smooth, x)

sm_t = (1:length(sm_output))/f
plot(sm_t, sm_output,  title="Smoothed Signal", xlabel="Time (seconds)", label="")

# Form h_echo which, when convolved with x, adds an echo representing a 0.25 second delay


# Size is number of samples in 0.25 seconds plus 1 for offset
h_echo = zeros(44100 * 0.25 + 1)
h_echo[1] = 1
h_echo[length(h_echo)] = 0.5
;

# Create output using convolution
ec_output = conv(h_echo, x)

# Isolate just the echo
echo = ec_output[1:length(x)] - x

plot(t, x,  label="Original")
plot!(t, echo,  title="Signal and Echo",xlabel="Time (seconds)",
     label="Echo")

# Write smoothed and echo audio files
wavwrite(sm_output, f, "imperial_march_smoothed.wav")
wavwrite(ec_output, f, "imperial_march_echo.wav")
