classdef stiffnessElementCalculator < handle
    %STIFFNESELEMENTCALCULATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private, GetAccess = public)
        le
    end
    
    properties(Access = private)
        x1e, x2e, y1e, y2e
    end
    
    
    methods(Access = public)
        function obj = stiffnessElementCalculator(x, Tn, e) 
            obj.x1e = x( Tn(e,1), 1 );
            obj.x2e = x( Tn(e,2), 1 );
            obj.y1e = x( Tn(e,1), 2 );
            obj.y2e = x( Tn(e,2), 2 );
            obj.calculateLength();
        end
    
        function [x1e, x2e, y1e, y2e, le] = getElementData(obj)
            x1e = obj.x1e;
            x2e = obj.x2e;
            y1e = obj.y1e;
            y2e = obj.y2e;
            le = obj.le;
            
        end
    end
    
    methods(Access = private)        
        function calculateLength(obj)
              obj.le  = sqrt( (obj.x2e - obj.x1e)^2 + (obj.y2e - obj.y1e)^2 );
        end     
    end
    
end

