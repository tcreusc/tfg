classdef Test
    % Classe Test
    % La propietat status es 1 si ha passat, i 0 si ha fallat. Cada test te
    % associats uns desplacaments determinats, que son consequencia de les
    % dades que s'han introduit per fer correr el test en questio.
    
    % Nota: encara cal fer que materialData, geometricData i boundaryData
    % siguin utils.
    
    properties
        desplacaments, materialData, geometricData, boundaryData, status
    end
    
    methods
        function test = Test(materialData,geometricData, boundaryData)
            test.desplacaments = performAnalysis;
            test.materialData = materialData;
            test.geometricData = geometricData;
            test.boundaryData = boundaryData;
            
            if (test.desplacaments == performAnalysis)
                test.status = 1;
            else
                test.status = 0;
            end
        end
        
    end
end

