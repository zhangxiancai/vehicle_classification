%卷积网络
clear all
close all
addpath('C:\Program Files\MATLAB\R2018b\examples\nnet\main');
% imds = imageDatastore('cnn_vehicle_data', ...
%     'IncludeSubfolders',true,'LabelSource','foldernames','FileExtensions','.csv');
% 
% numTrainFiles = 20;
% [imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

S5_EXTEND;
% S5_EXTEND_c;

[trainset_index,valiset_index]=get_trainset_valiset_index(label);%划分训练集和验证集索引
% CNN_X=zeros(70,6,1,74);
% % CNN_X(:,:,1,:)=set_SameLength(maxfeature_X);
% CNN_X(:,:,1,:)=set_SameLength_1(maxfeature_X);


% net = googlenet;
% lgraph = layerGraph(net);
% % analyzeNetwork(net);
% newLearnableLayer = fullyConnectedLayer(3, ...
%         'Name','new_fc', ...
%         'WeightLearnRateFactor',10, ...
%         'BiasLearnRateFactor',10);
% lgraph = replaceLayer(lgraph,'loss3-classifier',newLearnableLayer);   
% newClassLayer = classificationLayer('Name','new_classoutput');
% lgraph = replaceLayer(lgraph,'output',newClassLayer);    
% 
% layers = lgraph.Layers;
% connections = lgraph.Connections;
% layers(1:141) = freezeWeights(layers(1:141));%
% lgraph = createLgraphUsingConnections(layers,connections);
% 
% googlenet_X=zeros(224,224,3,74*6);
% for i=1:74*6
% googlenet_X(:,:,1,i)=imresize(CNN_X(:,:,1,i),[224 224]);
% googlenet_X(:,:,2,i)=googlenet_X(:,:,1,i);
% googlenet_X(:,:,3,i)=googlenet_X(:,:,1,i);
% end


 
layers = [
    imageInputLayer([24 24 1])
    
    convolution2dLayer(3,8,'Padding','same','Stride',1)
    batchNormalizationLayer
    reluLayer
    
%     maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    

    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',8, ...
    'Shuffle','every-epoch', ...
     'ValidationData',{CNN_X(:,:,1,valiset_index_a),categorical(label(valiset_index_a))'},...
    'ValidationFrequency',1, ...
    'MiniBatchSize',64, ...
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
net = trainNetwork(CNN_X(:,:,1,trainset_index_a),categorical(label(trainset_index_a)),layers,options);
analyzeNetwork(net);
% YPred = classify(net,CNN_X_b);
% 
% accuracy = sum(YPred == categorical(label_b)')/numel(YPred);





