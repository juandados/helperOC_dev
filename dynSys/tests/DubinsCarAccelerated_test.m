%function DubinsCarAccelerated_test()
% Quad4D_test()
clear;
clc;
close all;
xs = [0; 0];
ys = [0; 0];
thetas = [0; 0];
vs = [1; 1];
% Vehicles
q = cell(1,2);
for j = 1:2
    q{j} = DubinsCarAccelerated([xs(j) ys(j) thetas(j) vs(j)]);
end
% Time discretization
dt = 0.001;
tMax = 3;
t = 0:dt:tMax;
% Plot
f = figure;
hold on;
xlim([-5 5])
ylim([-5 10])
axis square
% base variables
[x1old,x2old,x3old] = compute_relative_system(q);

for i = 1:length(t)
    %--- Two vehicles moving with variable linear velocity & angle
    % Vehicle 1
    %-Circles Movement:
%     dV_dt = 0;
%     dTheta_dt = 2*pi/tMax;
    %-Parabolic Movement:
    dTheta_dt = 2/(1+4*t(i)^2);
    dV_dt = 4*t(i)/sqrt(1+4*t(i)^2);
    u(:,2) = [dTheta_dt; dV_dt];
    % Vehicle 2
%     dTheta_dt = 0;
%     dV_dt = sqrt(8);
    %--Circle
    dV_dt = 0;
    dTheta_dt = -2*pi/tMax;
    u(:,1) = [dTheta_dt; dV_dt];
    for j = 1:2
        uj = u(:,j);
        q{j}.updateState(uj, dt);
        q{j}.plotPosition;
        drawnow
    end
    
    %-- Checking relative dynamic
    % relative Mitchell Based
    % dx1_dt = -va + vb*cos(x3) + a*x2
    % dx2_dt = vb*sin(x3) - a*x1
    % dx3_dt = b - a    
    % dx4_dt = ?

    % Using Formulas
    [x1,x2,x3] = compute_relative_system(q);
    dx1_dt = -q{1}.x(4) + q{2}.x(4)*cos(x3) + u(1,1)*x2;
    dx2_dt = q{2}.x(4)*sin(x3) - u(1,1)*x1;
    dx3_dt = u(1,2) - u(1,1);
    % Estimating value
    est_dx1_dt = (x1-x1old)/dt;
    est_dx2_dt = (x2-x2old)/dt;
    est_dx3_dt = (x3-x3old)/dt;
    x1old = x1;
    x2old = x2;
    x3old = x3;
    % Saving differences
    errors(1,i) = est_dx1_dt - dx1_dt;
    errors(2,i) = est_dx2_dt - dx2_dt;
    errors(3,i) = est_dx3_dt - dx3_dt;
end
figure();
plot(errors');

function [x1,x2,x3] = compute_relative_system(q)
    r = q{2}.x(1:2,:) - q{1}.x(1:2,:);
    phi = angle(r(1)+r(2)*sqrt(-1));
    psi = phi - q{1}.x(3);
    x1 = norm(r)*cos(psi);
    x2 = norm(r)*sin(psi);
    x3 = q{2}.x(3) - q{1}.x(3);
end
