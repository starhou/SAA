function histshow(feat,y,labelx,labley1,labley2)
% 绘制单特征的频数直方图
% 显示单特征效果
% INPUT:
% - feat:     one feature
% - y:        right lable
% - labelx:   text lable'x
% - labley1:  Shockable text lable'y
% - labley2:  NonShockable text lable'y
% OUTPUT:
% - 无
% Author: Star Hou
% Date: 2019.9.30
shadow_std = feat;
sh = shadow_std(y==1);
nsh = shadow_std(y==-1);
[N,edges] = histcounts(shadow_std);
[N1,~] = histcounts(sh,edges);
[N2,~] = histcounts(nsh,edges);
ShockableNum = size(sh,1);
NonShockableNum = size(nsh,1);

NumText1 = cell(size(N));
NumText2 = cell(size(N));
for i=1:size(N,2)
    NumText1{i} = num2str(N1(i)) ;
    NumText2{i} = num2str(N2(i)) ;
end
seg = edges(2)-edges(1);
x = edges(1:end-1)+labelx*seg;
y1 = N1;
y2 = N2;
x1 = x;
x1(y1==0)=[];
NumText1(y1==0)=[];
y1(y1==0)=[];
x2 = x;
x2(y2==0)=[];
NumText2(y2==0)=[];
y2(y2==0)=[];
y1 = y1+labley1;
y2 = y2+labley2;
figure
set(gcf,'unit','centimeters','position',[10 5 30 20]);
h1 = histogram(sh,edges);
text(x1,y1,NumText1,'FontSize',16,'Color','b')
text
hold on
h2 = histogram(nsh,edges);
text(x2,y2,NumText2,'FontSize',14,'Color','r')
legend({strcat(num2str(ShockableNum),32, 'Shockable Ryhthm'),strcat(num2str(NonShockableNum),32, 'NonShockable Ryhthm')},'FontSize',16)
end
