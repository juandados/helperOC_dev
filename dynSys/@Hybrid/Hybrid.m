classdef Hybrid < DynSys
  properties
    dims % Dimensions that are active
    aQuadMax % quad4d acceleration control bound, it is considered symmetric
    wCarMax % Car like angular speed control bounds
    aCarMax % Car like acceleration control bounds
    speedLimit % Maximum velocity
    speedMin % Minimum velocity
    mode % Hybrid mode: 0 - Quad, 1 - Car
    modehist
  end
  
  methods
    function obj = Hybrid(x, aQuadMax, wCarMax, aCarMax, mode, speedLimit, speedMin, dims)
      % obj = DubinsCar(x, wMax, speed, dMax, dims)
      %     Dubins Car class
      %
      % Dynamics:
      %    \dot{x}_1 = x_2
      %    \dot{x}_2 = u1
      %    \dot{x}_3 = x_4      
      %    \dot{x}_4 = u2
      %         u1 \in [-aQuadMax, aQuadMax] if Quad mode, u1 \in [-wCarMax, wCarMax] if in Car mode
      %         u2 \in [-aQuadMax, aQuadMax] if Quad mode, u2 \in [-aCarMax, aCarMax] if in Car mode
      %
      % Inputs:
      %   mode   	- Hybrid mode: 0 - Quad, 1 - Car
      %   x      	- initial state: [xpos; xvel; ypos; yvel] in Quad mode, [xpos; ypos; theta; vel] in Car 1
      %   aQuadMax 	- maximum acceleration in Quad mode
      %   wCarMax   	- maximum turn rate in Car mode
      %   aCarMax   	- maximum heading acceleration in Car mode
      %   speedLimit    - maximum speed in both modes
      %	  speedMin      - minimum speed in Car mode
      % Output:
      %   obj       	- a Quad-car hybrid vehicle
       
      if ~iscolumn(x)
        x = x';
      end

      if nargin < 2
        aQuadMax = 3;
      end
      
      if nargin < 3
        wCarMax = 1;
      end
      
      if nargin < 4
        aCarMax = 5;
      end

      if nargin < 5
        mode = 0;
      end
      
      if nargin < 6
        speedLimit = 10;
      end
      
      if nargin < 7
        speedMin = 0;
      end
      
      if nargin < 8
        dims = 1:4;
      end
      
      % Basic vehicle properties
      obj.pdim = [find(dims == 1) find(dims == 3)]; % Position dimensions
      obj.vdim = [find(dims == 2) find(dims == 4)]; % Velocity dimensions
      obj.nx = length(dims);
      obj.nu = 2; % Check where it is used, if not used delete
      
      obj.x = x;
      obj.xhist = x;  
      obj.modehist = mode;
      obj.aQuadMax = aQuadMax;
      obj.wCarMax = wCarMax;
      obj.aCarMax = aCarMax;
      obj.mode = mode;
      obj.speedLimit = speedLimit;
      obj.speedMin = speedMin;
      obj.dims = dims;
      
      if numel(x) ~= obj.nx
        error('Initial state does not have right dimension!');
      end
    end
    
  end % end methods
end % end classdef
