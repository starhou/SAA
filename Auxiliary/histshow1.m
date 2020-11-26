function histshow1(sh)
%% 用直方图显示数据
%input
%     x  离散数组
%output
%     无
% Author: Starhou
% E-mail: 1029588176@qq.com
% Date:   2019.10.28
[N,edges] = histcounts(sh);
NumText = cell(size(N));
for i=1:size(N,2)
    NumText{i} = num2str(N(i)) ;
end
seg = edges(2)-edges(1);
x = edges(1:end-1)+0.2*seg;
y = N+5;


set(gcf,'unit','centimeters','position',[10 5 30 20]);
h1 = histogram(sh,edges);
% text(x,y,NumText,'FontSize',16,'Color','b')
end