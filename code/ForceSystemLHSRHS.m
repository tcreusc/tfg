classdef ForceSystemLHSRHS
    properties(SetAccess = private, GetAccess = public)
        LHS, RHS
    end
    
    properties(Access = private)
        KRL, KRR, FRext
    end
    
    methods(Access = public)
        function obj = ForceSystemLHSRHS(KG, ur, vl, vr, Fext)
            KLL = KG(vl, vl);
            KLR = KG(vl, vr);
            FLext = Fext(vl,1);
            obj.KRL = KG(vr, vl);
            obj.KRR = KG(vr, vr);
            obj.FRext = Fext(vr,1);
            
            obj.LHS = FLext - KLR*ur;
            obj.RHS = KLL;  
        end
        
        function [LHS,RHS] = getLHSRHS(obj)
            LHS = obj.LHS;
            RHS = obj.RHS;
        end
        
        function [KRL, KRR, FRext] = getDisplacementData(obj)
            KRL = obj.KRL;
            KRR = obj.KRR;
            FRext = obj.FRext;
        end
    end
    methods(Access = private)
    end
end

