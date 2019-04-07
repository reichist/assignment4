clear
clc

figure(1)
clf

% Variables
global G C b
nodes = 5; % number of nodes in circuit

% Initialize global variables
G = zeros(nodes, nodes);
C = zeros(nodes, nodes); 
b = zeros(nodes, 1);


% Variable sizes
r1 = 1; r2 = 2; r3 = 10; r4 = 0.1; ro = 1000; 
c1 = 0.25; 
l = 0.2; 
voltage_source_value = 1;

alpha = 100; 

% Initialize components in circuit
resistor(1, 2, r1); 
capacitor(1, 2, c1);
resistor(2, 0, r2);
inductor(2, 3, l);
resistor(3, 0, r3); 
resistor(4, 5, r4); 
resistor(5, 0, ro);
voltage_controlled_voltage_source(4, 0, 3, 0, alpha/r3);
voltage_source(0, 1, voltage_source_value);

% Simulation Setup
steps = 1000;
t = 1/steps;
time = linspace(0, 1, steps);
b1 = zeros(size(b));
b2 = zeros(size(b));
x = zeros(size(b));
pulse1 = zeros(size(time));
pulse2 = zeros(size(time));
pulse3 = zeros(size(time));
vin = zeros(size(time));
vout1 = zeros(size(time));
vout2 = zeros(size(time));

step_time_transition = 0.03;

% Step Simulation
for z = 2:steps
    for p = 1:steps
        if time(p) < step_time_transition
            pulse1(p) = 0;
        else
            pulse1(p) = 1;
        end
    end
    b1(6) = pulse1(z-1);
    b2(6) = pulse1(z);
    result = (2*C/t-G)*x+b2+b1;
    x1 = (2*C/t+G)\result;
    vout2(z) = x(5)*2;
    x = x1;
    vout1(z-1) = x(5);
    if rem(z, 10) == 0
        fprintf('Simulation 1: %3.0f%% Completion\n', z/10*length(steps));
    end
end

vout1(z) = x(5);

figure(1)
clf

subplot(311)
plot(time, pulse1, time, -vout1);
title('Vin vs Vout');
xlabel('Time (s)'); ylabel('Voltage (V)');
legend('Vin', 'Vout');
grid on;

subplot(312)
plot(abs(fftshift(fft(pulse1))));
title('FFT of Vin');
grid on;

subplot(313)
value = abs(fftshift(fft(vout1)));
plot(value);
title('FFT of Vout');
grid on;

% Sin simulation
for z = 2:steps
    for p = 1:steps
        pulse2(p) = sin(2*pi*(1/step_time_transition)*time(p));
    end
    b1(6) = pulse2(z-1);
    b2(6) = pulse2(z);
    result = (2*C/t-G)*x+b1+b2;
    x1 = (2*C/t+G)\result;
    vout2(z) = x(5)*2;
    x = x1;
    vout1(z-1) = x(5);
    if rem(z, 10) == 0
        fprintf('Simulation 2: %3.0f%% Completion\n', z/10*length(steps));
    end
end

vout1(z) = x(5);

figure(2)
clf

subplot(311)
plot(time, pulse2, time, -vout1);
title('Vin vs Vout');
xlabel('Time (s)'); ylabel('Voltage(V)');
legend('Vin', 'Vout');
grid on;

subplot(312)
plot(abs(fftshift(fft(pulse2))));
title('FFT of Vin');
grid on;

subplot(313)
plot(abs(fftshift(fft(vout1))));
title('FFT of Vout');
grid on;

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
    if rem(z, 10) == 0
        fprintf('Simulation 3: %3.0f%% Completion\n', z/10*length(steps));
    end
end

vout1(z) = x(5);

figure(3)
clf

subplot(311)
plot(time, pulse3, time, -vout1);
title('Vin vs Vout');
xlabel('Time (s)'); ylabel('Voltage(V)');
legend('Vin', 'Vout');
grid on;

subplot(312)
plot(abs(fftshift(fft(pulse3))));
title('FFT of Vin');
grid on;

subplot(313)
plot(abs(fftshift(fft(vout1))));
title('FFT of Vout');
grid on;

% Deliverables
% a) C and G matrices
% b) Plot of DC sweep
% c) Plots from AC case of gain (Vo/Vi)
% d) Plot of Vin and Vout from numerical solution in time domain
% e) Fourier Transform plots of Frequency Response