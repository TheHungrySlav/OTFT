%{
    Kyle Jenko
    
%}
clear;clc;

%Read values from Excel File
filename = 'OTFT GO-POGL';
sheet = 1;
xlRange_vgs0 = 'C2:C141'; 
xlRange2_vgs0 = 'D2:D141';
VDS = xlsread(filename,sheet,xlRange_vgs0);
IDS = xlsread(filename,sheet,xlRange2_vgs0);

xlRange_vgs20 = 'C142:C281'; 
xlRange2_vgs20 = 'D142:D281';
VDS_2 = xlsread(filename,sheet,xlRange_vgs20);
IDS_2 = xlsread(filename,sheet,xlRange2_vgs20);

xlRange_vgs40 = 'C282:C421'; 
xlRange2_vgs40 = 'D282:D421';
VDS_3 = xlsread(filename,sheet,xlRange_vgs40);
IDS_3 = xlsread(filename,sheet,xlRange2_vgs40);

xlRange_vgs60 = 'C422:C561'; 
xlRange2_vgs60 = 'D422:D561';
VDS_4 = xlsread(filename,sheet,xlRange_vgs60);
IDS_4 = xlsread(filename,sheet,xlRange2_vgs60);

% Generate ID-VGS curve based on data
% Get coefficients of a line fit through the data.
coefficients = polyfit(VDS, IDS, 3);     % VGS = 0 [V]
coefficients2 = polyfit(VDS_2, IDS_2, 3);  %VGS = -20 [V]
coefficients3 = polyfit(VDS_3, IDS_3, 3);  % VGS = -40 [V]
coefficients4 = polyfit(VDS_4, IDS_4, 3);  % VGS = -60 [V]
% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(VDS), max(VDS), 1000);
% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);    %VGS = 0
yFit2 = polyval(coefficients2 , xFit);  %VGS = -20
yFit3 = polyval(coefficients3 , xFit);   %VGS = -40
yFit4 = polyval(coefficients4 , xFit);   %VGS = -60
n = [3,2,1,0];
% Plot everything.
%plot(VDS, IDS, 'b.', 'MarkerSize', 15); % Plot training data.
hold on;
%plot(VDS_2, IDS_2, 'b.', 'MarkerSize', 15);
%plot(VDS_3, IDS_3, 'b.', 'MarkerSize', 15);
%plot(VDS_4, IDS_4, 'b.', 'MarkerSize', 15);
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
plot(xFit, yFit2, 'r-', 'LineWidth', 2); % Plot fitted line.
plot(xFit, yFit3, 'r-', 'LineWidth', 2); % Plot fitted line.
plot(xFit, yFit4, 'r-', 'LineWidth', 2); % Plot fitted line.
grid on;

Vth = 4.466429;
x1 = 0-Vth; % VDS_sat
x2 = -20-Vth;
x3 = -40-Vth;
x4 = -60-Vth;

y1 = coefficients(1).*x1.^n(1)+coefficients(2).*x1.^n(2)+coefficients(3).*x1.^n(3)+coefficients(4).*x1.^n(4);
y2 = coefficients2(1).*x2.^n(1)+coefficients2(2).*x2.^n(2)+coefficients2(3).*x2.^n(3)+coefficients2(4).*x2.^n(4);
y3 = coefficients3(1).*x3.^n(1)+coefficients3(2).*x3.^n(2)+coefficients3(3).*x3.^n(3)+coefficients3(4).*x3.^n(4);
y4 = coefficients4(1).*x4.^n(1)+coefficients4(2).*x4.^n(2)+coefficients4(3).*x4.^n(3)+coefficients4(4).*x4.^n(4);

plot(x1,y1,'g--o'); fprintf("x1 = %f  y1 = %10e\n",x1,y1);
plot(x2,y2,'g--o'); fprintf("x2 = %f  y2 = %10e\n",x2,y2);
plot(x3,y3,'g--o'); fprintf("x3 = %f  y3 = %10e\n",x3,y3);
plot(x4,y4,'g--o'); fprintf("x4 = %f  y4 = %10e\n",x4,y4);
