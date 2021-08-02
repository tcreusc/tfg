%% Funció stiffnessBars(dim,x,Tn,mat,Tmat)
% Retorna la matriu de rigidesa de cadascuna de les barres element i la
% llargada de cadascuna de les barres

function [Kel, leng] = stiffnessBars(dim,x,Tn,mat,Tmat)

Kel = zeros(dim.nne*dim.ni,dim.nne*dim.ni,dim.nel);
leng = zeros(dim.nel,1);

for e = 1:dim.nel
    x1e = x( Tn(e,1), 1 );
    x2e = x( Tn(e,2), 1 );
    y1e = x( Tn(e,1), 2 );
    y2e = x( Tn(e,2), 2 );

    le = sqrt( (x2e - x1e)^2 + (y2e - y1e)^2 );
    leng(e,1) = le;
    
    Ee = mat(Tmat(e),1);
    Ae = mat(Tmat(e),2);
    Ize = mat(Tmat(e),3);
    
    Re = 1/le* [
        x2e - x1e, y2e - y1e, 0, 0, 0, 0;
        -(y2e - y1e), x2e - x1e, 0, 0, 0, 0;
        0, 0, le, 0, 0, 0;
        0, 0, 0, x2e - x1e, y2e - y1e, 0;
        0, 0, 0, -(y2e - y1e), x2e - x1e, 0;
        0, 0, 0, 0, 0, le;
        ];
    Keprima = Ize*Ee/le^3 * [
        0, 0, 0, 0, 0, 0;
        0, 12, 6*le, 0, -12, 6*le;
        0, 6*le, 4*le^2, 0, -6*le, 2*le^2;
        0, 0, 0, 0, 0, 0;
        0, -12, -6*le, 0, 12, -6*le;
        0, 6*le, 2*le^2, 0, -6*le, 4*le^2;
        ] + Ae*Ee/le * [
        1, 0, 0, -1, 0, 0;
        0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0;
        -1, 0, 0, 1, 0, 0;
        0, 0, 0, 0, 0, 0;
        0, 0, 0, 0, 0, 0;        
        ];
      
    Ke = transpose(Re)* Keprima * Re;
                          
    for r =1:dim.nne*dim.ni
        for s = 1:dim.nne*dim.ni
            Kel (r,s,e) = Ke(r,s);
        end
    end
end

end