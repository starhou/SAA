function [ECG,lable,train_test,ID, multiLable] = loading(database,wL)
%% 按病人划分
% 病人ID ohca 1-260, 'vfdb', 'cudb', 'ahadb'   261-327, mitdb 328-375
% input
%       database {ohca,public,all,mitdb}
%       length   数据长度
%       模式     'trainTest'：训练测试模式  'Total'：返回数据库全部数据
% output
% 'trainTest'
%       ECG          原始ECG数据   
%       lable        标签   
%       train_test   是否为训练集（弃用） 1 为训练集，0 测试集
%       ID           每个样本对应的病人ID
%       multiLable   详细多类标签
% Author: starhou
% E-mail:1029588176@qq.com
% Date: 2019.10.29
% rng('shuffle');
trainRate = 0.8;
if strcmp(database,'public')
    % 261-327
    patID = 261:328;           % All the ids for all the patients
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
    patID2 = 261:328;           % All the ids for all the patients    
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


ECGmid = [];
lablemid = [];
train_testmid = [];
IDmid = [];
multiLabelmid = [];
for nameid=1:length(name)
     path = ['..\data\segment\' name{nameid}];
%      path = (['..\data\table\' name]);
    load(path)
    train_test = zeros(size(ID));
    for i =1:size(trainRec,2)
        train_test(ID==trainRec(i))=1;
    end
    lable = BL;
    multiLable = ML;
    ECGmid = [ECGmid;ECG];
    lablemid = [lablemid;lable];
    train_testmid = [train_testmid ;train_test];
    IDmid = [IDmid;ID];
    multiLabelmid = [multiLabelmid; multiLable];
end
ECG = ECGmid;
lable = lablemid;
train_test = train_testmid;
ID = IDmid;
multiLable = multiLabelmid;
end