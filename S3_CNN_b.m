%卷积网络迁移学习 ------ 扩展数据训练被迁移模型，原始数据训练最终模型
clear all
addpath('C:\Program Files\MATLAB\R2018b\examples\nnet\main');


% S5_EXTEND;
S5_EXTEND_d;


% CNN_X=zeros(70,6,1,74);
% % CNN_X(:,:,1,:)=set_SameLength(maxfeature_X);
% CNN_X(:,:,1,:)=set_SameLength_1(maxfeature_X);

 
layers = [
    imageInputLayer([24 24 1],'Name','input')
    
    convolution2dLayer(3,8,'Padding','same','Stride',3,'Name','conv_1')
    batchNormalizationLayer('Name','BN_1')
    reluLayer('Name','relu_1')
    
%     maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same','Name','conv_2')
    batchNormalizationLayer('Name','BN_2')
    reluLayer('Name','relu_2')
    
    maxPooling2dLayer(2,'Stride',2,'Name','maxpool_1')
    
    convolution2dLayer(3,32,'Padding','same','Name','conv_3')
    batchNormalizationLayer('Name','BN_3')
    reluLayer('Name','relu_3')
    
    fullyConnectedLayer(3,'Name','fl_1')
    softmaxLayer('Name','sof_1')
    classificationLayer('Name','output')];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',8, ...
    'Shuffle','every-epoch', ...
     'ValidationData',{CNN_X_ROTA_NOISE(:,:,1,valiset_index),categorical(label_ROTA_NOISE(valiset_index))'},...
    'ValidationFrequency',1, ...
    'MiniBatchSize',128, ...
    'Verbose',false, ...
    'Plots','training-progress');
% options = trainingOptions('sgdm', ...
%     'LearnRateSchedule','piecewise', ...
%     'LearnRateDropFactor',0.2, ...
%     'LearnRateDropPeriod',5, ...
%     'MaxEpochs',20, ...
%     'MiniBatchSize',353, ...
%     'Plots','training-progress');
% transfer_net = trainNetwork(googlenet_X(:,:,:,trainset_index),categorical(label(trainset_index)),lgraph,options);
% YPred = classify(transfer_net,googlenet_X(:,:,:,valiset_index));
net = trainNetwork(CNN_X_ROTA_NOISE(:,:,1,trainset_index),categorical(label_ROTA_NOISE(trainset_index)),layerGraph(layers),options);
% YPred = classify(net,CNN_X_b);
% 
% accuracy = sum(YPred == categorical(label_b)')/numel(YPred);

%   net_g = googlenet;
lgraph = layerGraph(net);
 analyzeNetwork(transfer_net);
newLearnableLayer = fullyConnectedLayer(3, ...
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
lgraph = replaceLayer(lgraph,'fl_1',newLearnableLayer);   
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'output',newClassLayer);    

layers = lgraph.Layers;
connections = lgraph.Connections;
layers(1:11) = freezeWeights(layers(1:11));%
lgraph = createLgraphUsingConnections(layers,connections);%

trf_CNN_X=sq_extend_CNN_X{1};
[trainset_index_trf,valiset_index_trf]=get_trainset_valiset_index(label_ROTA_NOISE(1:74));%划分训练集和验证集索引

options_trf = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',8, ...
    'Shuffle','every-epoch', ...
     'ValidationData',{trf_CNN_X(:,:,1,valiset_index_trf),categorical(label_ROTA_NOISE(valiset_index_trf))'},...
    'ValidationFrequency',1, ...
    'MiniBatchSize',8, ...
    'Verbose',false, ...
    'Plots','training-progress');



transfer_net = trainNetwork(trf_CNN_X(:,:,:,trainset_index_trf),categorical(label_ROTA_NOISE(trainset_index_trf)),lgraph,options_trf);



