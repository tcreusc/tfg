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
            dirRes  = obj.computeDirectResults();
            iterRes = obj.computeIterativeResults();
        end
    
        function error = checkMaxError(obj, directRes, iterRes) % checkError separadet
            dirErr  = obj.calculateDirectError(directRes);
            iterErr = obj.calculateIterativeError(iterRes);
            error = max(dirErr,iterErr);
        end
        
        function results = computeDirectResults(obj)
            s.dim        = obj.dim;
            s.data       = obj.data;
            s.solvertype = 'DIRECT';
            FEM = FEMAnalyzer(s);
            FEM.perform();
            results = FEM.displacement;
        end
        
        function maxError = calculateDirectError(obj, directRes)
            values = obj.results;
            error = abs(directRes - values);
            maxError = max(error);
        end
        
        function results = computeIterativeResults(obj)
            s.dim        = obj.dim;
            s.data       = obj.data;
            s.solvertype = 'ITERATIVE';
            FEM = FEMAnalyzer(s);
            FEM.perform();
            results = FEM.displacement;
        end
        
        function error = calculateIterativeError(obj, iterRes)
            values = obj.results;
            diff = abs(iterRes - values);
            error = max(diff);
        end

    end
end

