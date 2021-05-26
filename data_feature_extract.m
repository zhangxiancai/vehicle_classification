function RES=data_feature_extract(X)
%���ݼ�������ȡ,�Ȳ�ֵ����ȡ����ֵ�����̸߶�
%���룺ԭʼ����cell(1,~),method=��ֵ�������ַ�����
%�����(max_height*6+2,samples_count)

max_height=16;
[~,samples_count]=size(X);
wcre_num=2*3;
RES=zeros(samples_count,max_height*wcre_num+1);
MP_X=zeros(1,max_height*wcre_num);
for i=1:samples_count%
    [vehicle_length,~]=size(X{i});
    

    resize_X=imresize(X{i},[max_height,827],'bilinear');%�Ȳ�ֵ
    vehicle_height=get_vehicle_height(resize_X);%
    if i==50
        
    end
    for j=1:max_height
    [~,comp_temp_2]=get_maxfeature_signal_new(resize_X(j,:));
%     MP_X(8*j-7:8*j)=correction_method(comp_temp_2);%����
    MP_X(wcre_num*j-wcre_num+1:wcre_num*j)=correction_method(comp_temp_2);%����
    end
    RES(i,:)=[MP_X,vehicle_height];
   
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

