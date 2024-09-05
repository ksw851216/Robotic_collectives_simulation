%% Compute normal forces
function [nmFrcWt,nmFrcRct]=vb_normalForceWeight(sd,sdWt,gmp)

% Compute normal force
nmFrcWt=zeros(size(sdWt,1),2);
nmFrcRct=zeros(gmp.nFa,2);

for fac=1:size(sdWt,1)
    dis=sqrt((sd(:,1)-sdWt(fac,1)).^2+(sd(:,2)-sdWt(fac,2)).^2)/...
        (gmp.dskRd+gmp.dskWtRd);
    fnId=find(dis<1);

    %% Repulsive part
    for nec=1:numel(fnId)
        nvec=sd(fnId(nec),:)-sdWt(fac,:);
        nvec=nvec/norm(nvec);
        nmag=(dis(fnId(nec))-1);
        nmFrcWt(fac,:)=nmFrcWt(fac,:)+10*nmag*nvec;
        nmFrcRct(fnId(nec),:)=nmFrcRct(fnId(nec),:)-10*nmag*nvec;
    end    
end

end

