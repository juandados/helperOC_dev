classdef DubinsCarAccelerated < DynSys
  properties
    dims % Dimensions that are active
    wMax % Angular control bounds
    aMax % acceleration control bounds
    speedLimit % Maximum velocity
    speedMin % Minimum velocity
  end
  
  methods
    function obj = DubinsCarAccelerated(x, wMax, aMax, speedLimit, speedMin, dims)
      % obj = DubinsCar(x, wMax, speed, dMax, dims)
      %     Dubins Car class
      %
      % Dynamics:
      %    \dot{x}_1 = x_4 * cos(x_3)
      %    \dot{x}_2 = x_4 * sin(x_3)
      %    \dot{x}_3 = u1        
      %    \dot{x}_4 = u2
      %         u1 \in [-wMax, wMax]
      %         u2 \in [-aMax, aMax]
      %
      % Inputs:
      %   x      - state: [xpos; ypos; theta; vel]
      %   wMax   - maximum turn rate
      %   aMax   - maximum heading acceleration
      %
      % Output:
      %   obj       - a DubinsCar object
       
      if ~iscolumn(x)
        x = x';
      end
      
      if nargin < 2
        wMax = 1;
      end
      
      if nargin < 3
        aMax = 5;
      end
      
      if nargin < 4
        speedLimit = 10;
      end
      
      if nargin < 5
        speedMin = 0;
      end
      
      if nargin < 6
        dims = 1:4;
      end
      
      % Basic vehicle properties
      obj.pdim = [find(dims == 1) find(dims == 2)]; % Position dimensions
      obj.hdim = find(dims == 3); % Heading dimensions
      obj.vdim = find(dims == 4); % Velocity dimensions
      obj.nx = length(dims);
      obj.nu = 2;
      
      obj.x = x;
      obj.xhist = x;
      
      obj.wMax = wMax;
      obj.aMax = aMax;
      obj.speedLimit = speedLimit;
      obj.speedMin = speedMin;
      obj.dims = dims;
      
      if numel(x) ~= obj.nx
        error('Initial state does not have right dimension!');
      end
    end
    
  end % end methods
end % end classdef
