%% Plot disks with different orientation
function vb_plot(sd,sdOrn,gmp)

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

plRng=[min(sd(:,1))-1.5*gmp.dskRd,max(sd(:,1))+1.5*gmp.dskRd;...
    min(sd(:,2))-1.5*gmp.dskRd,max(sd(:,2))+1.5*gmp.dskRd];
axis([plRng(1,1) plRng(1,2) plRng(2,1) plRng(2,2)]);    
pbaspect([plRng(1,2)-plRng(1,1) plRng(2,2)-plRng(2,1) 1]);


end