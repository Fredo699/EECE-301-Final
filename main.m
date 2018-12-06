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

clf;
plot(t(1:100), x(1:100), "b-", t(1:100), r(1:100), "g-", t(1:100));
legend("Clean signal", "Noisy signal");
xlabel("t");
%pause;

% Part C4, controlling SNR_dB
target_SNRDB = 20;
target_SNR = 10^(target_SNRDB / 10)
b = 1 / target_SNR;

r = x + sqrt(b) * v;

meas_SNRDB = 10*log10(sum(x.^2)/sum((sqrt(b)*v).^2))

clf;
plot(t(1:100), x(1:100), "b-", t(1:100), r(1:100), "g-");
legend("Clean signal", sprintf("Noisy signal\nSNR_{dB} = %f", meas_SNRDB));
xlabel("t");

% Part D, processing noisy signal
Pn = b

SAMP_SNR = zeros([1 6]);
S = log2(2.^(9+[1:6]));

clf;
for i = 1:6
  Nr = 2 ^ (9 + i);
  F3 = [-Nr/2:Nr/2-1]/Nr;
  R = abs(fft(r(1:Nr)));
  R = fftshift(R);
  R = 20*log10(R);
  PNF = 10*log10(Pn * Nr);
  subplot(3, 2, i);
  plot(F3, R, "b-", F3, PNF*ones([1 Nr]), "r-");
  xlabel('frequency / f_x');
  ylabel('dB');
  axis([-0.8, 0.8, -40, 100]); grid on;
  SNR_out = max(R) - PNF;
  SAMP_SNR(i) = SNR_out;
endfor

clf;
plot(S, SAMP_SNR, "-o");
xlabel("log_2(N)");
ylabel("SNR_{out} (dB)");

% Part D4, zero-padding DFT

clf;
for i = 1:6
  Nr = 2 ^ (9 + i);
  F3 = [-2*Nr:2*Nr-1]/(4*Nr);
  R = abs(fft([r(1:Nr), zeros([1 (3*Nr)])]));
  R = fftshift(R);
  R = 20*log10(R);
  PNF = 10*log10(Pn * Nr);
  subplot(3, 2, i);
  plot(F3, R, "b-", F3, PNF*ones([1 4*Nr]), "r-");
  xlabel('frequency / f_x');
  ylabel('dB');
  axis([-0.8, 0.8, -40, 100]); grid on;
  SNR_out = max(R) - PNF;
  SAMP_SNR(i) = SNR_out;
endfor
%pause;

clf;
plot(S, SAMP_SNR, "-o");
xlabel("log_2(N)");
ylabel("SNR_{out} (dB)");
