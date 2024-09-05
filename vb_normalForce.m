%% Compute normal forces
function nmFrc=vb_normalForce(sd,gmp,dsMat,fnId,fnAtId)

nmFrc=zeros(gmp.nFa,2);
for fac=1:gmp.nFa
    for nec=1:size(fnId{fac},2)
        nvec=sd(fnId{fac}(nec),:)-sd(fac,:);
        nvec=nvec/norm(nvec);
        nmag=(dsMat(fac,fnId{fac}(nec))/gmp.dskRd-2);
        nmFrc(fac,:)=nmFrc(fac,:)+nmag*nvec;
    end
    
    for nec=1:size(fnAtId{fac},2)
        nvec=sd(fnAtId{fac}(nec),:)-sd(fac,:);
        nvec=nvec/norm(nvec);
        nmag=gmp.atCon*(gmp.atDis-dsMat(fac,fnAtId{fac}(nec))/gmp.dskRd);
        nmFrc(fac,:)=nmFrc(fac,:)+nmag*nvec;
    end
    
    
end

end

