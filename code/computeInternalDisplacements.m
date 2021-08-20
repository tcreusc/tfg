function  ue = computeInternalDisplacements(dim, e, Td, u)
    for i = 1:dim.nne*dim.ni
            I = Td(e,i);
            ue(i,1) = u(I);
    end
end

