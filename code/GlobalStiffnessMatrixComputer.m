%% Funció stiffnessBars(dim,x,Tn,mat,Tmat)
% Retorna la matriu de rigidesa de cadascuna de les barres element i la
% llargada de cadascuna de les barres
classdef GlobalStiffnessMatrixComputer < handle

    properties(SetAccess = private, GetAccess = public)
        Kel, leng
    end
    
    properties(Access = private)
        
    end
    
    methods(Access = public)
        
        function obj = GlobalStiffnessMatrixComputer(dim,x,Tn,mat,Tmat)
            obj.calculateGlobalStiffnessMatrix(dim,x,Tn,mat,Tmat);
        end

        function [Kel] = getMatrix(obj)
            Kel = obj.Kel;
        end
        
    end
    
    methods(Access = private)   
        
        function calculateGlobalStiffnessMatrix(obj, dim,x,Tn,mat,Tmat)
            
            vKel = zeros(dim.nne*dim.ni,dim.nne*dim.ni,dim.nel);
                for e = 1:dim.nel
                    stiffnessElement  = stiffnessElementCalculator(x,Tn,e);
                    stiffnessMaterial = stiffnessMaterialData(mat,Tmat,e);    
                    Ke = stiffnessLocalMatrixCalculator(stiffnessElement, stiffnessMaterial).Ke;

                    for r =1:dim.nne*dim.ni
                        for s = 1:dim.nne*dim.ni
                            vKel (r,s,e) = Ke(r,s);
                        end
                    end
                end
                
             obj.Kel = vKel;
        end
                
    end
end

function [Kel, leng] = stiffnessBars(dim,x,Tn,mat,Tmat)


end