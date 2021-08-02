function u = performAnalysis (materialData, geometricData, boundaryData)

%% Input data and previous calculations
run('materialData.m')
run('geometricData.m')
run('boundaryData.m')

%Dimensions
dim.nd = size(x,2);   % Problem dimension
dim.nel = size(Tn,1); % Number of elements (bars)
dim.nnod = size(x,1); % Number of nodes (joints)
dim.nne = size(Tn,2); % Number of nodes in a bar
dim.ni = 3;           % Degrees of freedom per node
dim.ndof = dim.nnod*dim.ni;  % Total number of degrees of freedom

%% Solver

Td = connectDOF(dim,Tn);
[Kel,leng] = stiffnessBars(dim,x,Tn,mat,Tmat);
myglobalFext = globalFext(dim,fdata);
[Fext,KG] = assemblyK(dim,Kel,Td,myglobalFext);
[ur,vr,vl] = fixedDOF(dim,fixnod);
[u,R] = solveSystem(KG,Fext,ur,vr,vl);
[Fx,Fy,Mz] = computeInternal(dim,u,x,Tn,Td,Kel);


end

