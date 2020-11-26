%% 显示错误数据
function show_mis(ErrNshIndex,lable,X)
load('F:\WCD\Google\CUT FILES\cut_ohca_8sec')
ECG = ones(length(data),2000);
for i=1:length(data)
    ECG(i,:) = data(i).s_ecg;
end
if lable==1
    name = 'Shockable';
else
    name = 'NonShockable';
end
regular = X(ErrNshIndex,6);

for i=1:length(ErrNshIndex)
    figure
    set(gcf,'unit','centimeters','position',[10 5 30 20]);
    ecg = ECG(ErrNshIndex(i),:);
    subplot(2,1,i)
    plot(ecg)
    ecg = GradientSignal(ecg);
    subplot(212)
    plot(ecg.^2)
    title(['没有被区分' name '-' num2str(regular(i))],'FontSize',18)
    keyboard
    close all
end
end