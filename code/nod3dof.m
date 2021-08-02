%% Funció nod3dof(i,j)
% Retorna el grau de llibertat associat a un node

function I = nod3dof(i,j)
I = 3*(i-1)+j; % 3 = ni
end