%% Funció globalFext(dim,fdata)
% A partir de les dades introduides per la forca externa, retorna la matriu
% global de forces externes

function Fext = globalFext(dim,fdata)

Fext = zeros(dim.ndof,1);
for i = 1:height(fdata)
   Fext ( nod3dof( fdata(i,1), fdata(i,2) ) ,1) = fdata(i,3);
end

end