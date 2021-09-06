%% Funció stiffnessBars(dim,x,Tn,mat,Tmat)
% Retorna la matriu de rigidesa de cadascuna de les barres element i la
% llargada de cadascuna de les barres

classdef GlobalStiffnessMatrix < handle

    properties(SetAccess = private, GetAccess = public)
        K
        Fext
        leng
    end
    
    properties(Access = private)
        dim
        x
        Tn
        mat
        Tmat
        Td
        fdata
        Kel
    end
    
    methods(Access = public)
        
        function obj = GlobalStiffnessMatrix(dim,x,Tn,mat,Tmat, fdata, Td)
            obj.init(dim,x,Tn,mat,Tmat, fdata, Td);
        end
                
        function obj = compute(obj)
            obj.createLocalStiffnessBars();
            obj.createForcesMatrix();
            obj.assembleGlobalMatrix();
        end
        
    end
    
    methods(Access = private)   
        
        function init(obj, dim,x,Tn,mat,Tmat, fdata, Td)
            obj.dim = dim;
            obj.x = x;
            obj.Tn = Tn;
            obj.mat = mat;
            obj.Tmat = Tmat;
            obj.Td = Td;
            obj.fdata = fdata;
        end
        
        function createLocalStiffnessBars(obj)
            
            for e = 1:obj.dim.nel
                nodes = obj.initializeNodes(e);
                Ke = obj.initializeStiffnessMatrices(nodes);
                obj.calculateLocalStiffness(e,Ke);
            end
            
        end
        
        function createForcesMatrix(obj)
            obj.Fext = zeros(obj.dim.ndof,1);
            for i = 1:height(obj.fdata)
               obj.Fext ( nod3dof( obj.fdata(i,1), obj.fdata(i,2) ) ,1) = obj.fdata(i,3);
            end
        end
        
        function assembleGlobalMatrix(obj)
            
            KG = zeros(obj.dim.ndof,obj.dim.ndof);
            for e = 1:obj.dim.nel
                for i = 1:obj.dim.nne*obj.dim.ni
                    I = obj.Td(e,i);
                    % obj.Fext(I) = obj.Fext(I)+ 0; % No hi ha força elemental

                    for j = 1:obj.dim.nne*obj.dim.ni
                        J = obj.Td(e,j);
                        KG(I, J) = KG(I, J) + obj.Kel(i,j,e);
                    end
                end
            end
            
            obj.K = KG;

        end
        
        function nodes = initializeNodes(obj, e)
            nodes.x1e = obj.x(obj.Tn(e,1), 1);
            nodes.x2e = obj.x(obj.Tn(e,2), 1);
            nodes.y1e = obj.x(obj.Tn(e,1), 2);
            nodes.y2e = obj.x(obj.Tn(e,2), 2);
            nodes.le = sqrt((nodes.x2e - nodes.x1e)^2 + (nodes.y2e - nodes.y1e)^2);
            nodes.Ee = obj.mat(obj.Tmat(e),1);
            nodes.Ae = obj.mat(obj.Tmat(e),2);
            nodes.Ize = obj.mat(obj.Tmat(e),3);
        end
        
        function Ke = initializeStiffnessMatrices(obj, nodes)
            Re = 1/nodes.le* [
                nodes.x2e - nodes.x1e, nodes.y2e - nodes.y1e, 0, 0, 0, 0;
                -(nodes.y2e - nodes.y1e), nodes.x2e - nodes.x1e, 0, 0, 0, 0;
                0, 0, nodes.le, 0, 0, 0;
                0, 0, 0, nodes.x2e - nodes.x1e, nodes.y2e - nodes.y1e, 0;
                0, 0, 0, -(nodes.y2e - nodes.y1e), nodes.x2e - nodes.x1e, 0;
                0, 0, 0, 0, 0, nodes.le;
                ];
            Keprima = nodes.Ize*nodes.Ee/nodes.le^3 * [
                0, 0, 0, 0, 0, 0;
                0, 12, 6*nodes.le, 0, -12, 6*nodes.le;
                0, 6*nodes.le, 4*nodes.le^2, 0, -6*nodes.le, 2*nodes.le^2;
                0, 0, 0, 0, 0, 0;
                0, -12, -6*nodes.le, 0, 12, -6*nodes.le;
                0, 6*nodes.le, 2*nodes.le^2, 0, -6*nodes.le, 4*nodes.le^2;
                ] + nodes.Ae*nodes.Ee/nodes.le * [
                1, 0, 0, -1, 0, 0;
                0, 0, 0, 0, 0, 0;
                0, 0, 0, 0, 0, 0;
                -1, 0, 0, 1, 0, 0;
                0, 0, 0, 0, 0, 0;
                0, 0, 0, 0, 0, 0;        
                ];
            Ke = transpose(Re)* Keprima * Re;
        end
        
        function calculateLocalStiffness(obj, e, Ke)
            for r =1:obj.dim.nne*obj.dim.ni
                for s = 1:obj.dim.nne*obj.dim.ni
                    obj.Kel (r,s,e) = Ke(r,s);
                end
            end
        end         
                
    end
end