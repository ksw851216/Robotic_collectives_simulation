function [sdN,sdOrnN]=vb_iteration(sd,sdOrn,sdMt,gmp)

%% compute distance between seeds and identify neighbor relation
[fnId,fnAtId,dsMat]=vb_findContact(sd,gmp);

%% compute normal force
nmFrc=vb_normalForce(sd,gmp,dsMat,fnId,fnAtId);

%% Compute tangent force
[tgFrc,agMmt]=vb_tangentForce(sd,sdOrn,sdMt,gmp,fnId);

%% Update seed position and orientation
sdN=sd+(nmFrc+tgFrc)*gmp.dt*gmp.dskRd;
sdOrnN=sdOrn+1/gmp.afCon*agMmt*gmp.dt;
sdOrnN=mod(sdOrnN,2*pi);

end