function confusion_matrix(yr,yp)
[mat,order] = confusionmat(yr,yp); 
imagesc(mat,'AlphaData',0.6);            %# Create a colored plot of the matrix values

% comap =  [[135,206,235]/255;...
%           [0,191,255]/255;...
%           [255,228,225]/255;...
%           [255,250,250]/255];
colormap(flipud(gray));  %# Change the colormap to gray (so higher values are
                         %#   black and lower values are white)

ACC = {};
Accuracy(4) = 1-mat(1,2)/(mat(1,1)+mat(1,2));
Accuracy(3) = 1-mat(2,1)/(mat(2,2)+mat(2,1));
Accuracy(2) = 1-mat(1,2)/(mat(2,2)+mat(1,2)); 
Accuracy(1) = 1-mat(2,1)/(mat(2,1)+mat(1,1));
Accuracy = round(Accuracy.*(10^4))./10^4;
% num2str(percent()) 
for i = 1:4
    ACC{i} = num2str(percent(Accuracy(i)));
end
ACC = strtrim(ACC);
textStrings = num2str(mat(:),'%0.02f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding
%% ## New code: ###
%idx = find(strcmp(textStrings(:), '0.00'));
%textStrings(idx) = {'   '};
%% ################
 
[x,y] = meshgrid(1:2);   %# Create x and y coordinates for the strings
textStrings(1)={'TN(N:5359, O:1629, patNum:68)'};
textStrings(2)={'FP(VF:26, VT:28, patNum:11)'};
textStrings(3)={'FN(N:27, O:14, patNum:18)'};
textStrings(4)={'TP(VF:1302, VT:324, patNum:61)'};
ACC(1)={'NPV=0.99'};
ACC(2)={'PPV=0.97'};
ACC(3)={'SE=0.97'};
ACC(4)={'SP=0.99'};
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center','FontSize',32);
x = [1 2 2.62 2.62];
y = [2.6 2.6 2 1];
% text(x,y,ACC,'FontSize',8,'HorizontalAlignment','center')

midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(mat(:) > midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors



set(gca,'XTick',1:2,...                         %# Change the axes tick marks
        'XTickLabel',{'NSHR','SHR'},...  %#   and tick labels
        'YTick',1:2,...
        'YTickLabel',{'NSHR','SHR'},...
        'TickLength',[0 0],'fontsize',32,...
        'FontName','Times New Roman');
xlabel('True Label');
ylabel('Pridict Label');
end

function B=percent(A)
[m,n]=size(A);B=[];
A=A*100;
for i=1:m
    for j=1:n
        B=[B num2str(A(i,j)),'%','  '];
    end
%     B=[B 13];  %加一个回车，回车符的ASCII是13.
end
end