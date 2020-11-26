function segment_signal
%% 把按照标签信号分段
clc,clear all, close all;
%% Preset
% path
path_ddbb = '..\data\source\';  % 源信号路径
path_res  = '..\data\segment\'; % 保存路径

% source database
db_names = {'cudb','vfdb','ahadb','ohca','mitdb'};
w_length = [8];                      % option{4,8}  
sliding = 0;                            % option{1,0} 
step = [1];                               % option{1,2} 

for k = 1:length(step)
    for i = 1:length(db_names)
        for j = 1:length(w_length)

            r_filename  = sprintf('%s%s_%d', path_res , db_names{i} ,...
                                             w_length(j));
            db_filename = sprintf('%s%s'   , path_ddbb, db_names{i});
            segment_ecg(db_filename, w_length(j), sliding,step(k),...
                                                         r_filename);
        end
    end
end 
end
%%
function segment_ecg(db_filename,wlength,...
                         sliding,step,r_filename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 按每个数据库的信号为单位进行分段并保存
% input 
%          db_filename 源信号路径 
%          wlength     分段的长度
%          sliding     分段是否重叠
%          step        重叠时间 单位（S）
%          r_filename  保存的路径
% output
%          无 ， 在该函数下保存 
% segment_ecg(db_filename,wlength,...
%                         sliding,step,r_filename)
% auther:  star hou 
% email:   1029588176@qq.com
% refer:   Figuera, C., et al., Machine Learning Techniques for the 
%          Detection of Shockable Rhythms in Automated External 
%          Defibrillators. PLOS ONE, 2016. 11(7): p. e0159654.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 加载数据
load(db_filename);
[~, db_name, ~] = fileparts(db_filename);
% eval(sprintf('database=%s',db_name));
eval(['data = ' db_name ';']);
% 根据预设计算和初始化相关参数
% number of database records
L = length(data); 
fs = data.fs;
% variables definition and initialization
wsamples = wlength*fs;
if sliding
    stepsamples = step*fs;
else
    stepsamples = 1;
end
         
ECG = [];
BL = [];
ID = [];
ML = [];
% 按病人为单位对信号进行分段
disp('Processing database...')
% patID = [database.patID];
patID = [data.patID];
for n=1:L
    
        disp(data(n).name) 
        ecg_signal = data(n).ecg(:,1);
        ecg_labels = data(n).label; 
        % 获取段数
        if sliding
            Nw = floor((length(ecg_signal)-wsamples)/stepsamples);
        else
            Nw = floor(length(ecg_signal)/wsamples); % number of windows
        end
        
        if Nw > 0 
            
            [ecg_w,bl, ml] = seg_per_signal(ecg_signal,...
                ecg_labels,Nw,wsamples,stepsamples,sliding);
            id = patID(n)*ones(size(ecg_w,1),1);
            ECG = [ECG; ecg_w];                        
            BL = [BL;bl];
            ML = [ML;ml];
            ID = [ID;id];
        end        
end
package = [ECG BL ML ID];
% 保存
if nargin >= 3
    if sliding
    save(r_filename, 'ECG','BL','ID','ML');
%     writeNPY(package, [db_name '_' int2str(wlength) '.npy']);
    else
    save(r_filename, 'ECG','BL','ID','ML'); 
%     writeNPY(package, [db_name '_' int2str(wlength) '.npy']);
    end
end
end
%%
function [ECG,BL,ML] = seg_per_signal(ecg_signal,...
         ecg_labels,Nw,wsamples,stepsamples,sliding)     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 按每个病人的信号为单位进行分段
% input 
%          ecg_signal 每个病人的信号 例：cu01
%          ecg_labels 对应的标签
%          Nw         总共的段数
%          wsamples   所分段长L的再该采样率下的采样点数
% 若sliding
%          stepsamples 重叠信号长度
%          sliding     分段是否重叠
% output
%          ECG       分段后的数据 1*L 矩阵形式返回
%          BL        对应段的标签 1*1
% example: [ECG,BL] = seg_per_signal(ecg_signal,...
%         ecg_labels,Nw,wsamples,stepsamples,sliding)
% auther:  star hou 
% email:   1029588176@qq.com
% refer:   Figuera, C., et al., Machine Learning Techniques for the 
%          Detection of Shockable Rhythms in Automated External 
%          Defibrillators. PLOS ONE, 2016. 11(7): p. e0159654.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
k = 1;
ECG = [];
BL = [];
ML = [];
for j=1:Nw
    if sliding
        window = ((j-1)*stepsamples+1):((j-1)*stepsamples+wsamples);
    else
        window = (j-1)*wsamples+1:j*wsamples;
    end    
    ecg_in_window = ecg_signal(window); 
    labels_in_window = ecg_labels(window); 
    [out,binarylable,multilabel] = not_mixed_rhythms(labels_in_window);
 
    if out
        % 对信号进行归一化
        ECG(k,:) = ecg_in_window;
        BL(k,:) = binarylable;
        ML(k,:) = multilabel;
        % Uecg_in_windowpdated counter
        k = k + 1;
    end
end
end
%% 辅助函数
%%
function [output,unique_labels, unique_multiybels] = not_mixed_rhythms(labels)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 根据标签判断信号是否可用
% input 
%          labels 标签
% output
%          output 布尔值 若为真，信号可用
%          unique_labels  一段信号中类别 {1，-1}
% example: [output,unique_labels] = not_mixed_rhythms(labels)
% auther:  star hou 
% email:   1029588176@qq.com
% refer:   Figuera, C., et al., Machine Learning Techniques for the 
%          Detection of Shockable Rhythms in Automated External 
%          Defibrillators. PLOS ONE, 2016. 11(7): p. e0159654.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[blabels,multiybels] = binary_labels(labels,-1);  % {+1 Shock, -1 NShock}.
unique_labels = unique(blabels);
unique_multiybels  = unique(multiybels);

if ( length(unique_labels) == 1 && length(unique_multiybels) == 1)...
        && ( sum(ismember(labels,4))== 0 ) ...
        && ( sum(ismember(labels,12))== 0 ) ...
        && ( sum(ismember(labels,22))== 0 ) ...
        && ( sum(ismember(labels,24))== 0 )
    output = true;
else
    output = false;
%     msg = sprintf('Window %d discarded, samples: (%d,%d)',...
%        j,window(1),window(end));
%     disp(msg);
end

end

%%
function [y, multiy] = binary_labels(labels,value)
%% 把标签二值化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shock (labels 19 20 21 25 26) vs NonShock rhythms
% input 
%       labels  原始标签
%       value   nshock 标签数字
% output 
%       y  二值化的标签
%       yy 多值化标签 sh-vt
% example:  y = binary_labels(labels,value)
% auther:  star hou 
% email:   1029588176@qq.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
shock  = find( labels == 19 | labels == 20 | labels == 21 | labels == 25| labels == 26);% public
nshock = setdiff(1:length(labels),shock);
y = value*ones(size(labels));
y(shock) = 1;
% multi-label { 0   Sh-VF, 1 Sh-VT, 2  N, 3 others}
ShVF = labels == 19 | labels == 20 | labels == 25;
ShVT = labels == 21 | labels == 26;
N = labels == 10 | labels == 27;
multiy = 3*ones(size(labels));
multiy(ShVF) = 0;
multiy(ShVT) = 1;
multiy(N) = 2;
end

%%
function ecg = MinMaxScaler(ecg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 把信号归一化为正负1之间
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
down = -1;
% method 1
X_std = (X-min(X))/(max(X)-min(X));
X_scaled = X_std * (up - down) + down;

% method 2
scale = (up - down) / (max(X) - min(X));
X_scaled2 = scale * X + down - min(X) * scale;

ecg = X_scaled;

end
%%
function x = GradientSignal(x)
x = diff(x);
xdelay = circshift(x,1);
x = x.*xdelay;
x = [0;x(1:end-1);0];
end














