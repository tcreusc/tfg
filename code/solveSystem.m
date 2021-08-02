%% Funció solveSystem(KG,Fext,ur,vr,vl)
% Soluciona el sistema, i retorna una matriu amb el desplacament de cada
% DOF, i una matriu amb les forces de reaccio

function [u,R] = solveSystem(KG,Fext,ur,vr,vl)

KLL = KG(vl, vl);
KLR = KG(vl, vr);
KRL = KG(vr, vl);
KRR = KG(vr, vr);
FLext = Fext(vl,1);
FRext = Fext(vr,1);

ul = KLL \ (FLext - KLR*ur);
R = KRR * ur + KRL*ul-FRext;

u(vl,1) = ul;
u(vr,1) = ur;
end