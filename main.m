# Part A, sinusoid
SAMPRATE = 40000;
Fs = SAMPRATE;
N = 32768;
dt = N / SAMPRATE;
t = linspace(0, dt, N);

FREQ = 5400;
w = FREQ  * 2 * pi;
x = sqrt(2) * sin(w * t);

F = [-N/2:N/2-1]/N;
X = abs(fft(x));
X = fftshift(X);

X = 20*log10(X);

[mag index] = max(X');
meas_freq = abs(F(index) * SAMPRATE)
freq_err = abs(FREQ - meas_freq) / FREQ
plot(F, X);
xlabel('frequency / f_x');
ylabel('dB');

#pause;

# Part B, noise
Pn = 1 # standard deviation of noise = noise power
v = Pn * randn(size(x));
Nv = 4096;

F2 = [-Nv/2:Nv/2-1]/Nv;
V = abs(fft(v(1:Nv)));
V = fftshift(V);

V = 20*log10(V);

clf;
# This is 10 because the 2 is associated with power,
# and is already taken care of.
PNF = 10*log10(Pn * Nv)
line (F2(:), [V(:) V(:)], "linestyle", "-", "color", "b");
line (F2(:), [PNF PNF], "linestyle", "-", "color", "r");
xlabel('frequency / f_x');
ylabel('dB');

# Part C, received signal
r = x + v;
SNRDB = 10*log10(sum(x.^2)/sum(v.^2))

R = abs(fft(r));
R = fftshift(R);

R = 20*log10(R);

clf;
plot(t(1:100), x(1:100), "b-", t(1:100), r(1:100), "g-", t(1:100), SNRDB*ones(100), "r-");
legend("Clean signal", "Noisy signal", "SNR (dB)");
xlabel("t");

target_SNRDB = -20;
target_SNR = (target_SNRDB / 10)^10
b = 1 / target_SNR;

r = x + sqrt(b) * v;

meas_SNRDB = 10*log10(sum(x.^2)/sum((sqrt(b)*v).^2))

clf;
plot(t(1:100), x(1:100), "b-", t(1:100), r(1:100), "g-", t(1:100), SNRDB*ones(100), "r-");
legend("Clean signal", "Noisy signal", "SNR (dB)");
xlabel("t");
