%% Plot disks with different orientation
function vb_plotWeight(sd,sdOrn,gmp,sdWt)

figure

for fac=1:gmp.nFa
    for qdc=1:4
        dCrd=[sd(fac,1)+gmp.dskRd*cos(sdOrn(fac)+pi/2*(qdc-1):...
            pi/24:sdOrn(fac)+pi/2*qdc);
            sd(fac,2)+gmp.dskRd*sin(sdOrn(fac)+pi/2*(qdc-1):...
            pi/24:sdOrn(fac)+pi/2*qdc)];
        if mod(qdc,2)==1
            plot(dCrd(1,:),dCrd(2,:),'r','LineWidth',2);
            hold on;
        else
            plot(dCrd(1,:),dCrd(2,:),'b','LineWidth',2);
            hold on;
        end
       
    end
end

for fac=1:size(sdWt,1)
    dCrd=[sdWt(fac,1)+gmp.dskWtRd*cos(0:pi/24:2*pi);
        sdWt(fac,2)+gmp.dskWtRd*sin(0:pi/24:2*pi)];
    plot(dCrd(1,:),dCrd(2,:),'Color',[0.7,0.7,0.7],'LineWidth',2);
end


plRng=[min([sd(:,1);sdWt(:,1)])-1.5*gmp.dskWtRd,...
    max([sd(:,1);sdWt(:,1)])+1.5*gmp.dskWtRd;...
    min([sd(:,2);sdWt(:,2)])-1.5*gmp.dskWtRd,...
    max([sd(:,2);sdWt(:,2)])+1.5*gmp.dskWtRd];
axis([plRng(1,1) plRng(1,2) plRng(2,1) plRng(2,2)]);    
pbaspect([plRng(1,2)-plRng(1,1) plRng(2,2)-plRng(2,1) 1]);


end