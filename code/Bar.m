classdef Bar < handle
    
    properties(SetAccess = private, GetAccess = public)
        
    end
    
    properties(Access = private)
        dim
        x1
        x2
    end
    
    methods(Access = public)
        
        function obj = Bar(cParams)
            obj.init(cParams)
        end
        
        function obj = create(obj)
    end

    methods(Access = private)
        
        function init(obj, cParams)
            obj.dim   = cParams.dim;
            obj.u     = cParams.u;
            obj.x     = cParams.data.x;
            obj.Tn    = cParams.data.Tn;
        end
        
    end
end

