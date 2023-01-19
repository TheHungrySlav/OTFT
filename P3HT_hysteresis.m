%{
    Kyle Jenko
    OTFT P3HT hysteresis
%}
clear;clc;
%Read values from Excel File
filename = 'OTFT P3HT';
sheet = 5;
xlRange = 'C2:C201'; 
xlRange2 = 'D2:D201';
IDS = xlsread(filename,sheet,xlRange);
VGS = xlsread(filename,sheet,xlRange2);

x2Range = 'I2:I201'; 
x2Range2 = 'J2:J201';
IDS2 = xlsread(filename,sheet,x2Range);
VGS2 = xlsread(filename,sheet,x2Range2);

% Generate ID-VGS curve based on data
% Get coefficients of a line fit through the data.
coefficients = polyfit(VGS, IDS, 3);
coefficients2 = polyfit(VGS2, IDS2, 3);
% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(VGS), max(VGS), 1000);
xFit2 = linspace(min(VGS2), max(VGS2), 1000);
% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);
yFit2 = polyval(coefficients2 , xFit2);
% Plot everything.
plot(VGS, IDS, 'b.', 'MarkerSize', 15);% Plot training data.
hold on;
plot(VGS2, IDS2, 'b.', 'MarkerSize', 15);
%Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
plot(xFit2, yFit2, 'r-', 'LineWidth', 2);
grid on;
title('P3HT Hysteresis');
axis([-60 60 -14e-8 2e-8]);
xlabel('V_{GS} [V]');
ylabel('I_{DS} [A]');
