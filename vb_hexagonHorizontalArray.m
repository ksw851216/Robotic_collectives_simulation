%% Create hexagonal array of initial configurations

function sd=vb_hexagonHorizontalArray(dis,height,hrNm,vtNm)

sd=cell(vtNm,1);

for vtc=1:vtNm
    if mod(vtc,2)==1
        sd{vtc}=[((1:hrNm).'-1)*dis,ones(hrNm,1)*height*(vtc-1)];
    else
        sd{vtc}=[((1:hrNm).'-1/2)*dis,ones(hrNm,1)*height*(vtc-1)];
    end
end

sd=cell2mat(sd);

end