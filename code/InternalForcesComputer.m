%% Funció computeInternal(dim,u,x,Tn,Td,Kel)
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
        Kel
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
            obj.dim = cParams.dim;
            obj.u = cParams.u;
            obj.x = cParams.data.x;
            obj.Tn = cParams.data.Tn;
            obj.Td = cParams.Td;
            obj.Kel = cParams.Kel;  
        end
        
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
        
        function nodes = initializeNodes(obj, e)
            nodes.x1e = obj.x(obj.Tn(e,1), 1);
            nodes.x2e = obj.x(obj.Tn(e,2), 1);
            nodes.y1e = obj.x(obj.Tn(e,1), 2);
            nodes.y2e = obj.x(obj.Tn(e,2), 2);
            nodes.le = sqrt((nodes.x2e - nodes.x1e)^2 + (nodes.y2e - nodes.y1e)^2);
        end
        
        function Re = initializeMatrix(obj, nodes) % moure a classe propia
            Re = 1/nodes.le* [
                nodes.x2e - nodes.x1e, nodes.y2e - nodes.y1e, 0, 0, 0, 0;
                -(nodes.y2e - nodes.y1e), nodes.x2e - nodes.x1e, 0, 0, 0, 0;
                0, 0, nodes.le, 0, 0, 0;
                0, 0, 0, nodes.x2e - nodes.x1e, nodes.y2e - nodes.y1e, 0;
                0, 0, 0, -(nodes.y2e - nodes.y1e), nodes.x2e - nodes.x1e, 0;
                0, 0, 0, 0, 0, nodes.le;
                ];
        end
        
        function calculateForces(obj, e, Re)
                for i = 1:obj.dim.nne*obj.dim.ni
                    I = obj.Td(e,i);
                    ue(i,1) = obj.u(I);
                end
                Feint = Re*obj.Kel(:,:,e)*ue;
                obj.Fx(e,1) = -Feint(1);
                obj.Fx(e,2) = Feint(4);
                obj.Fy(e,1) = -Feint(2);
                obj.Fy(e,2) = Feint(5);
                obj.Mz(e,1) = -Feint(3);
                obj.Mz(e,2) = Feint(6);
        end
    end
end