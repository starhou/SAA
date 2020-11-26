function [sp,se,ppv,acc,bac,multiAcc,patient_id_acc,feature_importance] = plot_support_vector(model,testingData,testID,patID,featID,wL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    f(x) = (x/s)'*beta+ b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = table2array(model.X);
y = model.Y;
%% 训练集展示
%%% 求出决策
%%% 标准化
% X = (X-model.Mu)./model.Sigma;
% s = model.KernelParameters.Scale;
% beta = model.Beta;
% bais = model.Bias;
% yp = (X/s)*beta+bais;

yp = predict(model,X);
%% 可视化
% histshow(yp,y,0.2,2,4)
% title('Train Set Effect','FontSize',18)
%% 测试集展示
% [trainingData,testingData,tarinID,testID,patID] = load_feat('public',wL, 1);
data = testingData;
X = data.X;
y = data.y;
multiLable = data.multiLable;
ID = data.ID;

featID=[4];
featid =[featID]; 
X = X(:,featid);
%% 求出决策
% %% 标准化
X = (X-model.Mu)./model.Sigma;
s = model.KernelParameters.Scale;
beta = model.Beta;
bais = model.Bias;
yp = (X/s)*beta+bais;
yp(yp>=0)=1;
yp(yp<0)=-1;
% [yp,scores] = predict(model,X);
yr = y;
[sp,se,ppv,acc,bac] = acc_binary(yr,yp);
multiAcc = acc_multi(yr, yp, multiLable);
patient_id_acc = 0; 
acc_patient_id(yr,yp, ID);
feature_importance = beta.^2;
%% 可视化
% histshow(yp,y,0.2,20,15)
% title('Test Set Effect','FontSize',23)
end