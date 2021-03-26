%扩展数据_b,另外18条数据

S5_EXTEND;

 X_b=cell(1,18);
for i=1:18
    X_b{i}=csvread(strcat('vehicle_data_b/',string(i-1),'.csv'));%载入18条数据
end

CNN_X_b=data_extend_b(X_b,'bicubic');%
label_b=ones(1,18);


ML_X_b=zeros(18,576);
for i=1:18
    ML_X_b(i,:)=reshape(CNN_X_b(:,:,1,i),[1,576]);%
end