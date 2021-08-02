%% Funció assemblyK(dim,Kel,Td,globalFext)
% A partir de les diferents matrius de rigidesa i de forces locals de cada
% barra, retorna la matriu de rigidesa i de forces globals del sistema

function [Fext,KG] = assemblyK(dim,Kel,Td,globalFext)

KG = zeros(dim.ndof,dim.ndof);
Fext = zeros(dim.ndof,1);
Fext = Fext + globalFext;

for e = 1:dim.nel
    for i = 1:dim.nne*dim.ni
        I = Td(e,i);
        Fext(I) = Fext(I)+ 0; % Ja no hi ha Fel, no hi ha força elemental
        
        for j = 1:dim.nne*dim.ni
            J = Td(e,j);
            KG(I, J) = KG(I, J) + Kel(i,j,e);
        end
    end
end

end