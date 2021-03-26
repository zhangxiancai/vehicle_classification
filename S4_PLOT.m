%»­Í¼

S5_EXTEND;
model_index=find(label==2);%
class_size=[length((find(label==0))) length(find(label==1)) length(find(label==2))];
% figure
% for i=1:length(model_index)
%     subplot(1,length(model_index),i);
%     %     imshow(mat2gray(googlenet_X(:,:,1,model_index(i))));
% %     imshow(mat2gray(maxfeature_X{model_index(i)}));
% %     imshow(mat2gray(X{model_index(i)}));
% %     imshow(mat2gray(CNN_X(:,:,1, model_index(i))));
%     imshow(mat2gray(sq_extend_CNN_X(:,:,1, model_index(i))));
% end
% 
% 
% figure
% imshow(mat2gray(sq_extend_CNN_X(:,:,1, model_index(i))));
% figure
% imshow(imrotate(mat2gray(sq_extend_CNN_X(:,:,1, model_index(i))),80,'bilinear','loose'));



figure
for i=1:length(model_index)
        subplot(6,21,i);
        imshow(CNN_X(:,:,1,model_index(i)));
end