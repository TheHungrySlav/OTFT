%{
    Kyle Jenko
    otft_go_pogl.m
    OTFT P3HT with GO-POGL Interfacial Layer parameter extraction
%}
clear;clc;
%OTFT Dimensions
L = 500e-6; %Length [m]
w = 50e-6; %Width [m]
sigma_i = 3.9; %Dielectric constant of gate insulator (Si02)
sigma_o = 8.85*10^-12; %Permittivity of free space [F/m]
t_ox = 300e-9; %Gate insulator thickness [m]

%Read values from Excel File
filename = 'OTFT GO-POGL';
sheet = 4;
xlRange = 'C2:C501'; 
xlRange2 = 'D2:D501';
VDS_Range = 'B2';
VDS = xlsread(filename,sheet,VDS_Range);
IDS = xlsread(filename,sheet,xlRange);
VGS = xlsread(filename,sheet,xlRange2);

% Generate ID-VGS curve based on data
% Get coefficients of a line fit through the data.
coefficients = polyfit(VGS, IDS, 3);
% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(VGS), max(VGS), 1000);
% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);
% Plot everything.
plot(VGS, IDS, 'b.', 'MarkerSize', 15); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
axis([-60 60 -1.5e-7 1.5e-7]);
grid on;

%Find Transconductance gm
fprintf("Characteristic Equation f(x): ");
n = [3,2,1,0];
for i = 1:4
    fprintf("%d x^{%i}",coefficients(i),n(i));
    if(i<4)
        fprintf(" + ");
    end
end
fprintf("\n");
fprintf("Transconductance gm = f'(x): ");
new_coeff = coefficients.*n;
new_n = [2,1,0];
for i = 1:3
    fprintf("%d x^{%i}",new_coeff(i),new_n(i));
    if(i<3)
        fprintf(" + ");
    end
end
fprintf("\n");

% Find maximum value of transconductance
x = -50:0.5:50;
y_1 = new_coeff(1)*x.^2 + new_coeff(2)*x.^1 + new_coeff(3);
[y_max, index] = max(y_1);
x_max = x(index);

% Find y value at max transconductance
y = coefficients(1)*x_max.^3 + coefficients(2)*x_max.^2 + coefficients(3)*x_max.^1 + coefficients(4);
gm_max = y;

% Generate line to find Threshold Voltage
slope = y_max;
line_y = slope*(x-x_max)+y;
y_0 = 0;
x_int = (y_0-y)/slope + x_max;
plot(x,line_y,'g');
plot(x_int,y_0,'b--o');
hold off;
title('GO-POGL OTFT Transfer Characteristics');
xlabel('V_{GS} [V]');
ylabel('I_{DS} [A]');
legend(' ','Ids','Extrapolation');

% Plot transcunductance gm
figure;
gm = new_coeff(1).*xFit.^new_n(1) + new_coeff(2).*xFit.^new_n(2) + new_coeff(3).*xFit.^new_n(3);
plot(xFit,gm);
axis([-60 60 -0.5e-9 3.5e-9]); 
xlabel('V_{GS} [V]');
ylabel('g_{m}');
title('Transconductance');

% Parameter Extraction
C_ox = (sigma_i*sigma_o)/t_ox; %Gate insulator capacitance per unit area
mu_lin = (L/(w*C_ox*VDS))*gm_max; %Field Effect mobility
Vth = x_int - (VDS/2); %Threshold Voltage
fprintf("Field Effect Mobility mu_lin = %f\n",mu_lin);
fprintf("Threshold Voltage = %f V\n",Vth);