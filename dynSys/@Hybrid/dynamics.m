function dx = dynamics(obj, ~, x, u, ~)
% Dynamics:
%    \dot{x}_1 = x_2
%    \dot{x}_2 = u1
%    \dot{x}_3 = x_4      
%    \dot{x}_4 = u2
%         u1 \in [-aQuadMax, aQuadMax] if Quad mode, u1 \in [-wCarMax, wCarMax] if in Car mode
%         u2 \in [-aQuadMax, aQuadMax] if Quad mode, u2 \in [-aCarMax, aCarMax] if in Car mode
%   Control: u1 = w; u2 = a;
%
% Juan Chacon, 2020-01-08

if iscell(x)
  dx = cell(length(obj.dims), 1);
  
  for i = 1:length(obj.dims)
    dx{i} = dynamics_cell_helper(obj, x, u, obj.dims, obj.dims(i));
  end
else
  dx = zeros(obj.nx, 1);
  if obj.mode == 0
    dx(1) = x(2);
    dx(2) = u(1);
    dx(3) = x(4);
    dx(4) = u(2);
  else
    v = norm([x(2),x(4)]);
    theta = atan2(x(4),x(2));
    dx(1) = x(2);
    dx(2) = u(2) * cos(theta) - v * u(1) * sin(theta);
    dx(3) = x(4);
    dx(4) = u(2) * sin(theta) + v * u(1) * cos(theta);
  end
end
end

function dx = dynamics_cell_helper(obj, x, u, dims, dim)
if obj.mode == 0
  switch dim
    case 1
      dx = x{dims==2};
    case 2
      dx = u{1};
    case 3
      dx = x{dims==4};
    case 4
      dx = u{2};
      otherwise
      error('Only dimension 1-4 are defined for dynamics of DubinsCarAccelerated!')
  end
else
  v = norm([x{dims==2},x{dims==4}]);
  theta = atan2(x{dims==4},x{dims==2});
  switch dim
    case 1
      dx = x{dims==2};
    case 2
      dx = u{2} * cos(theta) - v * u{1} * sin(theta);
    case 3
      dx = x{dims==4};
    case 4
      dx = u(2) * sin(theta) - v * u(1) * cos(theta);
      otherwise
      error('Only dimension 1-4 are defined for dynamics of DubinsCarAccelerated!')
  end
end
end
