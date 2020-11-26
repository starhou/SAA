function Feat = calculate_feat(ECG,fs,wL,verbose)
% 计算特征
% INPUT:
% - xf: ecg signal (preprocessed)
% - fs: sampling frequency
% - wL: window length, in seconds 
% - verbose: debugging variable (1: plot; 0: default, not ploting)
%
% OUTPUT:
% - 无
% Author: Star Hou
% Date: 2019.9.24
% Good version
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% modify x4 添加归一化    2019.12.29
% modify shadow  2020.10.18 
% 提取特征
parfor i=1:size(ECG,1)

    xf = ECG(i,:);
    xf = MinMaxScaler(xf);
%     Rhythm = caculate_Rhythm(xf,fs,wL,verbose);
    % 2个原始信号是与特征
    time_source = calculate_source(xf,fs,wL,verbose);
    % 2个斜率特征
    time_slope = calculate_slope(xf,fs,wL,verbose);
    % 2个复杂度特征
    Complexdomin = calculate_Complexdomin(xf,fs,wL,verbose);
    % 4个频域特征
    freqdomin = calculate_freqdomin(xf,fs,wL,verbose);
    Feat(i,:) = [time_source time_slope Complexdomin freqdomin];
end
end


%% 计算复杂域特征
function Complexdomin = calculate_Complexdomin(xf,fs,wL,verbose)
% psr,  hilb，SamEn    SamEn 好
SamEn = calculate_SampEn(xf);
[psr,hilb] = calculate_PSR_HILB(xf,fs);
% fuzzyen = calculate_FuzzyEntropy(1, 0.2, xf);
Complexdomin = [hilb,SamEn];
end
%% 计算频域域特征
function freqdomin = calculate_freqdomin(xf,fs,wL,verbose)
% x3,x4,x5,vfleak
[x3,x4,x5] = calculate_Xi(xf,fs,wL,verbose);
vfleak = calculate_VFLEAK(xf);
freqdomin = [x4,vfleak]; 
end
%% 计算来自斜率信号的时域特征
function time_slope = calculate_slope(xf,fs,wL,verbose)
% slope_stdhist,movecount
xf = GradientSignal(xf);
xf = MinMaxScaler(xf);
%% slope类
fours = wL-4+1; % 四秒段的个数

slope_std = zeros(fours,1);
for i=1:fours
    fourecg = xf((i-1)*fs+1:(i-1)*fs+4*fs);
    slope_std(i) = calculate_shadow(fourecg,4,fs,verbose,10);
end
slope_std = min(slope_std);
%% movecount
len = 2*fs;
N = wL-2+1;
movecount = zeros(N,1);

for i=1:N
    ecg = xf((i-1)*fs+1:(i-1)*fs+len);
    movecount(i) = length(ecg(ecg<max(ecg)/40))/(wL*fs);


end
movecount = min(movecount);
if verbose
figure
set(gcf,'unit','centimeters','position',[10 5 30 20]);
plot(xf)
hold on
plot(max(ecg)/40*ones(size(xf)),'LineWidth',1)
title(['movecount是' num2str(movecount)],'FontSize',15)
hold off
keyboard;
close all
end
%% slopefeat
time_slope = [slope_std,movecount];
end
%% 计算来自原始信号的8时域特征
function time_source = calculate_source(xf,fs,wL,verbose)
% 计算来自原始信号的6个特征
% 'shadow_stdhist','expmod'
%% shadow类
fours = wL-4+1; % 四秒段的个数
shadow_std = zeros(fours,1);
for i=1:fours
    fourecg = xf((i-1)*fs+1:(i-1)*fs+4*fs);
    shadow_std(i) = calculate_shadow(fourecg,4,fs,verbose,10);
end
shadow_std = min(shadow_std);
%% expmod
tau = 1; % 曲线弯曲度
[pks,locs] = findpeaks(xf,'minpeakdistance',0.12*fs,'minpeakheight',0.2);
%第i个峰值
Es = [];
for i = 1:length(pks)
    peak1st = pks(i);
    if i ==1
        n = 1:locs(i);
    else
        n = locs(i-1)+1:locs(i);
    end
    es = peak1st.*exp(-abs(locs(i)-n)./(tau*fs));
    Es = [Es es];
end
% Intersections
a = Es-xf(1:length(Es));
b = circshift(a,1);
c = a.*b;
d = length(find(c<0));
exomod = d;
if verbose
figure
plot(xf)
hold on 
plot(locs,pks,'ro')
plot(Es)
hold off
title(['exp是' num2str(exomod)],'FontSize',18);
keyboard;
close all
end
%%
time_source = [shadow_std,exomod];
end
%% 辅助函数
%% 找到可靠的R波峰值
function [pks,locs] = peakfind(xf,verbose)
fs = 250;
wL = 8;
ecg = xf;
xf = GradientSignal(xf);

[pks,locs] = findpeaks(xf,'minpeakdistance',0.20*fs,'minpeakheight',0.2*max(xf));

% 若波峰只有一个，则去除该波峰左右0.2s数据，重新检测波峰
if length(pks)==1
    patience = 0.4*fs;
    if locs<patience
        left = 1;
    else
        left = locs-100;
    end
    if (wL*fs-locs)<patience
        right = wL*fs;
    else
        right = locs+100;
    end
    xf(left:right)=[];
[pks,locs] = findpeaks(xf,'minpeakdistance',0.20*fs,'minpeakheight',0.2*max(xf));
end
if verbose
figure
subplot(211)
plot(ecg)
subplot(212)
plot(xf)
hold on 
plot(locs,pks,'ro')
hold off
keyboard
close all
end
end
%% 计算shadow类特征
function shadow_std = calculate_shadow(xf,wL,fs,verbose,barwidth)
% 计算shadow类特征
% barwidth = 200;
barnum = floor(wL*fs/barwidth); % 栅条数目
bar = reshape(xf,[],barnum);
shadow = max(bar)-min(bar);
shadow_std = std(shadow)/(sum(shadow));


if verbose
    
    f = figure;
    set(gcf,'unit','centimeters','position',[10 5 30 20]);
    subplot(211)
    t = linspace(0,wL,wL*fs);
    plot(t,xf,'r');
    legend('Filtered Signal')
    xlabel('Times/s');
    ylabel('Voltage/mv');
    
    subplot(212)
    t = linspace(0,wL,barnum);
    h = stem(shadow); 
    h.XData = t;
    legend('Shadow')
    xlabel('Times/s');
    ylabel('Voltage/mv');
    title(['slopestd为' num2str(shadow_std)],'FontSize',18)
    
%     subplot(313)
%     bar(shadow_std);
%     legend('shadow_std')
%     xlabel('Histnum');
%     ylabel('Frequency');
    keyboard;
    close all

end
end
%% 把信号归一化为0到1之间
function ecg = MinMaxScaler(ecg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% input 
%          ecg 未归一化的数据
% output
%          ecg 归一化的数据
% example: ecg = MinMaxScaler(ecg)
% auther:  star hou 
% email:   1029588176@qq.com
% refer to sklearn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = ecg;
up = 1;
down = 0;
% method 1
X_std = (X-min(X))/(max(X)-min(X));
X_scaled = X_std * (up - down) + down;

% method 2
scale = (up - down) / (max(X) - min(X));
X_scaled2 = scale * X + down - min(X) * scale;

ecg = X_scaled;

end
%% 求梯度
function gradient = GradientSignal(x)

% 求信号梯度
% 
% input   x     信号段 
% 
% output  gradient  原信号的梯度
% 
% example:
% gradient = GradientSignal(x)
% 
% author：star hou  2019.8.20
% email: 1029588176@qq.com
x = [x,x(end)]; 
peak = diff(x);
gradient = peak.^2;
end
function y = calenth(s)
%% 求信号长度
s = diff(s); % n-1
s = s.^2;
b = 1/250*ones(size(s));
b = b.^2;
y = sum(sqrt(s+b));
end