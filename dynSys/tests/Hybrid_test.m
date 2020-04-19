%function DubinsCarAccelerated_test()
% Quad4D_test()
clear;
clc;
close all;
% Vehicles
x = [1 0 0 1];
aQuadMax = 3;
wCarMax = 1;
aCarMax = 5;
mode = 1;
speedLimit = 10;
speedMin = 0;
q = Hybrid(x, aQuadMax, wCarMax, aCarMax, mode, speedLimit, speedMin);
% Time discretization
dt = 0.01;
tMax = 2*pi;
t = 0:dt:tMax;
% Plot
f = figure;
hold on;
xlim([-5 5])
ylim([-5 10])
axis square

for i = 1:length(t)
    %--- Two vehicles moving with variable linear velocity & angle
    % Vehicle 1
    %-Circles Movement:
    dV_dt = 0;
    dTheta_dt = 1;
    %-Parabolic Movement:
%     dTheta_dt = 2/(1+4*t(i)^2);
%     dV_dt = 4*t(i)/sqrt(1+4*t(i)^2);
    u = [dTheta_dt; dV_dt];
    % Vehicle 2
%     dTheta_dt = 0;
%     dV_dt = sqrt(8);
    q.updateState(u, dt);
    q.plotPosition;
    drawnow
end

q.mode = 0;
for i = 1:length(t)
    %--- Two vehicles moving with variable linear velocity & angle
    % Vehicle 1
    %-Circles Movement:
    dvx_dt = -0.1;
    dvy_dt = 0;
    %-Parabolic Movement:
%     dTheta_dt = 2/(1+4*t(i)^2);
%     dV_dt = 4*t(i)/sqrt(1+4*t(i)^2);
    u = [dvx_dt; dvy_dt];
    % Vehicle 2
%     dTheta_dt = 0;
%     dV_dt = sqrt(8);
    q.updateState(u, dt);
    q.plotPosition;
    drawnow
end