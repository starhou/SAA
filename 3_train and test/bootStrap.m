addpath('../Auxiliary/')
bootstap = 50;
se = zeros(bootstap,1);
sp = zeros(bootstap,1);
ppv = zeros(bootstap,1);
acc = zeros(bootstap,1);
bac = zeros(bootstap,1);
multiAcc = zeros(bootstap,4);
patient_id_acc = zeros(bootstap,1);
feature_importance = zeros(bootstap,8);
for j = 8:8   
    parfor i = 1:bootstap   
            [sp(i),se(i),ppv(i),acc(i),bac(i),multiAcc(i,:),patient_id_acc(i),...
                feature_importance(i,:)] = trainClassifier(j);
    end
save(['..\data\result\all_' num2str(j)],'se','sp','ppv','acc','bac',...
    'multiAcc','feature_importance','patient_id_acc')
% save(['F:\WCD\Google\data\accuracy\allvnew' num2str(j)],'se','sp','ppv','acc','bac','unsatisfield','tarinID','testID')
end

% figure
% subplot(1,2,1)
% histshow1(sp)
%     hold on
%     line([0.95,0.95],[0,140],'Color','r','LineWidth',2,'LineStyle','-.')
%     text(0.95,100,'AHA limit for SP','FontSize',23)
%     text(0.96,50,'Mean(std):99.09%(<0.01%)','FontSize',23)
%     xlabel('Specificity','FontSize',23)
%     ylabel('Frequency','FontSize',23)
%     hold off
%     subplot(1,2,2)
%     histshow1(se)
%     hold on
%     line([0.90,0.90],[0,110],'Color','r','LineWidth',2,'LineStyle','-.')
%     text(0.90,80,'AHA limit for SE','FontSize',23)
%     text(0.912,39,'Mean(std):97.41%(0.19%)','FontSize',23)
%     xlabel('Sensitivity','FontSize',23)
%     ylabel('Frequency','FontSize',23)
%     hold off

