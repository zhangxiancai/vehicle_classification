function RES=data_feature_extract_comp(X)
%数据集特征提取,先提取极大值后插值，底盘高度
%输入：原始数据cell(1,~),method=插值方法（字符串）
%输出：(max_height*6+2,samples_count)



max_height=16;
[~,samples_count]=size(X);

RES=zeros(samples_count,max_height*6+1);
MP_X=zeros(1,max_height*6);

for i=1:samples_count%
    [vehicle_length,~]=size(X{i});
    outline=zeros(vehicle_length,6);
    
    vehicle_height=get_vehicle_height(X{i});%车长
    for j=1:vehicle_length
    [~,comp_temp_2]=get_maxfeature_signal_new(X{i}(j,:));

    outline(j,:)=correction_method(comp_temp_2);%
      
    end
      resize_X=imresize(outline,[max_height,6],'bilinear');%后插值
    RES(i,:)=[reshape(resize_X,[1,max_height*6]),vehicle_height];
   
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

