function [sp,se,ppv,acc,bac]=acc_binary(yr,yp)
%% 展示最后结果
a = confusionmat(yr,yp);
sp = 1-a(1,2)/(a(1,2)+a(1,1));
se = 1-a(2,1)/(a(2,1)+a(2,2));
ppv = 1-a(1,2)/(a(1,2)+a(2,2));
acc = 1-(a(1,2)+a(2,1))/sum(sum(a));
bac = 0.5*(sp+se);
end