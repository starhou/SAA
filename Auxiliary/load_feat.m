function [trainingData,testingData,tarinID,testID,patID] = load_feat(database,wL,trainRate)
%% 按病人划分训练集和测试集
% 病人ID  'ohca',  1-260, 
%         'vfdb',  261-282
%         'cudb',  283-317
%         'ahadb'  317-327, 
%         'mitdb'  328
% input
%       database      数据库      {ohca,public,all,mitdb}
%       wL            数据长度    {4,5,6,7,8}
%       trainRate     训练和测试比例   0=<x<=1
% output
% 'trainTest'
%       trainingData   训练数据  table(features, binary_lables, multi_lables, patientID)  
%       testingData    测试数据  table 同上  
%       tarinID        训练集病人ID
%       testID         测试集病人ID
%       patID          总共的病人ID
% Author: starhou
% E-mail:1029588176@qq.com
% Date: 2020.10.19
% rng('shuffle');
PATID = 328;

if strcmp(database,'public')
    % 261-327
    patID = 261:PATID;           % All the ids for all the patients
    nPats     = length(patID);
    trainRec  = patID(randperm(nPats, round(trainRate*nPats)));
    name{1} = ['vfdb_' num2str(wL)];
    name{2} = ['cudb_' num2str(wL)];
    name{3} = ['ahadb_' num2str(wL)];
    name{4} = ['mitdb_' num2str(wL)];
elseif strcmp(database,'ohca')
    patID = 1:260;           % All the ids for all the patients
    nPats     = length(patID);
    trainRec  = patID(randperm(nPats, round(trainRate*nPats)));
    name{1} = ['ohca_' num2str(wL)];
elseif strcmp(database,'mitdb')
    patID = 328;           % All the ids for all the patients
    nPats     = length(patID);
    trainRec  = patID(randperm(nPats, round(trainRate*nPats)));
    name{1} = ['mitdb_' num2str(wL)];
elseif strcmp(database,'vfdb')
    patID = 261:282;           % All the ids for all the patients
    nPats     = length(patID);
    trainRec  = patID(randperm(nPats, round(trainRate*nPats)));
    name{1} = ['vfdb_' num2str(wL)];
elseif strcmp(database,'cudb')
    patID = 283:317;           % All the ids for all the patients
    nPats     = length(patID);
    trainRec  = patID(randperm(nPats, round(trainRate*nPats)));
    name{1} = ['cudb_' num2str(wL)];
elseif strcmp(database,'ahadb')
    patID = 318:327;           % All the ids for all the patients
    nPats     = length(patID);
    trainRec  = patID(randperm(nPats, round(trainRate*nPats)));
    name{1} = ['ahadb_' num2str(wL)];
elseif strcmp(database,'all')
    patID1 = 1:260;
    patID2 = 261:PATID;           % All the ids for all the patients    
    nPats1     = length(patID1);
    nPats2     = length(patID2);
    trainRec1  = patID1(randperm(nPats1, round(trainRate*nPats1)));
    trainRec2  = patID2(randperm(nPats2, round(trainRate*nPats2)));
    trainRec = [trainRec1,trainRec2];
    name{1} = ['ohca_' num2str(wL)];
    name{2} = ['vfdb_' num2str(wL)];
    name{3} = ['cudb_' num2str(wL)];
    name{4} = ['ahadb_' num2str(wL)];
    name{5} = ['mitdb_' num2str(wL)];
end

patID = 1:PATID;
tarinID = trainRec; 
testID = setdiff(patID, tarinID);

hashmap = zeros(PATID,1);
hashmap(tarinID) = 1;

path = (['..\data\table\' name{1}]);
load(path)


train_sample_ID = [];
test_sample_ID =  [];
for i=1:size(data)
 if hashmap(data.ID(i)) == 1
    train_sample_ID = [train_sample_ID i];
 else
    test_sample_ID = [train_sample_ID i];
 end
end

trainingData = data(train_sample_ID,:);
testingData = data(test_sample_ID,:);
for nameid= 2:length(name)
     path = (['..\data\table\' name{nameid}]);
     load(path)
     train_sample_ID = [];
     test_sample_ID =  [];
     for i=1:size(data)
         if hashmap(data.ID(i)) == 1
            train_sample_ID = [train_sample_ID i];
         else
            test_sample_ID = [train_sample_ID i];
         end
     end
     
     trainingData = [trainingData; data(train_sample_ID,:)];
     testingData = [testingData; data(test_sample_ID,:)];
end
end