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
                [Keprima, Re] = obj.initializeStiffnessMatrices(nodes);
                Ke = obj.calculateLocalStiffnessMatrix(Keprima, Re);
                Kel = obj.assembleElementStiffness(iElem,Ke, Kel);
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
            X    = obj.x;
            Tnod   = obj.Tn;
            Mat  = obj.mat;
            Tmater = obj.Tmat;
            n.x1e = X(Tnod(e,1), 1);
            n.x2e = X(Tnod(e,2), 1);
            n.y1e = X(Tnod(e,1), 2);
            n.y2e = X(Tnod(e,2), 2);
            n.le  = obj.calculateElementLength(n);
            n.Ee  = Mat(Tmater(e),1);
            n.Ae  = Mat(Tmater(e),2);
            n.Ize = Mat(Tmater(e),3);
        end
        
        function le = calculateElementLength(obj, n)
            le = sqrt((n.x2e - n.x1e)^2 + (n.y2e - n.y1e)^2);
        end
        
        function [Ke, Re] = initializeStiffnessMatrices(obj, n)
            s.n = n;
            RM = RotationMatrixComputer(s);
            RM.compute();
            Re = RM.RotationMatrix;
            ESC = ElementStiffnessComputer(s);
            ESC.compute();
            Ke = ESC.Keprima;
        end
        
        function Ke = calculateLocalStiffnessMatrix(obj, K, R)
            Ke = transpose(R) * K * R;
        end
        
        function Kel = assembleElementStiffness(obj, e, Ke, Kel)
            for r =1:obj.dim.nne*obj.dim.ni
                for s = 1:obj.dim.nne*obj.dim.ni
                    Kel (r,s,e) = Ke(r,s);
                end
            end
        end
    end
end