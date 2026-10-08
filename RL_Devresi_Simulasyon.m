%% RL Devresi - Gecici Rejim Analizi
% Aysel Zeynep Kavakli
% Yildiz Teknik Universitesi - Devre Analizi Odevi

clear all; close all; clc;

%% Devre Parametreleri
R   = 50;         % Direnc [Ohm]
L   = 0.5;        % Endüktans [H]
Vs  = 24;         % Kaynak gerilimi [V]
tau = L / R;      % Zaman sabiti [s]
Iss = Vs / R;     % Kararli durum akimi [A]

fprintf('=== RL DEVRESI PARAMETRELERI ===\n');
fprintf('R   = %.0f Ohm\n', R);
fprintf('L   = %.2f H\n',   L);
fprintf('Vs  = %.0f V\n',   Vs);
fprintf('tau = %.4f s = %.2f ms\n', tau, tau*1000);
fprintf('I_ss = Vs/R = %.4f A\n', Iss);

%% Analitik Cozum
t = linspace(0, 5*tau, 1000);

% Endüktör akimi: i_L(t) = (Vs/R)*(1 - e^(-Rt/L))
iL  = Iss * (1 - exp(-t / tau));

% Endüktör gerilimi: v_L(t) = Vs*e^(-t/tau)
vL  = Vs * exp(-t / tau);

% Endüktör enerjisi: W_L = 0.5*L*iL^2
WL  = 0.5 * L * iL.^2;

fprintf('\n=== ONEMLI DEGERLER ===\n');
fprintf('t = tau   => iL = %.4f A\n', Iss*(1-exp(-1)));
fprintf('t = 5*tau => iL = %.4f A\n', Iss*(1-exp(-5)));
fprintf('W_L maks  = %.4f mJ\n', 0.5*L*Iss^2*1000);

%% Grafikler
figure('Name','RL Devresi Analizi','NumberTitle','off','Position',[100 100 1200 400]);

subplot(1,3,1);
plot(t*1000, iL, 'b-', 'LineWidth', 2.0);
hold on;
yline(Iss, 'k--', 'LineWidth', 1.0, 'Label', sprintf('I_{ss}=%.2f A', Iss));
xline(tau*1000, 'r:', 'LineWidth', 1.5, 'Label', sprintf('tau=%.1f ms', tau*1000));
plot(tau*1000, Iss*(1-exp(-1)), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
xlabel('Zaman (ms)', 'FontSize', 11);
ylabel('i_L(t)  [A]', 'FontSize', 11);
title('Endüktör Akimi i_L(t)', 'FontSize', 12, 'FontWeight', 'bold');
grid on;

subplot(1,3,2);
plot(t*1000, vL, 'r-', 'LineWidth', 2.0);
hold on;
xline(tau*1000, 'b:', 'LineWidth', 1.5, 'Label', sprintf('tau=%.1f ms', tau*1000));
xlabel('Zaman (ms)', 'FontSize', 11);
ylabel('v_L(t)  [V]', 'FontSize', 11);
title('Endüktör Gerilimi v_L(t)', 'FontSize', 12, 'FontWeight', 'bold');
grid on;

subplot(1,3,3);
plot(t*1000, WL*1000, 'g-', 'LineWidth', 2.0);
hold on;
yline(0.5*L*Iss^2*1000, 'k--', 'LineWidth', 1.0, ...
    'Label', sprintf('W_{maks}=%.1f mJ', 0.5*L*Iss^2*1000));
xlabel('Zaman (ms)', 'FontSize', 11);
ylabel('W_L(t)  [mJ]', 'FontSize', 11);
title('Endüktör Enerjisi W_L(t)', 'FontSize', 12, 'FontWeight', 'bold');
grid on;

sgtitle('RL Devresi - Gecici Rejim Analizi (R=50Ohm, L=0.5H, Vs=24V)', ...
    'FontSize', 13, 'FontWeight', 'bold');

saveas(gcf, fullfile('docs','RL_Grafik.png'));
fprintf('\nGrafik kaydedildi: docs/RL_Grafik.png\n');

fprintf('\n=== TRANSFER FONKSIYONU ===\n');
fprintf('H(s) = 1 / (L/R*s + 1) = 1 / (%.3f*s + 1)\n', tau);
fprintf('Kutup: s = -R/L = %.2f rad/s\n', -1/tau);
