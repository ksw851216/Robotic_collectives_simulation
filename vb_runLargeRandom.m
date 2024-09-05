%% Initialize workspace
clearvars;
close all;

%% Create a output folder
odr='./dataVibrationLargeRandom/';
if ~exist(odr,'dir')
    mkdir(odr);
end

rmx=10;

for rpc=1:1
    %% define model parameters
    % dskRd: disk radius, R0. 
    % atCon: attraction strength
    % atDis: attraction range
    % mtTrq: mean motor torque
    % mtFlc: motor torque fluctuation magnitude
    % mtFlcWth: motor torque fluctuation width
    % mtFlcCut: motor torque fluctuation cut off
    % plPrd: pulse period (up+down)
    % plFlc: pulse fluctuation (0-1, 0:no fluctuation, 1:max fluctuation) 
    % afCon: angular friction between disk and floor 
    
    [dskRd,dskWtRd,when]=deal(1,2,'20231023');
    [atCon,atDis]=deal(0.05,3);
    [mtTrq,mtFlc,mtFlcWth,mtFlcCut]=deal(0.035,0.03,0005,0.001);
    [plPrd,plFlc]=deal(30,0);
    afCon=10;
    extFrc=0.3;
    
    %% Create a structure variable that contains all model parameters
    gmp=struct;
    [gmp.dskRd,gmp.afCon]=deal(dskRd,afCon);
    [gmp.atCon,gmp.atDis]=deal(atCon,atDis);
    [gmp.mtTrq,gmp.mtFlc,gmp.mtFlcWth,gmp.mtFlcCut]=...
        deal(mtTrq,mtFlc,mtFlcWth,mtFlcCut);
    [gmp.plPrd,gmp.plFlc]=deal(plPrd,plFlc);
    gmp.dt=0.05;
    gmp.plCnt=floor(gmp.plPrd/gmp.dt);
    gmp.dskWtRd=dskWtRd;
    
    rng('shuffle');
                
    %% Generate initial configuration of four disks
    dis=(2/gmp.atCon-gmp.atDis)/(1/gmp.atCon-1)*gmp.dskRd;
    height=sqrt(3)*dis/2;
    sd=vb_hexagonHorizontalArray(dis,height,20,10);
    sdWt=[5*dis,10.8*height;15*dis,10.8*height];
    
    
    gmp.angTol=0.05;
    gmp.nFa=size(sd,1);
    sdOrn=rand(gmp.nFa,1)*2*pi;
    
    vb_plotWeight(sd,sdOrn,gmp,sdWt);
    
    %% Set initial motor torque values
    sdMt=ones(gmp.nFa,1)*gmp.mtTrq;
    mtCnt=zeros(gmp.nFa,1);
    for fac=1:gmp.nFa
        mtCnt(fac)=floor((0.8*rand()+0.2)*gmp.plCnt);
        mtCnt(fac)=mtCnt(fac)-mod(mtCnt(fac),2);
    end
    hfCnt=floor(mtCnt/2);
    % 
    ttTm=30;
    itMx=gmp.plCnt*ttTm;
    tmSt=gmp.plCnt;
    dmx=itMx/tmSt+1;
    % 
    sdDt=cell(dmx,1);
    sdWtDt=cell(dmx,1);
    sdDt{1}=[sd,sdOrn,sdMt];
    sdWtDt{1}=sdWt;
    dtc=2;

    vb_plotWeight(sd,sdOrn,gmp,sdWt);

    xPosMx=max(sd(:,1));
    lfCellId=find(sd(:,1)<xPosMx/2);

    %% Creat an external force matrix
    extFrcMat=zeros(size(sdWt,1),2);
    extFrcMat(:,2)=-extFrc;

    % % % 
    for tmc=1:itMx
        [sd,sdWt,sdOrn]=vb_iterationForceWeight(sd,sdOrn,sdMt,gmp,extFrcMat,sdWt);
        sd(sd(:,2)<0,2)=0;
        sdWt(sdWt(:,2)<0.5,2)=0.5;
        mtCnt=mtCnt-1;

        if any(mtCnt==0) && gmp.mtFlc~=0
            fId=find(mtCnt==0);
            for fac=1:numel(fId)
                mtCnt(fId(fac))=floor((0.4*rand()+0.8)*gmp.plCnt);
                mtCnt(fId(fac))=mtCnt(fId(fac))-mod(mtCnt(fId(fac)),2);
                hfCnt(fId(fac))=floor(mtCnt(fId(fac))/2);
                chk=0;
                while chk==0
                    mtFlcMag=normrnd(gmp.mtFlc,gmp.mtFlcWth);
                    if mtFlcMag>mtFlc-mtFlcCut && mtFlcMag<mtFlc+mtFlcCut
                        chk=1;
                    end
                end
                sdMt(fId(fac))=gmp.mtTrq+mtFlcMag; 
            end
                sdMt(lfCellId)=0;
        end

        if any(mtCnt==hfCnt) && gmp.mtFlc~=0
            fId=find(mtCnt==hfCnt);
            for fac=1:numel(fId)
                sdMt(fId(fac))=gmp.mtTrq+(gmp.mtTrq-sdMt(fId(fac))); 
            end
                sdMt(lfCellId)=0;
        end

        if mod(tmc,tmSt)==0
            sdDt{dtc}=[sd,sdOrn,sdMt];
            sdWtDt{dtc}=sdWt;
            dtc=dtc+1;
        end
    end

    vb_plotWeight(sd,sdOrn,gmp,sdWt);

end
