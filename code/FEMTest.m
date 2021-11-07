classdef FEMTest < Test
    
    properties (Access = private)
        data
        dim
        results
        tolerance
    end
    
    methods(Access = protected)

        function passed = passed(obj)
            obj.initFile();
            [directRes, iterRes] = obj.computeResults();
            maxError = obj.checkMaxError(directRes, iterRes);
            tol = obj.tolerance;
            if maxError < tol
                passed = 1;
            else
                passed = 0;
            end
        end

    end
    
    methods (Access = private)
        
        function initFile(obj)
            run(obj.fileName)
            obj.dim       = dim;
            obj.data      = data;
            obj.results   = results;
            obj.tolerance = 1e-4;
        end
        
        function [dirRes, iterRes] = computeResults(obj)
            dirRes  = obj.calculateProblemResults('DIRECT');
            iterRes = obj.calculateProblemResults('ITERATIVE');
        end
    
        function error = checkMaxError(obj, directRes, iterRes)
            dirErr  = obj.calculateError(directRes);
            iterErr = obj.calculateError(iterRes);
            error = max(dirErr,iterErr);
        end
        
        function results = calculateProblemResults(obj, solvertype)
            s.dim        = obj.dim;
            s.data       = obj.data;
            s.solvertype = solvertype;
            FEM = FEMAnalyzer(s);
            FEM.perform();
            results = FEM.displacement;
        end
        
        function maxError = calculateError(obj, computed)
            values = obj.results;
            error = abs(computed - values);
            maxError = max(error);
        end

    end
end

