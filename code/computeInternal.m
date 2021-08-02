%% Funció computeInternal(dim,u,x,Tn,Td,Kel)
% Retorna els esforcos axials, tallants i els moments de cada barra
% elemental

function [Fx,Fy,Mz] = computeInternal(dim,u,x,Tn,Td,Kel)

for e = 1:dim.nel
    x1e = x( Tn(e,1), 1 );
    x2e = x( Tn(e,2), 1 );
    y1e = x( Tn(e,1), 2 );
    y2e = x( Tn(e,2), 2 );

    le = sqrt( (x2e - x1e)^2 + (y2e - y1e)^2 );
    Re = 1/le* [
        x2e - x1e, y2e - y1e, 0, 0, 0, 0;
        -(y2e - y1e), x2e - x1e, 0, 0, 0, 0;
        0, 0, le, 0, 0, 0;
        0, 0, 0, x2e - x1e, y2e - y1e, 0;
        0, 0, 0, -(y2e - y1e), x2e - x1e, 0;
        0, 0, 0, 0, 0, le;
        ];
    
    for i = 1:dim.nne*dim.ni
        I = Td(e,i);
        ue(i,1) = u(I);
    end
    
    Feint = Re*Kel(:,:,e)*ue;
    Fx(e,1) = -Feint(1);
    Fx(e,2) = Feint(4);
    Fy(e,1) = -Feint(2);
    Fy(e,2) = Feint(5);
    Mz(e,1) = -Feint(3);
    Mz(e,2) = Feint(6);
    
end

end