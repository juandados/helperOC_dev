function dx = dynamics(obj, ~, x, u, ~)
% Dynamics of the Dubins Car
%    \dot{x}_1 = x_4 * cos(x_3)
%    \dot{x}_2 = x_4 * sin(x_3)
%    \dot{x}_3 = w
%    \dot{x}_4 = a
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
  
  dx(1) = x(4) * cos(x(3));
  dx(2) = x(4) * sin(x(3));
  dx(3) = u(1);
  dx(4) = u(2);
end
end

function dx = dynamics_cell_helper(obj, x, u, dims, dim)

switch dim
  case 1
    dx = x{dims==4} * cos(x{dims==3});
  case 2
    dx = x{dims==4} * sin(x{dims==3});
  case 3
    dx = u{1};
  case 4
    dx = u{2};
  otherwise
    error('Only dimension 1-4 are defined for dynamics of DubinsCarAccelerated!')
end
end