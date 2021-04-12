function RES=data_feature_extract(X)
%数据集特征提取,先插值后提取极大值,车长，底盘高度
%输入：原始数据cell(1,~),method=插值方法（字符串）
%输出：(max_height*6+2,samples_count)



max_height=96;
[~,samples_count]=size(X);
resize_X=zeros(max_height,827);
RES=zeros(samples_count,max_height*6+2);
MP_X=zeros(1,max_height*6);
for i=1:samples_count%
    [vehicle_length,~]=size(X{i});
    
    vehicle_height=get_vehicle_height(X{i});
    resize_X=imresize(X{i},[max_height,827],'bicubic');%先插值
    if i==50
        
    end
    for j=1:max_height
    MP_X(6*j-5:6*j)=correction_method1(get_maxfeature_signal(resize_X(j,:)));
    end
    RES(i,:)=[MP_X,vehicle_height,vehicle_length];
   
end





end

function vehicle_height=get_vehicle_height(X)
%input: one vehicle sample, ~*827
%output: height of vehicle chassis
[n,~]=size(X);
hs=zeros(1,n);
for i=1:n
comp_temp_2=(get_maxfeature_signal(X(i,:)));
[~,I]=max(comp_temp_2(:,2));
hs(i)=comp_temp_2(I,1);
end
vehicle_height=mean(hs);

end

