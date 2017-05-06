%% CENTRALES, LÍNEAS Y SUBESTACIUONES, Diciembre 2/12/2016
% Ecuación de cambio de estado para líneas eléctricas
clc
% ACSR/AW Cardinal: Características mecánicas del conductor
E     = 6700;        % kg/mm^2   Módulo de young
S     = 547.3;       % (mm2)     Sección 
alpha = 20.2e-6;     % (C^-1)    Coeficiente de dilatación
Tmax  = 154.3e3/10;  % (daN)     Tensión máxima del conductor
diametro = 30.4e-3;  % (mm)      Diámetro sin hielo
d_hielo  = 65.53e-3; % (mm)      Diámetro con hielo


%% Estado Inicial (Constante, 15ºC, EDS = 18%Tmax)
a = 450;                    % 1 pos Vano corto 2º pos vano largo 350 y 550
P1 = 1.756;                 % Peso del conductor
t1 = 15;                    % Temperatura inicial
T1 = 0.18*Tmax;             % EDS (18%)
K1 = a^2*P1^2/(24*T1^2)-alpha*t1-T1/(E*S);
   

%% Hipótesis 1. Tracción máxima viento (-15ºC, sqrt(Pcond+P_v))
% 1. Condiciones iniciales
Presion_viento = 68;    % Presion del viento (daN/m^2) 
P_hielo = 0;            % Peso del hielo (daN/m)
fprintf('\n1. Tracción máxima Viento\n')

% 2. Calculos de resultantes viento, hielo etc
P_v = Presion_viento*diametro;
P2 = sqrt(P1^2+P_v^2);
fprintf('Resultante Hip.1: %.4f daN\n', P2)
t2 = -15;

% 3. Euacion cambio de estado y coeficientes K2 y K3
K2 = (K1 + alpha*t2)*S*E;
K3 = a^2*P2^2*S*E/24;

y = [1 K2 0 -K3];     
r = roots(y);

for i=1:3;
 if imag(r(i)) == 0
    T2 = real(r(i));
  end
end

% 4. Tensión en el estado final N)
fprintf('Hipótesis 1 T2: %.2f N\n', T2)


%% Hipótesis 2. Tracción máxima hielo (-20ºC, P=P_h+P_v)
% 1. Condiciones iniciales
Presion_viento = 0;     % Presion del viento (daN/m^2) 
t2 = -20;               % Temperatura
fprintf('\n2. Tracción máxima Hielo\n')

% 2. Calculos de resultantes viento, hielo etc
P_hielo = 0.36*sqrt(diametro*1000); 
P2 = P_hielo + P1;
fprintf('Resultante Hip.2: %.4f daN\n', P2)

% 3. Euacion cambio de estado y coeficientes K2 y K3
K2 = (K1 + alpha*t2)*S*E;
K3 = a^2*P2^2*S*E/24;

y = [1 K2 0 -K3]; 
r = roots(y);

for i=1:3;
  if imag(r(i)) == 0
     T2 = real(r(i));
  end
end

% 4. Tensión en el estado final
fprintf('Hipótesis 2 T2: %.2f N\n',T2)

% flecha = a^2/(8*T2/P1);
% fprintf('Flecha hipótesis 2: %.2f\n',flecha)


%% Hipótesis 3. Tracción máxima hielo + viento
% 1. Condiciones iniciales
Presion_viento = 12.5;                      % Presion del viento (daN/m^2)
P_hielo = 750*pi*(d_hielo^2-diametro^2)/4;  % Peso del hielo (daN/m)
t2 = -20;
fprintf('\n3. Tracción máxima Hielo + Viento\n')

% 2. Calculos de resultantes viento, hielo etc
P_v = Presion_viento*d_hielo;               % Resultante viento
P = P_hielo + P1;                            % Resultante hielo + conductor
P2 = sqrt(P^2 + P_v^2);                     % Resultante total
fprintf('Resultante Hip.3: %.4f daN\n', P2)

% 3. Euacion cambio de estado y coeficientes K2 y K3
K2 = (K1 + alpha*t2)*S*E;
K3 = a^2*P2^2*S*E/24;

y = [1 K2 0 -K3];% Devuelve T2
r = roots(y);
 for i=1:3;
  if imag(r(i)) == 0
     T2 = real(r(i));
  end
 end
 
% 4. Tensión en el estado final
fprintf('Hipótesis 3 T2: %.2f N\n',T2)


%% Hipótesis 4. Flecha máxima temperatura (85ºC)
% 1. Condiciones iniciales
Presion_viento = 0;  % Presion del viento (daN/m^2) 
t2 = 75;             % Tª máxima
a = [450 650];       % Vano corto 45y vano largo 650
fprintf('\n4. Flecha máxima Temparatura\n')

% 2. Cálculos de resultantes viento, hielo etc
P_v = Presion_viento*diametro;
P2a = sqrt(P1^2+P_v^2);
fprintf('\nResultante Hip.4: %.4f daN\n', P2a)

% 3. Euacion cambio de estado y coeficientes K1, K2 y K3
for j=1:2
    K1 = a(j)^2*P1^2/(24*T1^2)-alpha*t1-T1/(E*S);
    K2 = (K1 + alpha*t2)*S*E;
    K3 = a(j)^2*P2a^2*S*E/24;

    y = [1 K2 0 -K3]; % Devuelve T2
    r = roots(y);
    for i=1:3
     if imag(r(i)) == 0
        T2a = real(r(i));
      end
    end
% 4. Tracción para flecha máxima temperatura
fprintf('\nHipótesis fmax temperatura T2: %.2f N\n', T2a)

% 5. Flecha máxima 
fmax_hiptempc = a(j)^2/(8*(T2a/P2a))
end 


%% Hipótesis 5. Flecha máxima hielo
% 1. Condiciones iniciales
t2 = 0;
P_hielo = 750*pi*(d_hielo^2-diametro^2)/4;
a = [450 650];             
fprintf('\n5. Flecha máxima Hielo\n')

% 2. Cálculo de resultantes viento, hielo etc
P_flechamax_hielo = P_hielo+P1;
fprintf('\nResultante Hip.5: %.4f daN\n', P_flechamax_hielo)

% 3. Euacion cambio de estado y coeficientes K2 y K3
for j=1:2
    K1 = a(j)^2*P1^2/(24*T1^2)-alpha*t1-T1/(E*S);
    K2 = (K1 + alpha*t2)*S*E;
    K3 = a(j)^2*P_flechamax_hielo^2*S*E/24;

    y = [1 K2 0 -K3]; % Devuelve T2
    r = roots(y);
    for i=1:3
     if imag(r(i)) == 0
        T2a = real(r(i));
      end
    end
% 4. Tracción para flecha máxima hielo
fprintf('\nHipótesis fmax Hielo T2: %.2f N\n', T2a)

% 5. Flecha máxima 
fmax_hip_hielo = a(j)^2/(8*(T2a/P_flechamax_hielo))
end 


%% Hipótesis 6. Flecha máxima viento
% 1 . Condiciones iniciales
P_vientofmax = 68*diametro;  %(daN/m)
t2 = 15;
a = [450 650]; 
fprintf('\n6. Flecha máxima Viento\n')

% 2. Cálculo de resultantes viento, hielo etc
P_vientofmaxres = sqrt(P1^2+P_vientofmax^2)
fprintf('\nResultante Hip.6: %.4f daN\n', P_vientofmaxres)

% 3. Euación cambio de estado y coeficientes K2 y K3
for j=1:2
    K1 = a(j)^2*P1^2/(24*T1^2)-alpha*t1-T1/(E*S);
    K2 = (K1 + alpha*t2)*S*E;
    K3 = a(j)^2*P_vientofmaxres^2*S*E/24;

    y = [1 K2 0 -K3]; % Devuelve T2
    r = roots(y);
    for i=1:3
     if imag(r(i)) == 0
        T2a = real(r(i));
      end
    end
% 4. Tracción para flecha máxima viento
fprintf('\nHipótesis fmax Viento T2: %.2f N\n', T2a)

% 5. Flecha máxima 
fmax_hip_viento = a(j)^2/(8*(T2a/P_vientofmaxres))
end 
