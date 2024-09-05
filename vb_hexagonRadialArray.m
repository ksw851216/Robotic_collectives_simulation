%% Create hexagonal array of initial configurations

function sd=vb_hexagonRadialArray(dis,height,rdNm)

sd=cell(rdNm,1);

for rdc=1:rdNm-1
    sd{rdc}=[(((1:(rdNm+(rdc-1))).')-(rdNm+rdc)/2)*dis,...
        ones(rdNm+(rdc-1),1)*(rdNm-rdc)*height;
        (((1:(rdNm+(rdc-1))).')-(rdNm+rdc)/2)*dis,...
        -ones(rdNm+(rdc-1),1)*(rdNm-rdc)*height];
end
sd{rdNm}=[(((1:(2*rdNm-1)).')-rdNm)*dis,ones(2*rdNm-1,1)*0*height];

sd=cell2mat(sd);

end