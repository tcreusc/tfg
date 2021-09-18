classdef GlobalStiffnessMatrixComputer < handle

    properties(SetAccess = private, GetAccess = public) % stiffnessmatrix sense global
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
        Tconn
        fdata
    end
    
    methods(Access = public)
        function obj = GlobalStiffnessMatrixComputer(cParams)
            obj.init(cParams);
        end
                
        function obj = compute(obj)
            obj.createElementStiffness();
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
            obj.Tconn = cParams.Tconn;
        end
        
        function createElementStiffness(obj)
            nel = obj.dim.nel;
            nne = obj.dim.nne;
            ni  = obj.dim.ni;
            Kelem = zeros(nne*ni,nne*ni,nel);
            for iElem = 1:nel
                elem = obj.initializeElement(iElem);
                [KBase, Re] = obj.initializeStiffnessMatrices(elem);
                Ke = obj.calculateLocalStiffnessMatrix(KBase, Re);
                K = obj.assembleElementStiffness(iElem,Ke); % en dos passos
                Kelem(:,:,iElem) = K;
            end
            obj.KElem = Kelem;
        end
        
        function assembleGlobalMatrix(obj)
            ndof = obj.dim.ndof;
            nne  = obj.dim.nne;
            ni   = obj.dim.ni;
            nel  = obj.dim.nel;
            Kg = zeros(ndof,ndof);
            for elem = 1:nel
                for i = 1:nne*ni
                    I = obj.Tconn(elem,i);
                    for j = 1:nne*ni
                        J = obj.Tconn(elem,j);
                        % obj.Kelem ... 
                        Kg(I, J) = Kg(I, J) + obj.KElem(i,j,elem);
                    end
                end
            end
            obj.KGlobal = Kg;
        end
        
        function n = initializeElement(obj, e)
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
        
        function [KB, Re] = initializeStiffnessMatrices(obj, n) % passar a Static, separar en rotation i euclidean stiffness
            s.n = n;
            RM = RotationMatrixComputer(s);
            RM.compute();
            Re = RM.RotationMatrix;
            ESC = ElementStiffnessComputer(s);
            ESC.compute();
            KB = ESC.KBase;
        end
        
        function Ke = calculateLocalStiffnessMatrix(obj, K, R) %rotateStiffnessMat
            Ke = transpose(R) * K * R;
        end
        
        function Kel = assembleElementStiffness(obj, e, Ke, Kel)
            % construir aqui, que no surti el mateix que entra
            for r =1:obj.dim.nne*obj.dim.ni
                for s = 1:obj.dim.nne*obj.dim.ni
                    Kel (r,s,e) = Ke(r,s);
                end
            end
        end
    end
end