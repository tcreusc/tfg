classdef TestSolver < handle
    properties(SetAccess = private, GetAccess = public)
        passed
    end
    
    properties(Access = private)
        dataFile
        data
        dim
        results
        dispDirect, passedDirect
        dispIterative, passedIterative
    end
    
    methods(Access = public)   
        function obj = TestSolver(cParams)
            obj.init(cParams);
        end

        function runAnalyses(obj)
            obj.runDirectAnalysis();
            obj.runIterativeAnalysis();
        end
        
        function check(obj)
            obj.passedDirect    = obj.checkResults(obj.dispDirect, 'DIRECT');
            obj.passedIterative = obj.checkResults(obj.dispDirect, 'ITERATIVE');
            if (obj.passedDirect && obj.passedIterative)
                obj.passed = 1;
                obj.displayStatus(obj.passed, 'GLOBAL');
            else
                obj.passed = 0;
                obj.displayStatus(obj.passed, 'GLOBAL');
            end
            
            
            
        end
    end
    
    methods(Access = private)
        function init(obj, cParams)
            run(cParams)
            obj.dataFile  = cParams;
            obj.data       = data;
            obj.dim        = dim;
            obj.results    = results;
        end
        
        function runDirectAnalysis(obj)
            s.data       = obj.data;
            s.dim        = obj.dim;
            s.solvertype = 'DIRECT';
            analysis = FEMAnalyzer(s);
            analysis.perform();
            obj.dispDirect = analysis.displacement;
        end
        
        function runIterativeAnalysis(obj)
            s.data       = obj.data;
            s.dim        = obj.dim;
            s.solvertype = 'ITERATIVE';
            analysis = FEMAnalyzer(s);
            analysis.perform();
            obj.dispIterative = analysis.displacement;
        end
        
        function passed = checkResults(obj, disp, type)
            tolerance = 1e15*eps(min(abs(obj.results),abs(disp)));
            if abs(obj.results-disp) < tolerance
                passed = 1;
            else
                passed = 0;
            end
        end
        
        function displayStatus(obj, passed, type)
            switch passed
                case {1}
                    fprintf('['); fprintf(type); fprintf('] ');
                    fprintf('Test '); cprintf('-comment', 'passed'); fprintf('!\n');
                case {0}
                    fprintf('['); fprintf(type); fprintf('] ');
                    fprintf('Test ') ; cprintf('-err', 'failed') ; fprintf('!\n') ;
            end
        end
    end
end