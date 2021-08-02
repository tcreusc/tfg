%% Funció connectDOF(dim,Tn)
% A partir de la matriu de connectivitats de nodes, retorna una matriu de
% connectivitats de DOFs, es a dir, canvia cada node pels graus de
% llibertat del node en questio.

function Td = connectDOF(dim,Tn)

Td = zeros(dim.nel,dim.nne*dim.ni);

for e = 1:dim.nel % 1, 2, 3, ... número d'elements
    for i = 1:dim.nne % 1 o 2, node 1 o 2 locals.
        for j = 1:dim.ni % 1 o 2, direccions
            I = dim.ni*(i-1)+j;
            Td(e,I) = dim.ni*(Tn(e,i)-1)+j;
        end
    end
end

end