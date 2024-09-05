function [sdN,sdWtN,sdOrnN]=vb_iterationForceWeight(sd,sdOrn,sdMt,gmp,extFrc,sdWt)

%% compute distance between seeds and identify neighbor relation
[fnId,fnAtId,dsMat]=vb_findContact(sd,gmp);

%% compute normal force
nmFrc=vb_normalForce(sd,gmp,dsMat,fnId,fnAtId);
[nmFrcWt,nmFrcRct]=vb_normalForceWeight(sd,sdWt,gmp);

%% Compute tangent force
[tgFrc,agMmt]=vb_tangentForce(sd,sdOrn,sdMt,gmp,fnId);

%% Update seed position and orientation
sdN=sd+(nmFrc+tgFrc+nmFrcRct)*gmp.dt*gmp.dskRd;
sdWtN=sdWt+(nmFrcWt+extFrc)*gmp.dt*gmp.dskRd;
sdOrnN=sdOrn+1/gmp.afCon*agMmt*gmp.dt;
sdOrnN=mod(sdOrnN,2*pi);

end