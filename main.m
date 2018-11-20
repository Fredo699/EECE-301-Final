SAMPRATE = 40000
N = 32768
dt = N / SAMPRATE
t = linspace(0, dt, N)

FREQ = 5400 * 2 * pi
x = sqrt(2) * sin(FREQ * t)

