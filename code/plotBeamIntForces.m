function plotBeamIntForces(x,Tnod,Fx_el,Fy_el,Mz_el)
% PLOTBEAMINTFORCES - Plot internal forces distribution for the 2D beam
% problem
% Inputs:
%   x        Nodal coordinates matrix
%   Tnod     Nodal connectivities matrix
%   Fx_el    Elemental axial forces [nel x 2]: values of the axial forces
%            at each element's nodes
%   Fy_el    Elemental shear forces [nel x 2]: values of the shear forces
%            at each element's nodes
%   Mz_el    Elemental bending moments [nel x 2]: values of the bending
%            moment at each element's nodes

for e = 1:size(Tnod,1)
    figure('Name',sprintf('Element %i-%i',Tnod(e,:)));
    subplot(3,1,1)
    hold on; box on;
    plot(0:1,Fx_el(e,:));
    plot(0:1,[0,0],'color',0.5*[1,1,1],'linewidth',2);
    ylabel('Axial force (N)');
    subplot(3,1,2)
    hold on; box on;
    plot(0:1,Fy_el(e,:));
    plot(0:1,[0,0],'color',0.5*[1,1,1],'linewidth',2);
    ylabel('Shear force (N)');
    subplot(3,1,3)
    hold on; box on;
    plot(0:1,Mz_el(e,:));
    plot(0:1,[0,0],'color',0.5*[1,1,1],'linewidth',2);
    ylabel('Bending moment (Nm)');
    set(gca,'xlim',[0,1],'xtick',[0,1],'xticklabel',Tnod(e,:));
    xlabel('Node');
end

end