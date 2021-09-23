classdef (Abstract) TestSolver < handle
    
    properties(SetAccess = protected, GetAccess = public)
        solucio
    end
    
    properties(Access = protected)
        expectedResults
    end
    
    methods(Access = public)
        function obj = TestSolver()
        end
        
        function check(obj, results)
        end
    end
    
    methods (Static)
        function ttype = create(testType, dataFile)
            run(dataFile)
            switch testType
                case {'BAR'}
                    ttype = Bar();
                case {'DISPLACEMENT'}
                    ttype = DisplacementComputer();
                case {'FEM'}
                    s.data = data;
                    s.dim = dim;
                    s.solvertype = 'DIRECT';
                    ttype = FEMAnalyzer(s);
                case {'FORCES'}
                    ttype = ForcesComputer();
                case {'STIFFNESS'}
                    ttype = StiffnessMatrixComputer();
                case {'STRESS'}
                    ttype = StressComputer();
                otherwise
                    error('Invalid Test Type.')
            end
            
        end
    end
    
    methods(Access = private)
        function createTestObject(testType, dataFile)
        end
    end
    
end