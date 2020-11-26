function segment_signal
%% �Ѱ��ձ�ǩ�źŷֶ�
clc,clear all, close all;
%% Preset
% path
path_ddbb = '..\data\source\';  % Դ�ź�·��
path_res  = '..\data\segment\'; % ����·��

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
%% ��ÿ�����ݿ���ź�Ϊ��λ���зֶβ�����
% input 
%          db_filename Դ�ź�·�� 
%          wlength     �ֶεĳ���
%          sliding     �ֶ��Ƿ��ص�
%          step        �ص�ʱ�� ��λ��S��
%          r_filename  �����·��
% output
%          �� �� �ڸú����±��� 
% segment_ecg(db_filename,wlength,...
%                         sliding,step,r_filename)
% auther:  star hou 
% email:   1029588176@qq.com
% refer:   Figuera, C., et al., Machine Learning Techniques for the 
%          Detection of Shockable Rhythms in Automated External 
%          Defibrillators. PLOS ONE, 2016. 11(7): p. e0159654.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��������
load(db_filename);
[~, db_name, ~] = fileparts(db_filename);
% eval(sprintf('database=%s',db_name));
eval(['data = ' db_name ';']);
% ����Ԥ�����ͳ�ʼ����ز���
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
% ������Ϊ��λ���źŽ��зֶ�
disp('Processing database...')
% patID = [database.patID];
patID = [data.patID];
for n=1:L
    
        disp(data(n).name) 
        ecg_signal = data(n).ecg(:,1);
        ecg_labels = data(n).label; 
        % ��ȡ����
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
% ����
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
%% ��ÿ�����˵��ź�Ϊ��λ���зֶ�
% input 
%          ecg_signal ÿ�����˵��ź� ����cu01
%          ecg_labels ��Ӧ�ı�ǩ
%          Nw         �ܹ��Ķ���
%          wsamples   ���ֶγ�L���ٸò������µĲ�������
% ��sliding
%          stepsamples �ص��źų���
%          sliding     �ֶ��Ƿ��ص�
% output
%          ECG       �ֶκ������ 1*L ������ʽ����
%          BL        ��Ӧ�εı�ǩ 1*1
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
        % ���źŽ��й�һ��
        ECG(k,:) = ecg_in_window;
        BL(k,:) = binarylable;
        ML(k,:) = multilabel;
        % Uecg_in_windowpdated counter
        k = k + 1;
    end
end
end
%% ��������
%%
function [output,unique_labels, unique_multiybels] = not_mixed_rhythms(labels)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���ݱ�ǩ�ж��ź��Ƿ����
% input 
%          labels ��ǩ
% output
%          output ����ֵ ��Ϊ�棬�źſ���
%          unique_labels  һ���ź������ {1��-1}
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
%% �ѱ�ǩ��ֵ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shock (labels 19 20 21 25 26) vs NonShock rhythms
% input 
%       labels  ԭʼ��ǩ
%       value   nshock ��ǩ����
% output 
%       y  ��ֵ���ı�ǩ
%       yy ��ֵ����ǩ sh-vt
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
%% ���źŹ�һ��Ϊ����1֮��
% input 
%          ecg δ��һ��������
% output
%          ecg ��һ��������
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














