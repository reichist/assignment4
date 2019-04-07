clear
clc

% Variables
global G C b;
nodes = 5; % number of nodes in circuit

% AC sweep of Vo(w)
f = linspace(1, 1e6, 1e7+1);
Vo = zeros(size(f));
gain = zeros(size(f));

% Variable sizes
r1 = 1; r2 = 2; r3 = 10; r4 = 0.1; ro = 1000; 
c = 0.25; 
l = 0.2; 

alpha = 100;
% Setup G, C and b matrices
G = zeros(nodes, nodes);
C = zeros(nodes, nodes); 
b = zeros(nodes, 1);
vin = 1;
        
% Initialize components in circuit
% V(1-5) are nodes 1-5
resistor(1, 2, r1); 
capacitor(1, 2, c);
resistor(2, 0, r2);
inductor(2, 3, l); % V(6)
resistor(3, 0, r3); 
resistor(4, 5, r4); 
resistor(5, 0, ro);
voltage_controlled_voltage_source(4, 0, 3, 0, alpha/r3); % V(7)
voltage_source(1, 0, vin); % V(8)

for z = 1:length(f)    
    % Find solution
    omega = 2*pi*f(z);
    V = (G+j*omega.*C)\b; 
    Vo(z) = V(5);
    gain(z) = 20*log10(Vo(z));
    
    if rem(z, 1000) == 0
        fprintf('AC Sweep Completion at %3.2f%%, freq = %3.1fkHz\n', z*100/length(f), f(z)/1000);
    end
end

figure(1)
clf
subplot(211)
semilogx(f, Vo);
title('Frequency vs Vo');
xlabel('Frequency (Hz)'); ylabel('Vo (V)');
grid on;

subplot(212)
semilogx(f, gain);
title('Gain of V0/V1');
xlabel('Frequency'); ylabel('Gain (dB)');
grid on;

% Deliverables
% a) AC plot of Vo as a function of frequency
% b) Gain of Vo/Vin in dB