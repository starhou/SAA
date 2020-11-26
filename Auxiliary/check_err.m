%% ���ش��������±�
function [ErrIndex,RightIndex] = check_err(X,y,predict,down,up,lable,save)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ҵ��ض���������������±�
% INPUT:
% - X:         ����ֵ
% - y:         right lable
% - predict:   decision score
% - down:      a of boundary [a,b]
% - up:        b of boundary [a,b]
% - lable      the true label of err data [Shockable,NonShockable]
% - save       [yes,no]�Ƿ�����ݱ���ΪͼƬ
% OUTPUT:
% - ErrIndex   �����ź��±�
% - RightIndex ��ȷ�ź��±�
% Author: Star Hou
% Date: 2019.10.1
Index = 1:length(y);

if strcmp('Shockable',lable)
    lab = 1;
end
if strcmp('NonShockable',lable)
    lab = -1;
end

% ĳ���ź������±�
NshIndex = find(y==lab);
% ������[down:up]֮��������±�
ProperIndex = Index(predict>=down & predict<=up);

% �����ĳ���ź��±�
ErrIndex = intersect(NshIndex,ProperIndex);

% ��ȷ��һ���ź��±�
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