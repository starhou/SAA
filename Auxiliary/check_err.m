%% 返回错误数据下标
function [ErrIndex,RightIndex] = check_err(X,y,predict,down,up,lable,save)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 找到特定决策区域的数据下标
% INPUT:
% - X:         特征值
% - y:         right lable
% - predict:   decision score
% - down:      a of boundary [a,b]
% - up:        b of boundary [a,b]
% - lable      the true label of err data [Shockable,NonShockable]
% - save       [yes,no]是否把数据保存为图片
% OUTPUT:
% - ErrIndex   错误信号下标
% - RightIndex 正确信号下标
% Author: Star Hou
% Date: 2019.10.1
Index = 1:length(y);

if strcmp('Shockable',lable)
    lab = 1;
end
if strcmp('NonShockable',lable)
    lab = -1;
end

% 某类信号所有下标
NshIndex = find(y==lab);
% 决策在[down:up]之间的所有下标
ProperIndex = Index(predict>=down & predict<=up);

% 错误的某类信号下标
ErrIndex = intersect(NshIndex,ProperIndex);

% 正确另一类信号下标
RightIndex = setdiff(ProperIndex,ErrIndex);
if strcmp('yes',save)
    load('F:\WCD\Google\CUT FILES\cut_pub_8sec')
    ECG = ones(length(data),2000);
    for i=1:length(data)
        ECG(i,:) = data(i).s_ecg;
    end
    data = ECG(ErrIndex,:);
    datafigure(data,ProperIndex,ErrIndex,lable,X)
end
end