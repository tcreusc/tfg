%% Funció computeInternal(dim,u,x,Tn,Td,KElem)
% Retorna els esforcos axials, tallants i els moments de cada barra
% elemental
classdef InternalForcesComputer < handle
    properties (SetAccess = private, GetAccess = public)
        Fx, Fy, Mz
    end
    
    properties (Access = private)
        dim
        u
        x
        Tn
        Td
        KElem
    end
    
    methods(Access = public)
        function obj = InternalForcesComputer(cParams)
            obj.init(cParams);
        end
        
        function obj = compute(obj)
            for e = 1:obj.dim.nel
                nodes = obj.initializeNodes(e);
                Re = obj.initializeMatrix(nodes);
                obj.calculateForces(e, Re);
            end
        end
    end
    
    methods(Access = private)
        function init(obj, cParams)
            obj.dim   = cParams.dim;
            obj.u     = cParams.u;
            obj.x     = cParams.data.x;
            obj.Tn    = cParams.data.Tn;
            obj.Td    = cParams.Td;
            obj.KElem = cParams.KElem;  
        end
        
        function calculateInternal(obj,dim,u,x,Tn,Td,KElem, mat, Tmat)
             for e = 1:dim.nel
                stiffnessElement = stiffnessElementCalculator(x, Tn, e);
                stiffnessMaterial = stiffnessMaterialData(mat,Tmat,e);
                Re = stiffnessLocalMatrixCalculator(stiffnessElement, stiffnessMaterial).Re;
                ue = computeInternalDisplacements(dim, e, Td, u);
                Feint = Re*KElem(:,:,e)*ue;
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
        
        function n = initializeNodes(obj, e)
            n.x1e = obj.x(obj.Tn(e,1), 1);
            n.x2e = obj.x(obj.Tn(e,2), 1);
            n.y1e = obj.x(obj.Tn(e,1), 2);
            n.y2e = obj.x(obj.Tn(e,2), 2);
            n.le = sqrt((n.x2e - n.x1e)^2 + (n.y2e - n.y1e)^2);
        end
        
        function Re = initializeMatrix(obj, n) % moure a classe propia
            Re = 1/n.le* [
                n.x2e - n.x1e, n.y2e - n.y1e, 0, 0, 0, 0;
                -(n.y2e - n.y1e), n.x2e - n.x1e, 0, 0, 0, 0;
                0, 0, n.le, 0, 0, 0;
                0, 0, 0, n.x2e - n.x1e, n.y2e - n.y1e, 0;
                0, 0, 0, -(n.y2e - n.y1e), n.x2e - n.x1e, 0;
                0, 0, 0, 0, 0, n.le;
                ];
        end
        
        function calculateForces(obj, e, Re)
                for i = 1:obj.dim.nne*obj.dim.ni
                    I = obj.Td(e,i);
                    ue(i,1) = obj.u(I);
                end
                Feint = Re*obj.KElem(:,:,e)*ue;
                obj.Fx(e,1) = -Feint(1);
                obj.Fx(e,2) = Feint(4);
                obj.Fy(e,1) = -Feint(2);
                obj.Fy(e,2) = Feint(5);
                obj.Mz(e,1) = -Feint(3);
                obj.Mz(e,2) = Feint(6);
        end
    end
end