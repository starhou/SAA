function datafigure(data,ProperIndex,ErrIndex,lable,X)
%%% �Ѵ������ݿ��ӻ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ҵ��ض���������������±�
% INPUT:
% - data:          ����
% - ProperIndex:   ĳ���������ź��±�
% - ErrIndex:      �����б����ı�ǩ
% - lable:         ͼ��ı�ǩ��������
% - X:             �ö��źŵ�����ֵ��������ʾ
% OUTPUT:
% - ��
% Author: Star Hou
% Date: 2019.10.1
Num = size(data,1);
plot_save_fig(data,Num,ErrIndex,ErrIndex,lable,X)
end
function plot_save_fig(data,Num,err,Index,lable,X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ҵ��ض���������������±�
% INPUT:
% - data:          ����
% - Num:           ��������
% - err:           ������������±�
% - Index:         ĳ�����ź��±�
% - lable:         �������ݵ�����{Shockable,NonShockable}
% - X:             �ö��źŵ�����ֵ��������ʾ
% OUTPUT:
% - ��
% Author: Star Hou
% Date: 2019.10.1

addpath('./Supplementary feature')
featname = {'a','b','c','d','e','f','g','h','i'};
OnefigNum = 6;
%%% ��ͼ����
SubNum = floor(Num/OnefigNum);
%%% ���һ����ͼͼƬ����
EndfigNum = mod(Num,6);
for i=1:SubNum+1
    if i<= SubNum
        figNum = OnefigNum;
    else
        figNum = EndfigNum;
    end
        figure(i)
        set(gcf,'unit','centimeters','position',[10 5 30 20]);
        for j = 1:figNum
            subplot(figNum,1,j)
            plot(data(6*(i-1)+j,:))
            title(num2str(Index(6*(i-1)+j)));
            maxy = max(data(6*(i-1)+j,:));
            [pks,locs] = peakfind(data(6*(i-1)+j,:),0);
            if ismember(Index(6*(i-1)+j),err)
                name = strcat('����');
                text(2000 ,0 ,name,'FontSize',14)
                
            else
                name = strcat('��ȷ');
                text(2000,0,name,'FontSize',14)
            end
                feat = num2cell(X(Index(6*(i-1)+j),:));
                feat{end+1} = length(pks);
                str  = [featname;feat];
                str = sprintf(' %s=%0.2f ',str{:});
                text(1,maxy,str,'FontSize',12)
        end
        suptitle(lable)
        savepath = ['F:\WCD\Google\5_train and test\figure\' lable '\' num2str(i) '.png'];
        saveas(gcf, savepath);
%         keyboard;
end
close all;
end