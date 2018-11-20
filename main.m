SAMPRATE = 40000;
N = 32768;
dt = N / SAMPRATE;
t = linspace(0, dt, N);

FREQ = 5400 * 2 * pi;
x = sqrt(2) * sin(FREQ * t);

F = [-N/2:N/2-1]/N;
X = abs(fft(x));
X = fftshift(X);

plot(F, X);
[mag index] = max(X');
meas_freq = abs(F(index) * SAMPRATE)
freq_err = abs(FREQ - meas_freq) / FREQ
xlabel('frequency / f_x');
ylabel('dB');
