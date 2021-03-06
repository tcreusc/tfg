classdef Bar < handle

    properties(SetAccess = private, GetAccess = public)
        length
    end
    
    properties(Access = private)
        data
        x1, y1
        x2, y2
        E, A, Iz
        RotationMatrix, KBase
    end
    
    methods(Access = public)
        
        function obj = Bar(cParams)
            obj.init(cParams)
        end
        
        function obj = create(obj, e)
            X    = obj.data.x;
            nod1 = obj.data.Tn(e,1);
            nod2 = obj.data.Tn(e,2);
            Mat  = obj.data.mat;
            Tm   = obj.data.Tmat(e);
            obj.x1 = X(nod1, 1);
            obj.x2 = X(nod2, 1);
            obj.y1 = X(nod1, 2);
            obj.y2 = X(nod2, 2);
            obj.E  = Mat(Tm,1);
            obj.A  = Mat(Tm,2);
            obj.Iz = Mat(Tm,3);
            obj.length  = obj.calculateBarLength();
        end
        
        function Re = calculateRotationMatrix(obj)
            RM = RotationMatrixComputer(obj);
            RM.compute();
            Re = RM.RotationMatrix;
        end
        
        function KB = calculateEuclideanStiffnessMatrix(obj)
            ESC = ElementStiffnessComputer(obj);
            ESC.compute();
            KB = ESC.KBase;
        end
        
        function [x1, y1, x2, y2] = getNodeCoordinates(obj)
            x1 = obj.x1;
            y1 = obj.y1;
            x2 = obj.x2;
            y2 = obj.y2;
        end
        
        function [E, A, Iz] = getMaterialData(obj)
            E = obj.E;
            A = obj.A;
            Iz = obj.Iz;
        end

    end

    methods(Access = protected)
    end
    
    methods(Access = private)
        
        function init(obj, cParams)
            obj.data = cParams.data;
        end
        
        function le = calculateBarLength(obj)
            X1 = obj.x1;
            Y1 = obj.y1;
            X2 = obj.x2;
            Y2 = obj.y2;
            le = sqrt((X2 - X1)^2 + (Y2 - Y1)^2);
        end
        
    end
end

