function plotPosition(obj, extraArgs)
% function plotPosition(obj, color)
%
% Plots the current state and the trajectory of the quadrotor
%
% Inputs: obj       - vehicle object
%         extraArgs - color for plotting

if nargin < 2
  extraArgs = [];
end

%% Default parameters
Color = 'k';
MarkerSize = 20;
ArrowLength = 1;
LineStyle = 'none';
LineWidth = 0.5;
ArrowSize = 1;%1

if isfield(extraArgs, 'Color')
  Color = extraArgs.Color;
end

if isfield(extraArgs, 'MarkerSize')
  MarkerSize = extraArgs.MarkerSize;
end

if isfield(extraArgs, 'ArrowLength')
  ArrowLength = extraArgs.ArrowLength;
end

if isfield(extraArgs, 'ArrowSize')
  ArrowSize = extraArgs.ArrowSize;
end

if isfield(extraArgs, 'LineStyle')
  LineStyle = extraArgs.LineStyle;
end

if isfield(extraArgs, 'LineWidth')
  LineWidth = extraArgs.LineWidth;
end

%% Get position and velocity
[p, phist] = obj.getPosition;
v = obj.getVelocity;
small = 1e-2;
if norm(v) > small
  v = v/norm(v);
end

%% Plot position trajectory
if isempty(obj.hpxpyhist) || ~isvalid(obj.hpxpyhist)
  % If no graphics handle has been created, create it.
  obj.hpxpyhist = plot(phist(1,:), phist(2,:), '.', 'color', Color, ...
    'markersize', 4, 'LineStyle', LineStyle, 'LineWidth', LineWidth);
  hold on
end
tailSize = 30;
if isfield(extraArgs, 'tailSize')
  tailSize = extraArgs.tailSize;
  if tailSize == -1
      tailSize = size(phist,2)-1;
  end
end
startTail = max(1,size(phist,2)-tailSize);
obj.hpxpyhist.XData = phist(1,startTail:end);
obj.hpxpyhist.YData = phist(2,startTail:end);

%% Plot current position and velocity using an arrow
if isempty(obj.hpxpy) || ~isvalid(obj.hpxpy)
  % If no graphics handle has been created, create it with the specified
  % color. Use default color if no color is provided.
  obj.hpxpy = quiver(p(1), p(2), v(1), v(2), 'ShowArrowHead', ...
    'on', 'AutoScaleFactor', ArrowLength);
  hold on
  
  obj.hpxpy.Marker = '.';
  obj.hpxpy.Color = obj.hpxpyhist.Color;
  obj.hpxpy.MarkerFaceColor = obj.hpxpyhist.Color;
  obj.hpxpy.MarkerSize = MarkerSize;
  obj.hpxpy.MaxHeadSize = ArrowSize;
  obj.hpxpy.LineWidth = 1.5;
else
  % Otherwise, simply update graphics handles
  obj.hpxpy.XData = p(1);
  obj.hpxpy.YData = p(2);
  obj.hpxpy.UData = v(1);
  obj.hpxpy.VData = v(2);
end

end
