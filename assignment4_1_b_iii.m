clear
clc

% AC sweep with C perturbation
global G C b
% Setup variables
nodes = 5;

r1 = 1; r2 = 2; r3 = 10; r4 = 0.1; ro = 1000; 
c = 0.25; 
l = 0.2; 

alpha = 100; 
vin = 1;

G = zeros(nodes, nodes);
C = zeros(nodes, nodes); 
b = zeros(nodes, 1);
        
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

r = 0.05*randn(1, 10000);
omega = pi;
gain = zeros(size(r));

for z = 1:length(r)    
    % Find solution
    V = (G + 1j*2*pi*omega .* r(z) .* C) \ b; 
    gain(z) = 20*log10(abs(V(5)));
end

figure(3)
clf
hist(gain, 150);
title('Gain of V0/V1 with perturbations');
xlabel('Gain (db)'); ylabel('Number of Data Points');
grid on;

% Deliverables
% a) AC gain histogram with perturbations on C