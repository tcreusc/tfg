classdef StiffnessMatrixComputer < TestableObject

    properties(SetAccess = private, GetAccess = public)
        KGlobal
        KElem
    end
    
    properties(Access = private)
        dim
        data
        connectivities
    end

    methods(Access = public)

        function obj = StiffnessMatrixComputer(cParams)
            obj.init(cParams);
        end
        
    end
    
    methods(Access = protected)   
        
        function obj = compute(obj)
            obj.createElementStiffness();
            obj.assembleGlobalMatrix();
        end
        
    end
    
    methods(Access = private)
        
        function init(obj, cParams)
            obj.dim            = cParams.dim;
            obj.data           = cParams.data;
            obj.connectivities = cParams.connectivities;
        end

        function createElementStiffness(obj)
            nel = obj.dim.nel;
            nne = obj.dim.nne;
            ni  = obj.dim.ni;
            Kelem = zeros(nne*ni,nne*ni,nel);
            for iElem = 1:nel
                bar   = obj.createBar(iElem);
                Re    = bar.calculateRotationMatrix();
                KBase = bar.calculateEuclideanStiffnessMatrix();
                Ke    = obj.rotateStiffnessMatrix(KBase, Re);
                Kelem(:,:,iElem) = Ke;
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
                    I = obj.connectivities(elem,i);
                    for j = 1:nne*ni
                        J = obj.connectivities(elem,j);
                        Kel = obj.KElem(i, j, elem); 
                        Kg(I, J) = Kg(I, J) + Kel;
                    end
                end
            end
            obj.KGlobal = Kg;
        end

        function bar = createBar(obj, e)
            s.data = obj.data;
            bar = Bar(s);
            bar.create(e);
        end
    end

    methods(Static)

        function Ke = rotateStiffnessMatrix(K, R)
            Ke = transpose(R) * K * R;
        end

    end
end