%% Tune disk orientation for an assigned direction

function sdOrnN=vb_globalOrientation(sdOrn,ornMn,ornVar,gmp)

sdOrnN=sdOrn;

for fac=1:gmp.nFa
    err=min([abs(sdOrn(fac)-ornMn),...
        abs(sdOrn(fac)-(pi+ornMn)),...
        abs(sdOrn(fac)-(2*pi+ornMn))]);
    
    if err>ornVar/2
        sdOrnN(fac)=ornMn;
    end
end    


end