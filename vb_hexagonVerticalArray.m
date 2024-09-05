%% Create hexagonal array of initial configurations

function sd=vb_hexagonVerticalArray(dis,height,hrNm,vtNm)

sd=cell(hrNm,1);

for hrc=1:hrNm
    if mod(hrc,2)==1
        sd{hrc}=[ones(vtNm,1)*height*(hrc-1),(((1:vtNm)-1).')*dis];
    else
        sd{hrc}=[ones(vtNm,1)*height*(hrc-1),((((1:vtNm)-1/2).'))*dis];
    end
end

sd=cell2mat(sd);

end