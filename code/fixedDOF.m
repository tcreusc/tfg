%% Funció fixedDOF(dim,fixnod)
% A partir de la matriu introduida de nodes fixats, retorna tres matrius:
%   (1) Matriu ur. Conte els desplacaments dels nodes fixats
%   (2) Matriu vr. Conte els DOFs fixats
%   (3) Matriu vl. Conte els DOFs lliures

function [ur,vr,vl] = fixedDOF(dim,fixnod)

vr = zeros(height(fixnod), 1);
ur = zeros(height(fixnod), 1);
vl = zeros(dim.ndof - height(fixnod), 1);

for j = 1:height(fixnod)
   vr(j) = nod3dof (fixnod(j,1),fixnod(j,2));
   ur(j) = fixnod(j,3);
end

count = 1;

for dof = 1:dim.ndof
    if ~ismember(dof, vr)
        vl(count) = dof;
        count = count+1;
    end
end   

end