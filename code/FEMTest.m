classdef FEMTest < Test
    properties (Access = private)
        data
        dim
        results
    end
    
    methods(Access = protected)
        function passed = passed(obj)
            obj.initFile();
            [directRes, iterRes] = obj.computeResults();
            maxError = obj.checkMaxError(directRes, iterRes);
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
            obj.dim     = dim;
            obj.data    = data;
            obj.results = results;
        end
        
        function [directRes, iterRes] = computeResults(obj)
            s.dim        = obj.dim;
            s.data       = obj.data;
            s.solvertype = 'DIRECT';
            FEM = FEMAnalyzer(s);
            FEM.perform();
            directRes = FEM.displacement;
            s.solvertype = 'ITERATIVE';
            FEM = FEMAnalyzer(s);
            FEM.perform();
            iterRes = FEM.displacement;
        end
    
        function err = checkMaxError(obj, direct, iterative)
            results = obj.results;
            directDiff = abs(direct-results);
            directMaxError = max(directDiff);
            iterativeDiff = abs(iterative-results);
            iterativeMaxError = max(iterativeDiff);
            err = max(directMaxError,iterativeMaxError);
        end
    end
end

