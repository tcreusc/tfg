classdef BoundaryConditionsApplier < handle

    properties(SetAccess = private, GetAccess = public)
        fixedDisp
        fixedDOFs
        freeDOFs
    end

    properties(Access = private)
        dim
        Fext
        fixnod
        KGlobal
    end

    methods(Access = public)
        
        function obj = BoundaryConditionsApplier(cParams)
            obj.init(cParams);
        end

        function obj = fix(obj)
        end
        
        function KLL = calculateFreeStiffnessMatrix(obj)
            freeDOF = obj.freeDOFs;
            KG      = obj.KGlobal;
            KLL     = KG(freeDOF, freeDOF);
        end
        
        function F = calculateForceMatrix(obj)
            KG   = obj.KGlobal;
            Fex  = obj.Fext;
            freeDOFS   = obj.freeDOFs;
            fixedDis   = obj.fixedDisp;
            freeFixedK = obj.calculateFreeFixedStiffnessMatrix(KG);
            freeFext   = Fex(freeDOFS,1);
            F = freeFext - freeFixedK * fixedDis;
        end

    end

    methods(Access = private)
        function init(obj, cParams)
            obj.dim     = cParams.dim;
            obj.Fext    = cParams.Fext;
            obj.KGlobal = cParams.KGlobal;
            obj.fixnod  = cParams.data.fixnod;
            obj.calculateFixedData();
            obj.calculateFreeDOFs();
        end

        function calculateFixedData(obj)
            fnod = obj.fixnod;
            d = obj.dim;
            h = height(fnod);
            vr = zeros(h, 1);
            ur = zeros(h, 1);
            for j = 1:h
               val = fnod(j,3);
               converter = NodeDOFConverter(d, fnod, j);
               DOF = converter.convert();
               vr(j) = DOF;
               ur(j) = val;
            end
            obj.fixedDOFs = vr;
            obj.fixedDisp = ur;
        end

        function calculateFreeDOFs(obj)
            d = obj.dim;
            count = 1;
            for dof = 1:d.ndof
                if ~ismember(dof, obj.fixedDOFs)
                    vl(count) = dof;
                    count = count+1;
                end
            end
            obj.freeDOFs = vl;
        end
        
        function KRL = calculateFreeFixedStiffnessMatrix(obj, KG)
            freeDOF = obj.freeDOFs;
            fixedDOF = obj.fixedDOFs;
            KRL   = KG(freeDOF, fixedDOF);
        end
        
    end
end