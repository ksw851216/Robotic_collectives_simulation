%% identify contact information based on the distance
function [fnId,fnAtId,dsMat]=vb_findContact(sd,gmp)

dsMat=zeros(gmp.nFa,gmp.nFa);
[fnId,fnAtId]=deal(cell(gmp.nFa,1));

for fac=1:gmp.nFa
    dsMat(fac,:)=sqrt(sum((sd-repmat(sd(fac,:),gmp.nFa,1)).^2,2));
    fnId{fac}=find(dsMat(fac,:)<=2*gmp.dskRd);
    fnId{fac}=fnId{fac}(fnId{fac}~=fac);
    fnAtId{fac}=find(dsMat(fac,:)<=gmp.atDis*gmp.dskRd);
    fnAtId{fac}=fnAtId{fac}(fnAtId{fac}~=fac);
end

end