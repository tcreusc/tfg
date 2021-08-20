classdef stiffnessLocalMatrixCalculator < handle
    
    properties(SetAccess = private, GetAccess = public)
        Ke, Re
    end
    
    properties(Access = private)
        Keprima
    end
    
    methods
        function obj = stiffnessLocalMatrixCalculator(stiffnessElement, stiffnessMaterial)
            obj.calculateReMatrix(stiffnessElement);
            obj.calculateKeprimaMatrix(stiffnessElement,stiffnessMaterial);
            obj.calculateKeMatrix();
        end
    end
    
    methods(Access = private)
                
        function calculateReMatrix(obj, stiffnessElement)
            [x1e, x2e, y1e, y2e, le] = stiffnessElement.getElementData();
            obj.Re = 1/le* [
                x2e - x1e, y2e - y1e, 0, 0, 0, 0;
                -(y2e - y1e), x2e - x1e, 0, 0, 0, 0;
                0, 0, le, 0, 0, 0;
                0, 0, 0, x2e - x1e, y2e - y1e, 0;
                0, 0, 0, -(y2e - y1e), x2e - x1e, 0;
                0, 0, 0, 0, 0, le;
                ];
    
        end
        
        function calculateKeprimaMatrix(obj, stiffnessElement, stiffnessMaterial)
            [~, ~, ~, ~, le] = stiffnessElement.getElementData();
            [Ee, Ae, Ize] = stiffnessMaterial.getMaterialData();

            obj.Keprima = Ize*Ee/le^3 * [
                            0, 0, 0, 0, 0, 0;
                            0, 12, 6*le, 0, -12, 6*le;
                            0, 6*le, 4*le^2, 0, -6*le, 2*le^2;
                            0, 0, 0, 0, 0, 0;
                            0, -12, -6*le, 0, 12, -6*le;
                            0, 6*le, 2*le^2, 0, -6*le, 4*le^2;
                            ] + Ae*Ee/le * [
                            1, 0, 0, -1, 0, 0;
                            0, 0, 0, 0, 0, 0;
                            0, 0, 0, 0, 0, 0;
                            -1, 0, 0, 1, 0, 0;
                            0, 0, 0, 0, 0, 0;
                            0, 0, 0, 0, 0, 0;        
                            ];
        end

        function calculateKeMatrix(obj)
            obj.Ke = transpose(obj.Re)* obj.Keprima * obj.Re;
        end
    end
    
end

