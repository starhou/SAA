function datafigure(data,ProperIndex,ErrIndex,lable,X)
%%% 把错误数据可视化
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 找到特定决策区域的数据下标
% INPUT:
% - data:          数据
% - ProperIndex:   某区域所有信号下标
% - ErrIndex:      其中判别错误的标签
% - lable:         图像的标签，真正的
% - X:             该段信号的特征值，用作显示
% OUTPUT:
% - 无
% Author: Star Hou
% Date: 2019.10.1
Num = size(data,1);
plot_save_fig(data,Num,ErrIndex,ErrIndex,lable,X)
end
function plot_save_fig(data,Num,err,Index,lable,X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 找到特定决策区域的数据下标
% INPUT:
% - data:          数据
% - Num:           数据数量
% - err:           分类错误数据下标
% - Index:         某区域信号下标
% - lable:         错误数据的类型{Shockable,NonShockable}
% - X:             该段信号的特征值，用作显示
% OUTPUT:
% - 无
% Author: Star Hou
% Date: 2019.10.1

addpath('./Supplementary feature')
featname = {'a','b','c','d','e','f','g','h','i'};
OnefigNum = 6;
%%% 子图数量
SubNum = floor(Num/OnefigNum);
%%% 最后一张子图图片数量
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
                name = strcat('错误');
                text(2000 ,0 ,name,'FontSize',14)
                
            else
                name = strcat('正确');
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