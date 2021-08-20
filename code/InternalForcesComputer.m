%% Funció computeInternal(dim,u,x,Tn,Td,Kel)
% Retorna els esforcos axials, tallants i els moments de cada barra
% elemental
classdef InternalForcesComputer < handle

    properties(SetAccess = private, GetAccess = public)
        Fx, Fy, Mz
    end
    
    properties(Access = private)

    end
    methods(Access = public)
        function obj = InternalForcesComputer(dim,u,x,Tn,Td,Kel, mat, Tmat)
            obj.calculateInternal(dim,u,x,Tn,Td,Kel, mat, Tmat);
        end
        
        function [Fx, Fy, Mz] = getForces(obj)
            Fx = obj.Fx;
            Fy = obj.Fy;
            Mz = obj.Mz;
        end
        
    end
    
    methods(Access = private)   
        
        function calculateInternal(obj,dim,u,x,Tn,Td,Kel, mat, Tmat)
             for e = 1:dim.nel
                stiffnessElement = stiffnessElementCalculator(x, Tn, e);
                stiffnessMaterial = stiffnessMaterialData(mat,Tmat,e);
                Re = stiffnessLocalMatrixCalculator(stiffnessElement, stiffnessMaterial).Re;

                ue = computeInternalDisplacements(dim, e, Td, u);

                Feint = Re*Kel(:,:,e)*ue;
                vFx(e,1) = -Feint(1);
                vFx(e,2) = Feint(4);
                vFy(e,1) = -Feint(2);
                vFy(e,2) = Feint(5);
                vMz(e,1) = -Feint(3);
                vMz(e,2) = Feint(6);
             end
            
             obj.Fx = vFx;
             obj.Fy = vFy;
             obj.Mz = vMz;
             
        end
        
    end
end