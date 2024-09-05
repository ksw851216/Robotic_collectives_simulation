%% Compute tangential force
function [tgFrc,agMmt]=vb_tangentForce(sd,sdOrn,sdMt,gmp,fnId)

tgFrc=zeros(gmp.nFa,2);
agMmt=zeros(gmp.nFa,1);

for fac=1:gmp.nFa
    for nec=1:size(fnId{fac},2)
        nid=fnId{fac}(nec);
        %% angle of vector connecting center of two disks
        bndAng=mod(atan2(sd(nid,2)-sd(fac,2),sd(nid,1)-sd(fac,1)),2*pi);
        
        %% angle between center-connecting vector and disk orientation
        cctAng=[mod(bndAng-sdOrn(fac),2*pi),...
            mod((bndAng+pi)-sdOrn(nid),2*pi)];
        cctOrn=zeros(2,1);
        for agc=1:2
            if (cctAng(agc)>=gmp.angTol && cctAng(agc)<=pi/2-gmp.angTol) 
                cctOrn(agc)=1;
            elseif (cctAng(agc)>=pi/2+gmp.angTol && cctAng(agc)<=pi-gmp.angTol)
                cctOrn(agc)=2;
            elseif (cctAng(agc)>=pi+gmp.angTol && cctAng(agc)<=3*pi/2-gmp.angTol)
                cctOrn(agc)=3;                  
            elseif (cctAng(agc)>=3*pi/2+gmp.angTol && cctAng(agc)<=2*pi-gmp.angTol)
                cctOrn(agc)=4;
            end
        end
        
        if cctOrn(1)~=0 && cctOrn(2)~=0
            tmag=sdMt(fac)*(-1)^(1+cctOrn(1))+...
                sdMt(nid)*(-1)^(1+cctOrn(2));
            tgFrc(fac,:)=tgFrc(fac,:)+tmag*...
                [cos(bndAng-pi/2),sin(bndAng-pi/2)];
            agMmt(fac)=agMmt(fac)-tmag;
        end
    end
end

end