%% Funció stiffnessBars(dim,x,Tn,mat,Tmat)
% Retorna la matriu de rigidesa de cadascuna de les barres element i la
% llargada de cadascuna de les barres

classdef GlobalStiffnessMatrix < handle

    properties(SetAccess = private, GetAccess = public)
        KG
        Fext
        leng %residual?
        Kel
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
        function obj = GlobalStiffnessMatrix(cParams)
            obj.init(cParams);
        end
                
        function obj = compute(obj)
            obj.createLocalStiffnessBars();
            obj.createForcesMatrix(); % no s'hauria de fer aqui
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
            for iElem = 1:obj.dim.nel
                nodes = obj.initializeNodes(iElem);
                Ke = obj.initializeStiffnessMatrices(nodes);
                Kel = obj.calculateLocalStiffness(iElem,Ke);
            end
            %refer, ens ho guardem al final i aixi no hi hem d'entrar
            obj.Kel = Kel;
        end
        
        function createForcesMatrix(obj)
            obj.Fext = zeros(obj.dim.ndof,1);
            for i = 1:height(obj.fdata)
               obj.Fext ( nod3dof( obj.fdata(i,1), obj.fdata(i,2) ) ,1) = obj.fdata(i,3);
            end
        end
        
        function assembleGlobalMatrix(obj)
            %canviar ndof = obj.dim.ndof i anar fent
            Kg = zeros(obj.dim.ndof,obj.dim.ndof);
            for e = 1:obj.dim.nel
                for i = 1:obj.dim.nne*obj.dim.ni
                    I = obj.Td(e,i);
                    % obj.Fext(I) = obj.Fext(I)+ 0; % No hi ha força elemental
                    for j = 1:obj.dim.nne*obj.dim.ni
                        J = obj.Td(e,j);
                        Kg(I, J) = Kg(I, J) + obj.Kel(i,j,e);
                    end
                end
            end
            obj.KG = Kg;

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
            Keprima = n.Ize*n.Ee/n.le^3 * [
                0, 0, 0, 0, 0, 0;
                0, 12, 6*n.le, 0, -12, 6*n.le;
                0, 6*n.le, 4*n.le^2, 0, -6*n.le, 2*n.le^2;
                0, 0, 0, 0, 0, 0;
                0, -12, -6*n.le, 0, 12, -6*n.le;
                0, 6*n.le, 2*n.le^2, 0, -6*n.le, 4*n.le^2;
                ] + n.Ae*n.Ee/n.le * [
                1, 0, 0, -1, 0, 0;
                0, 0, 0, 0, 0, 0;
                0, 0, 0, 0, 0, 0;
                -1, 0, 0, 1, 0, 0;
                0, 0, 0, 0, 0, 0;
                0, 0, 0, 0, 0, 0;        
                ];
            Ke = transpose(Re)* Keprima * Re; % moure a funcio rotateStiffnessMatrix
        end
        
        function Kel = calculateLocalStiffness(obj, e, Ke) %refer
            for r =1:obj.dim.nne*obj.dim.ni
                for s = 1:obj.dim.nne*obj.dim.ni
                    obj.Kel (r,s,e) = Ke(r,s);
                end
            end
        end            
    end
end