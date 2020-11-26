function [sp,se,ppv,acc,bac,multiAcc,patient_id_acc,feature_importance] = trainClassifier(wL)
% [trainedClassifier, validationAccuracy] = trainClassifier(trainingData)
% returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: a table containing the same predictor and response
%       columns as imported into the app.
%
%  Output:
%      trainedClassifier: a struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier.predictFcn: a function to make predictions on new
%       data.
%
%      validationAccuracy: a double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier, validationAccuracy] = trainClassifier(T)
%
% To make predictions with the returned 'trainedClassifier' on new data T2,
% use
%   yfit = trainedClassifier.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier.HowToPredict

% Auto-generated by MATLAB on 2019-09-30 09:59:31


% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
%%%��������
addpath('../Auxiliary/')
wL = 8;
% [trainingData,testingData,tarinID,testID,patID] = loadata('ohca',num2str(wL),'trainTest');
% ����ѵ���Ͳ�������
[trainingData,testingData,~,testID,patID] = load_feat('all',wL,0.8);

inputTable = trainingData;
% Split matrices in the input table into vectors
inputTable.X_1 = inputTable.X(:,1);
inputTable.X_2 = inputTable.X(:,2);
inputTable.X_3 = inputTable.X(:,3);
inputTable.X_4 = inputTable.X(:,4);
inputTable.X_5 = inputTable.X(:,5);
inputTable.X_6 = inputTable.X(:,6);
inputTable.X_7 = inputTable.X(:,7);
inputTable.X_8 = inputTable.X(:,8);

%%%  �Լ�����
featID= [4];
featid = [featID];
usefeat = featid;
isCategoricalPredictor = [false, false, false, false, false, false, false, false];
isCategoricalPredictor(usefeat)=true;

predictorNames = {'X_1', 'X_2', 'X_3', 'X_4', 'X_5', 'X_6', 'X_7', 'X_8'};
predictors = inputTable(:, predictorNames);
response = inputTable.y;
% Data transformation: Select subset of the features
% This code selects the same subset of features as were used in the app.
includedPredictorNames = predictors.Properties.VariableNames(isCategoricalPredictor);
predictors = predictors(:,includedPredictorNames);
% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationSVM = fitcsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'linear', ...
    'PolynomialOrder', [], ...
    'KernelScale', 'auto', ...
    'BoxConstraint', 1, ...
    'Standardize', true, ...
    'ClassNames', [-1; 1],...
    'Solver','SMO',...
    'Cost',[0, 1; 1,0]);

%%% ��ʾ���
[sp,se,ppv,acc,bac,multiAcc,patient_id_acc,feature_importance] = plot_support_vector(classificationSVM,...
testingData,testID,patID,featID,wL);
% save('..\model\ohca_4', trainedClassifier.ClassificationSVM);
end