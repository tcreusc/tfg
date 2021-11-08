classdef Mesh < handle

    properties (Access = public)
        bars
        connectivities
    end

    properties (Access = private)
        dim
        data
    end
    
    methods (Access = public)

        function obj = Mesh(cParams)
            obj.init(cParams);
        end

    end
    
    methods (Access = private)
        
        function init(obj, cParams)
            obj.dim = cParams.dim;
            obj.data = cParams.data;
            obj.createBars();
            obj.computeConnectivities();
        end
        
        function createBars(obj)
            nel = obj.dim.nel;
            for iElem = 1:obj.dim.nel
                s.data = obj.data;
                bar = Bar(s);
                bar.create(iElem);
                elems(iElem, 1) = bar;
            end
            obj.bars = elems;
        end
        
        function computeConnectivities(obj)
            nel = obj.dim.nel;
            nne = obj.dim.nne;
            ni  = obj.dim.ni;
            T = zeros(nel,nne*ni);
            for e = 1:nel
                for i = 1:nne
                    for j = 1:ni
                        I = ni*(i-1)+j;
                        Tn = obj.data.Tn(e,i);
                        T(e,I) = ni*(Tn-1)+j;
                    end
                end
            end
            obj.connectivities = T;
        end

    end
end

