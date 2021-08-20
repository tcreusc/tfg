classdef Test < handle
    % Classe Test
    % La propietat status es 1 si ha passat, i 0 si ha fallat. Cada test te
    % associats uns desplacaments determinats, que son consequencia de les
    % dades que s'han introduit per fer correr el test en questio.
    
    % Nota: encara cal fer que materialData, geometricData i boundaryData
    % siguin utils.
    
    properties(SetAccess = private, GetAccess = public)
        status
    end
    properties(Access = private)
        desplacaments, materialData, geometricData, boundaryData
    end
    
    methods(Access = public)
        function obj = Test(materialData,geometricData, boundaryData)
            obj.materialData = materialData;
            obj.geometricData = geometricData;
            obj.boundaryData = boundaryData;
            obj.computeAnalysis();
            
%             if (obj.desplacaments == performAnalysis)
%                 obj.status = 1;
%             else
%                 obj.status = 0;
%             end
        end
        
        function getStatus()
        end
    end
    methods(Access = private)        
        function computeAnalysis(obj)
            analysis = AnalysisPerformer(obj.materialData, obj.geometricData, obj.boundaryData);
            obj.desplacaments = analysis.getDisplacements();
        end
        %function checkTest
        
    end
end

