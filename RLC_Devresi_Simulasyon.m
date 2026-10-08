%% RLC Devresi - Gecici Rejim Analizi (Üc Sonum Durumu)
% Aysel Zeynep Kavakli
% Yildiz Teknik Universitesi - Devre Analizi Odevi

clear all; close all; clc;

%% Devre Parametreleri (sabit)
L  = 0.1;        % Endüktans [H]
C  = 100e-6;     % Kondansator [F]
Vs = 12;         % Kaynak gerilimi [V]

omega0 = 1 / sqrt(L*C);          % Dogal frekans [rad/s]
R_krit = 2 * sqrt(L/C);          % Kritik direnc [Ohm]
f0     = omega0 / (2*pi);        % Dogal frekans [Hz]

fprintf('=== RLC DEVRESI SABIT PARAMETRELER ===\n');
fprintf('L      = %.2f H\n',      L);
fprintf('C      = %.0f uF\n',     C*1e6);
fprintf('Vs     = %.0f V\n',      Vs);
fprintf('omega0 = %.2f rad/s\n',  omega0);
fprintf('f0     = %.2f Hz\n',     f0);
fprintf('R_krit = %.4f Ohm\n',    R_krit);

%% Zaman ekseni
t = linspace(0, 0.12, 2000);

%% --- DURUM 1: ASIRI SONUMLU (R > R_krit) ---
R1    = 200;
alpha1 = R1/(2*L);
s1_p  = -alpha1 + sqrt(alpha1^2 - omega0^2);
s1_n  = -alpha1 - sqrt(alpha1^2 - omega0^2);
A2_1  = Vs*s1_p / (s1_p - s1_n);
A1_1  = Vs - A2_1;
vC1   = Vs - (A1_1*exp(s1_p*t) + A2_1*exp(s1_n*t));

fprintf('\n--- ASIRI SONUMLU (R=%.0f Ohm) ---\n', R1);
fprintf('alpha = %.2f rad/s,  zeta = %.3f\n', alpha1, alpha1/omega0);
fprintf('s1 = %.2f rad/s,  s2 = %.2f rad/s\n', s1_p, s1_n);

%% --- DURUM 2: KRITIK SONUMLU (R = R_krit) ---
R2     = R_krit;
alpha2 = R2/(2*L);
vC2    = Vs - (Vs + Vs*alpha2*t) .* exp(-alpha2*t);

fprintf('\n--- KRITIK SONUMLU (R=%.2f Ohm) ---\n', R2);
fprintf('alpha = %.2f rad/s,  zeta = %.3f\n', alpha2, alpha2/omega0);

%% --- DURUM 3: EKSIK SONUMLU (R < R_krit) ---
R3     = 10;
alpha3 = R3/(2*L);
omegaD = sqrt(omega0^2 - alpha3^2);
B3     = Vs * alpha3 / omegaD;
vC3    = Vs - exp(-alpha3*t) .* (Vs*cos(omegaD*t) + B3*sin(omegaD*t));

fprintf('\n--- EKSIK SONUMLU (R=%.0f Ohm) ---\n', R3);
fprintf('alpha  = %.2f rad/s,  zeta = %.3f\n', alpha3, alpha3/omega0);
fprintf('omegaD = %.2f rad/s\n', omegaD);
fprintf('Salınim periyodu = %.4f ms\n', 2*pi/omegaD*1000);

%% Grafik 1: Uc durum karsilastirma
figure('Name','RLC - Uc Sonum Durumu','NumberTitle','off','Position',[50 50 1100 500]);

subplot(1,2,1);
plot(t*1000, vC1, 'r-',  'LineWidth', 2.0, 'DisplayName', sprintf('Asiri Sönümlü R=%.0f Ohm', R1));
hold on;
plot(t*1000, vC2, 'g--', 'LineWidth', 2.0, 'DisplayName', sprintf('Kritik R=%.1f Ohm', R2));
plot(t*1000, vC3, 'b-.', 'LineWidth', 2.0, 'DisplayName', sprintf('Eksik Sönümlü R=%.0f Ohm', R3));
yline(Vs, 'k:', 'LineWidth', 1.0, 'DisplayName', 'Vs = 12 V');
xlabel('Zaman (ms)', 'FontSize', 11);
ylabel('v_C(t)  [V]', 'FontSize', 11);
title('Kondansator Gerilimi - Sonum Karsilastirmasi', 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'southeast', 'FontSize', 9);
grid on; ylim([-3 22]);

%% Grafik 2: Enerji analizi (eksik sonumlu)
iC3 = C * gradient(vC3, t);   % Kondansator akimi = C*dvC/dt
WC3 = 0.5 * C * vC3.^2;
WL3 = 0.5 * L * iC3.^2;
Wtot = WC3 + WL3;

subplot(1,2,2);
plot(t*1000, WC3*1000, 'b-',  'LineWidth', 2.0, 'DisplayName', 'W_C(t)');
hold on;
plot(t*1000, WL3*1000, 'r--', 'LineWidth', 2.0, 'DisplayName', 'W_L(t)');
plot(t*1000, Wtot*1000,'k:',  'LineWidth', 1.5, 'DisplayName', 'W_{toplam}(t)');
xlabel('Zaman (ms)', 'FontSize', 11);
ylabel('Enerji (mJ)', 'FontSize', 11);
title('Enerji Alisverisi - Eksik Sonumlu (R=10 Ohm)', 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'northeast', 'FontSize', 9);
grid on;

sgtitle('RLC Devresi - Gecici Rejim Analizi (L=0.1H, C=100uF, Vs=12V)', ...
    'FontSize', 13, 'FontWeight', 'bold');

saveas(gcf, fullfile('docs','RLC_Grafik.png'));
fprintf('\nGrafik kaydedildi: docs/RLC_Grafik.png\n');

%% Transfer fonksiyonu (nominal R=100 Ohm)
fprintf('\n=== TRANSFER FONKSIYONU (R=100 Ohm) ===\n');
R_nom = 100;
fprintf('H(s) = 1 / (%.5f*s^2 + %.4f*s + 1)\n', L*C, R_nom*C);
wn   = 1/sqrt(L*C);              % Dogal frekans (toolbox gerektirmez)
zeta = (R_nom/2)*sqrt(C/L);      % Sonum orani
fprintf('Dogal frekans wn = %.2f rad/s\n', wn);
fprintf('Sonum orani  zeta = %.4f\n', zeta);
