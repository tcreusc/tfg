classdef stiffnessMaterialData < handle
    %STIFFNESSMATERIALDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess = private, GetAccess = public)
        
    end
    
    properties(Access = private)
        Ae, Ee, Ize
    end
    
    
    methods(Access = public)
        function obj = stiffnessMaterialData(mat, Tmat, e)  
            obj.Ee = mat(Tmat(e),1);
            obj.Ae = mat(Tmat(e),2);
            obj.Ize = mat(Tmat(e),3);
        end
   
        function [Ee, Ae, Ize] = getMaterialData(obj)  
            Ee = obj.Ee;
            Ae = obj.Ae;
            Ize = obj.Ize;
        end
    end
end

