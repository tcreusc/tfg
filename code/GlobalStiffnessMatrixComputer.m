%% Funció stiffnessBars(dim,x,Tn,mat,Tmat)
% Retorna la matriu de rigidesa de cadascuna de les barres element i la
% llargada de cadascuna de les barres

classdef GlobalStiffnessMatrixComputer < handle

    properties(SetAccess = private, GetAccess = public)
        KGlobal
        KElem
    end
    
    properties(Access = private)
        dim
        data
        x
        Tn
        mat
        Tmat
        Td
        fdata
    end
    
    methods(Access = public)
        function obj = GlobalStiffnessMatrixComputer(cParams)
            obj.init(cParams);
        end
                
        function obj = compute(obj)
            obj.createLocalStiffnessBars();
            obj.assembleGlobalMatrix();
        end
    end
    
    methods(Access = private)   
        function init(obj, cParams)
            obj.dim   = cParams.dim;
            obj.x     = cParams.data.x;
            obj.Tn    = cParams.data.Tn;
            obj.mat   = cParams.data.mat;
            obj.Tmat  = cParams.data.Tmat;
            obj.fdata = cParams.data.fdata;
            obj.Td    = cParams.Td;
        end
        
        function createLocalStiffnessBars(obj)
            Kel = zeros(obj.dim.nne*obj.dim.ni,obj.dim.nne*obj.dim.ni,obj.dim.nel);
            for iElem = 1:obj.dim.nel
                nodes = obj.initializeNodes(iElem);
                Ke = obj.initializeStiffnessMatrices(nodes);
                Kel = obj.calculateLocalStiffness(iElem,Ke, Kel);
            end
            obj.KElem = Kel;
        end
        
        function assembleGlobalMatrix(obj)
            ndof = obj.dim.ndof;
            nne  = obj.dim.nne;
            ni   = obj.dim.ni;
            nel  = obj.dim.nel;
            Kg = zeros(ndof,ndof);
            for e = 1:nel
                for i = 1:nne*ni
                    I = obj.Td(e,i);
                    for j = 1:nne*ni
                        J = obj.Td(e,j);
                        Kg(I, J) = Kg(I, J) + obj.KElem(i,j,e);
                    end
                end
            end
            obj.KGlobal = Kg;
        end
        
        function n = initializeNodes(obj, e)
            n.x1e = obj.x(obj.Tn(e,1), 1);
            n.x2e = obj.x(obj.Tn(e,2), 1);
            n.y1e = obj.x(obj.Tn(e,1), 2);
            n.y2e = obj.x(obj.Tn(e,2), 2);
            n.le = sqrt((n.x2e - n.x1e)^2 + (n.y2e - n.y1e)^2); % moure a funcio
            n.Ee = obj.mat(obj.Tmat(e),1);
            n.Ae = obj.mat(obj.Tmat(e),2);
            n.Ize = obj.mat(obj.Tmat(e),3);
        end
        
        function Ke = initializeStiffnessMatrices(obj, n)
            % crear amb zeros i anar omplint
            % refer nodes
            Re = 1/n.le* [
                n.x2e - n.x1e, n.y2e - n.y1e, 0, 0, 0, 0;
                -(n.y2e - n.y1e), n.x2e - n.x1e, 0, 0, 0, 0;
                0, 0, n.le, 0, 0, 0;
                0, 0, 0, n.x2e - n.x1e, n.y2e - n.y1e, 0;
                0, 0, 0, -(n.y2e - n.y1e), n.x2e - n.x1e, 0;
                0, 0, 0, 0, 0, n.le;
                ];
            le  = n.le;
            c1 = n.Ize*n.Ee/le^3;
            c2 = n.Ae*n.Ee/le;
            Keprima = zeros(6,6);
            Keprima(1,1) = c2;
            Keprima(1,4) = -c2;
            Keprima(2,2) = c1 * 12;
            Keprima(2,3) = c1 * 6*le;
            Keprima(2,5) = c1 * (-12);
            Keprima(2,6) = c1 * 6*le;
            Keprima(3,2) = c1 * 6*le;
            Keprima(3,3) = c1 * 4*le^2;
            Keprima(3,5) = c1 * (-6*le);
            Keprima(3,6) = c1 * 2*le^2;
            Keprima(4,1) = -c2;
            Keprima(4,4) = c2;
            Keprima(5,2) = -12*c1;
            Keprima(5,3) = -6*le*c1;
            Keprima(5,5) = 12*c1;
            Keprima(5,6) = -6*le*c1;
            Keprima(6,2) = 6*le*c1;
            Keprima(6,3) = 2*le^2*c1;
            Keprima(6,5) = -6*le*c1;
            Keprima(6,6) = 4*le^2*c1;
            Ke = transpose(Re)* Keprima * Re; % moure a funcio rotateStiffnessMatrix
        end
        
        function Kel = calculateLocalStiffness(obj, e, Ke, Kel) %refer
            for r =1:obj.dim.nne*obj.dim.ni
                for s = 1:obj.dim.nne*obj.dim.ni
                    Kel (r,s,e) = Ke(r,s);
                end
            end
        end            
    end
end