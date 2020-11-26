function [y,labels]=slovenan(x,labels)
%% 同步处理缺失值
nanindex = [];
for i = 1:length(x)
        if isnan(x(i))
            nanindex=[nanindex i];
        end
end
 Potential_pacemaker = diff(nanindex);
 pacemaker = find(Potential_pacemaker>1000);
 
 
 segmaker = [];
 for i=1:length(pacemaker)
     segmaker = [segmaker pacemaker(i)];
     segmaker = [segmaker pacemaker(i)+1];
 end
segmaker = [1 segmaker];
segmaker = [segmaker length(nanindex)];

throwindex = nanindex(segmaker);
for i=1:length(segmaker)/2
    star = throwindex((i-1)*2+1);
    stop = throwindex((i-1)*2+2);
    x(star:stop,:)=520;
    labels(star:stop,:)=520;
end
x(x==520)=[];
labels(labels==520)=[];
y=x;
end
 
     