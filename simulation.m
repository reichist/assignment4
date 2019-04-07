function [] = simulation(simulation_length, time_step, source_function, figure_number)

global G C b V
figure(figure_number)
clf

steps = simulation_length/time_step;

oldV = V;
oldk = 0;
 A = C/time_step + G;
    for k = 1:steps
        t = (k-1)*time_step;

        V = A\(C.*oldV/time_step + b*source_function(t));


        figure(figure_number)
        plot([oldk k], [oldV(5) V(5)], 'r');
        hold on;
%         plot([oldk k], [oldV(8) V(8)], 'b');
        title('Time vs Vo');
        xlabel('Time (ms)'); ylabel('Vo (V)');
%         legend('Vo', 'Vin');
        xlim([0 steps]); %ylim([-1 1]);
        grid on;

        oldk = k;
        oldV = V;
    end
end