function [sdN,sdOrnN]=vb_iterationForce(sd,sdOrn,sdMt,gmp,extFrc)

%% compute distance between seeds and identify neighbor relation
[fnId,fnAtId,dsMat]=vb_findContact(sd,gmp);

%% compute normal force
nmFrc=vb_normalForce(sd,gmp,dsMat,fnId,fnAtId);

%% Compute tangent force
[tgFrc,agMmt]=vb_tangentForce(sd,sdOrn,sdMt,gmp,fnId);

%% Update seed position and orientation
sdN=sd+(nmFrc+tgFrc+extFrc)*gmp.dt*gmp.dskRd;
sdOrnN=sdOrn+1/gmp.afCon*agMmt*gmp.dt;
sdOrnN=mod(sdOrnN,2*pi);

end