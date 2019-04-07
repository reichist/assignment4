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
c = 0.25; 
l = 0.2; 

alpha = 100; 
vin = -10:0.01:10;
Vo = zeros(size(vin));
V3 = zeros(size(vin));

% Initialize components in circuit
for z = 1:length(vin)
    G = zeros(nodes, nodes);
    C = zeros(nodes, nodes); 
    b = zeros(nodes, 1);
    
    resistor(1, 2, r1); 
    capacitor(1, 2, c);
    resistor(2, 0, r2);
    inductor(2, 3, l);
    resistor(3, 0, r3); 
    resistor(4, 5, r4); 
    resistor(5, 0, ro);
    voltage_controlled_voltage_source(4, 0, 3, 0, alpha/r3);
    voltage_source(1, 0, vin(z));
    
    V = G\b;
    
    Vo(z) = V(5);
    V3(z) = V(3);
end

% Plotting
figure(1)
clf
plot(vin, Vo, 'r', vin, V3, 'b');
title('Vin vs Vo and V3');
legend('Vo (V)', 'V3 (V)');
xlabel('Vin (V)'); ylabel('Vo, V3 (V)');
grid on;

G
C
b

% Deliverables
% a) DC sweep input of Vo and V3