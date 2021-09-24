classdef StiffnessTest < Test
    
    properties (Access = private)
        data
        dim
        connectivities
    end
    
    methods(Access = protected)
        function passed = passed(obj)
            obj.initFile();
            [Ke, Kg] = obj.computeResults();
            maxError = obj.checkMaxError(Ke, Kg);
            tolerance = 1e-10;
            if maxError < tolerance
                passed = 1;
            else
                passed = 0;
            end
        end        
    end
    
    methods (Access = private)
        function initFile(obj)
            run(obj.fileName)
            obj.dim            = dim;
            obj.data           = data;
            obj.connectivities = connectivities;
        end
        
        function [Ke, Kg] = computeResults(obj)
            s.dim            = obj.dim;
            s.data           = obj.data;
            s.connectivities = obj.connectivities;
            SMC = StiffnessMatrixComputer(s);
            SMC.compute();
            Ke = SMC.KElem;
            Kg = SMC.KGlobal;
        end
    end
    
    methods (Static, Access = private)
        
        function err = checkMaxError(Ke, Kg)
            load matlab.mat KComp;
            diffKE = abs(KComp.KElem-Ke);
            maxDiffKe = max(diffKE, [], 'all');
            diffKg = abs(KComp.KGlobal-Kg);
            maxDiffKg = max(diffKg, [], 'all');
            err = max(maxDiffKe,maxDiffKg);
        end
        
    end
end