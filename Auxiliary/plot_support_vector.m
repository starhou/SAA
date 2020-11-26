function [sp,se,ppv,acc,bac,multiAcc,patient_id_acc,feature_importance] = plot_support_vector(model,testingData,testID,patID,featID,wL)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    f(x) = (x/s)'*beta+ b
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = table2array(model.X);
y = model.Y;
%% ѵ����չʾ
%%% �������
%%% ��׼��
% X = (X-model.Mu)./model.Sigma;
% s = model.KernelParameters.Scale;
% beta = model.Beta;
% bais = model.Bias;
% yp = (X/s)*beta+bais;

yp = predict(model,X);
%% ���ӻ�
% histshow(yp,y,0.2,2,4)
% title('Train Set Effect','FontSize',18)
%% ���Լ�չʾ
% [trainingData,testingData,tarinID,testID,patID] = load_feat('public',wL, 1);
data = testingData;
X = data.X;
y = data.y;
multiLable = data.multiLable;
ID = data.ID;

featID=[4];
featid =[featID]; 
X = X(:,featid);
%% �������
% %% ��׼��
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
%% ���ӻ�
% histshow(yp,y,0.2,20,15)
% title('Test Set Effect','FontSize',23)
end