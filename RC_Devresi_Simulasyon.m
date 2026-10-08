%% RC Devresi - Gecici Rejim Analizi
% Aysel Zeynep Kavakli
% Yildiz Teknik Universitesi - Devre Analizi Odevi

clear all; close all; clc;

%% Devre Parametreleri
R   = 1000;       % Direnc [Ohm] - 1 kOhm
C   = 100e-6;     % Kondansator [F] - 100 uF
Vs  = 10;         % Kaynak gerilimi [V]
tau = R * C;      % Zaman sabiti [s]

fprintf('=== RC DEVRESI PARAMETRELERI ===\n');
fprintf('R   = %.0f Ohm\n', R);
fprintf('C   = %.0f uF\n',  C*1e6);
fprintf('Vs  = %.0f V\n',   Vs);
fprintf('tau = %.3f s = %.0f ms\n', tau, tau*1000);

%% Analitik Cozum
t = linspace(0, 5*tau, 1000);

% Kondansator gerilimi: v_C(t) = Vs*(1 - e^(-t/tau))
vC  = Vs * (1 - exp(-t / tau));

% Devre akimi: i(t) = (Vs/R)*e^(-t/tau)
i_t = (Vs / R) * exp(-t / tau);

% Kondansator enerjisi: W_C = 0.5*C*vC^2
WC  = 0.5 * C * vC.^2;

fprintf('\n=== ONEMLI DEGERLER ===\n');
fprintf('t = tau   => vC = %.4f V (%.2f%%)\n', Vs*(1-exp(-1)), (1-exp(-1))*100);
fprintf('t = 5*tau => vC = %.4f V (%.2f%%)\n', Vs*(1-exp(-5)), (1-exp(-5))*100);
fprintf('W_C maks  = %.4f mJ\n', 0.5*C*Vs^2*1000);

%% Grafik 1: Kondansator Gerilimi
figure('Name','RC Devresi Analizi','NumberTitle','off','Position',[100 100 1200 400]);

subplot(1,3,1);
plot(t*1000, vC, 'b-', 'LineWidth', 2.0);
hold on;
yline(Vs, 'k--', 'LineWidth', 1.0, 'Label', 'Vs = 10 V');
xline(tau*1000, 'r:', 'LineWidth', 1.5, 'Label', sprintf('tau=%.0f ms', tau*1000));
plot(tau*1000, Vs*(1-exp(-1)), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
xlabel('Zaman (ms)', 'FontSize', 11);
ylabel('v_C(t)  [V]', 'FontSize', 11);
title('Kondansator Gerilimi v_C(t)', 'FontSize', 12, 'FontWeight', 'bold');
legend('v_C(t)', 'Vs', 'tau', 'Location', 'southeast');
grid on; ylim([-0.5 11.5]);

%% Grafik 2: Devre Akimi
subplot(1,3,2);
plot(t*1000, i_t*1000, 'r-', 'LineWidth', 2.0);
hold on;
xline(tau*1000, 'b:', 'LineWidth', 1.5, 'Label', sprintf('tau=%.0f ms', tau*1000));
xlabel('Zaman (ms)', 'FontSize', 11);
ylabel('i(t)  [mA]', 'FontSize', 11);
title('Devre Akimi i(t)', 'FontSize', 12, 'FontWeight', 'bold');
legend('i(t)', 'tau', 'Location', 'northeast');
grid on;

%% Grafik 3: Kondansator Enerjisi
subplot(1,3,3);
plot(t*1000, WC*1000, 'g-', 'LineWidth', 2.0);
hold on;
yline(0.5*C*Vs^2*1000, 'k--', 'LineWidth', 1.0, ...
    'Label', sprintf('W_{maks}=%.1f mJ', 0.5*C*Vs^2*1000));
xlabel('Zaman (ms)', 'FontSize', 11);
ylabel('W_C(t)  [mJ]', 'FontSize', 11);
title('Kondansator Enerjisi W_C(t)', 'FontSize', 12, 'FontWeight', 'bold');
grid on;

sgtitle('RC Devresi - Gecici Rejim Analizi (R=1kOhm, C=100uF, Vs=10V)', ...
    'FontSize', 13, 'FontWeight', 'bold');

saveas(gcf, fullfile('docs','RC_Grafik.png'));
fprintf('\nGrafik kaydedildi: docs/RC_Grafik.png\n');

%% Simulink Modeli Olusturma (opsiyonel)
% Simulink modeli manuel olarak asagidaki bloklarla kurulabilir:
%   Step -> Gain(1/tau) -> Integrator -> vC cikisi
%   Geri besleme: vC -> Gain(-1) -> Toplama noktasina
%
% Alternatif: Transfer fonksiyonu ile
%   H(s) = 1/(tau*s + 1) = 10/(0.1*s + 1)

fprintf('\n=== TRANSFER FONKSIYONU ===\n');
fprintf('H(s) = 1 / (tau*s + 1) = 1 / (%.2f*s + 1)\n', tau);

fprintf('Kutup: s = -1/tau = %.2f rad/s\n', -1/tau);
