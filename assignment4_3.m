clear
clc

% Variables
global G C b;
nodes = 5; % number of nodes in circuit

% Initialize global variables
G = zeros(nodes, nodes);
C = zeros(nodes, nodes); 
b = zeros(nodes, 1);

% Variable sizes
r1 = 1; r2 = 2; r3 = 10; r4 = 0.1; ro = 1000; 
c1 = 0.25; cn = 0.00001;
l = 0.2; 
In = 0.001;

alpha = 100; 
vin = 1;

resistor(1, 2, r1); 
capacitor(1, 2, c1);
resistor(2, 0, r2);
inductor(2, 3, l);
resistor(3, 0, r3); 
current_source(3, 0, In);
resistor(4, 5, r4); 
resistor(5, 0, ro);
voltage_controlled_voltage_source(4, 0, 3, 0, alpha/r3);
voltage_source(0, 1, vin);
capacitor(3, 0, cn);

steps = 1000;
t = 1/steps;
time = linspace(0, 1, steps);
b1 = zeros(size(b));
b2 = zeros(size(b));
x = zeros(size(b));
vout1 = zeros(size(time));
vout2 = zeros(size(time));

gaussian_pulse = makedist('normal', 'mu', 0.06, 'sigma', 0.03);
pulse_function = pdf(gaussian_pulse, time);
pulse3 = pulse_function/max(pulse_function);


% Pulse simulation
for z = 2:steps
    b1(6) = pulse3(z-1);
    b2(6) = pulse3(z);
    result = (2*C/t-G)*x+b2+b2;
    x1 = (2*C/t+G)\result;
    vout2(z) = x(5)*2;
    x = x1;
    vout1(z-1) = x(5);
end

vout1(z) = x(5);

vout1 = -vout1;

figure(1)
clf

subplot(311)
plot(time, pulse3, time, vout1); 
title('Vin vs Vout');
xlabel('Time (s)'); ylabel('Voltage (V)');
grid on;

subplot(312)
plot(abs(fftshift(fft(pulse3))));
title('FFT of Vin');
grid on;

subplot(313)
plot(abs(fftshift(fft(vout1))));
title('FFT of Vout');
grid on;

random_current = In*randn(1, steps);

figure(2)
clf

subplot(211)
histogram(random_current);
title('Noise Current Distribution');
xlabel('Current(A)'); ylabel('Frequency of Data Points');
grid on;

gaussian_distribution = makedist('normal', 'mu', 0.4, 'sigma', 0.03);
pulse_function = pdf(gaussian_distribution, time);
pulse3 = pulse_function/max(pulse_function);

b1(:) = 0;
b2(:) = 0;
x(:) = 0;
vout1(:) = 0;
vout2(:) = 0;
omega = logspace(0, 5, 20*steps);

for z = 2:steps
    b1(3) = random_current(z);
    b1(6) = pulse3(z);
    b2(6) = pulse3(z-1);
    result = (2*C/t-G)*x+b1+b2;
    x1 = (2*C/t+G)\result;
    vout2(z) = x(5)*2;
    x = x1;
    vout1(z-1) = x(5);
end
vout1(z) = x(5);

vout1 = -vout1;

subplot(212)
plot(time, pulse3, time, vout1)
title('Vin vs Vout');
xlabel('Time s)'); ylabel('Voltage (V)');
legend('Vin', 'Vout');
grid on;

% Initialize global variables
G = zeros(nodes, nodes);
C = zeros(nodes, nodes); 
b = zeros(nodes, 1);

% Variable sizes
r1 = 1; r2 = 2; r3 = 10; r4 = 0.1; ro = 1000; 
c1 = 0.25; cn = 0.00001;
l = 0.2; 
In = 0.001;

alpha = 100; 
vin = 1;

resistor(1, 2, r1); 
capacitor(1, 2, c1);
resistor(2, 0, r2);
inductor(2, 3, l);
resistor(3, 0, r3); 
current_source(3, 0, In);
resistor(4, 5, r4); 
resistor(5, 0, ro);
voltage_controlled_voltage_source(4, 0, 3, 0, alpha/r3);
voltage_source(0, 1, vin);
capacitor(3, 0, cn);

F = zeros(8, 1);
F(7) = 1;

C

for z = 1:length(omega)
    voltage = (G + ((1j*omega(z)).*C))\F;
    vo(z) = voltage(5);
end

gain = 20*log10(vo);

figure(3)
clf

semilogx(omega, vo);
title('Vout(omega)');
xlabel('Omega (rad/s)'); ylabel('Voltage (V)');
xlim([10e0 10e4]);
grid on;

figure(4)
clf

semilogx(omega, gain);
title('Gain');
xlabel('Omega (rad/s)'); ylabel('Gain (db)');
grid on;


% Deliverables
% a) Updated C matrix
% b) Plot of Vo with noise source
% c) Fourier Transform plot
% d) plot of Fourier Transform
% e) 3 plots of Vo with different values of Co
% f) 2 plots of Vo with different time steps