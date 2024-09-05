%% Initialize workspace
clearvars;
close all;

%% Create a output folder
odr='./dataVibrationLarge/';
if ~exist(odr,'dir')
    mkdir(odr);
end

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

[dskRd,when]=deal(1,'20230822');
[atCon,atDis]=deal(0.05,3);
[mtTrq,mtFlc,mtFlcWth,mtFlcCut]=deal(0.02,0.015,0.0005,0.001);
[plPrd,plFlc]=deal(30,0);
afCon=10;

%% Create a structure variable that contains all model parameters
gmp=struct;
[gmp.dskRd,gmp.afCon]=deal(dskRd,afCon);
[gmp.atCon,gmp.atDis]=deal(atCon,atDis);
[gmp.mtTrq,gmp.mtFlc,gmp.mtFlcWth,gmp.mtFlcCut]=...
    deal(mtTrq,mtFlc,mtFlcWth,mtFlcCut);
[gmp.plPrd,gmp.plFlc]=deal(plPrd,plFlc);
gmp.dt=0.05;
gmp.plCnt=floor(gmp.plPrd/gmp.dt);

rng('shuffle');
            
%% Generate initial configuration of four disks
dis=(2/gmp.atCon-gmp.atDis)/(1/gmp.atCon-1)*gmp.dskRd;
height=sqrt(3)*dis/2;
sd=vb_hexagonVerticalArray(dis,height,40,10);
gmp.angTol=0.05;
gmp.nFa=size(sd,1);
sdOrn=ones(gmp.nFa,1)*pi/2;

%% Set initial motor torque values
sdMt=ones(gmp.nFa,1)*gmp.mtTrq;
mtCnt=zeros(gmp.nFa,1);
for fac=1:gmp.nFa
    mtCnt(fac)=floor((0.8*rand()+0.2)*gmp.plCnt);
    mtCnt(fac)=mtCnt(fac)-mod(mtCnt(fac),2);
end
hfCnt=floor(mtCnt/2);
% 
itMx=gmp.plCnt*300;
tmSt=gmp.plCnt*5;
dmx=itMx/tmSt+1;
% 
sdDt=cell(dmx,1);
sdDt{1}=[sd,sdOrn,sdMt];
dtc=2;

%% Check cell ids of left half of the entire cluster
xPosMx=max(sd(:,1));
lfCellId=find(sd(:,1)<xPosMx/2);

for tmc=1:itMx
    [sd,sdOrn]=vb_iteration(sd,sdOrn,sdMt,gmp);
    sdOrn=vb_globalOrientation(sdOrn,pi/2,pi/4,gmp);
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
        sdMt(lfCellId)=gmp.mtTrq;
    end

    if any(mtCnt==hfCnt) && gmp.mtFlc~=0
        fId=find(mtCnt==hfCnt);
        for fac=1:numel(fId)
            sdMt(fId(fac))=gmp.mtTrq+(gmp.mtTrq-sdMt(fId(fac))); 
        end
        sdMt(lfCellId)=gmp.mtTrq;
    end

    if mod(tmc,tmSt)==0
        sdDt{dtc}=[sd,sdOrn,sdMt];
        dtc=dtc+1;
    end
end

vb_plot(sd,sdOrn,gmp);
