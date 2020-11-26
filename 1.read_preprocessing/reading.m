function reading()
%% read and preprocess data
% patient ID    'ohca', 1-260, 
%               'vfdb', 261-282 
%               'cudb', 283-317 
%               'ahadb' 317-327
%               'mitdb' 328   第29个 patient 207
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

source = {'mitdb'}; 
annotator='atr';
for i = 1:length(source)
    preprocess_name = [source{i} '\*.atr'];
    basename = dir(preprocess_name);
    [l,~] = size(basename);
    for j = 1:l
        signal_name = basename(j).name(1:end-4);
        recordName = [source{i} '/' signal_name];
        [signal,fs,~]= rdsamp(recordName);
        [ann,anntype,~,~,~,comments]= rdann(recordName,annotator);
        lab=getlabel(anntype,signal(:,1),ann,comments);                                
        [y,lab]= presolve(signal(:,1),lab,fs);
        data(j).label = lab;
        data(j).name = signal_name;
        data(j).ecg= y;
        data(j).fs = 250;
        data(j).patID = 328;        
        data(j).bilab = ismember(lab, [19, 20, 21])+0;
        fprintf('solving signal %s\n',signal_name);
    end  
eval([source{i} '= data;'])
save(['..\data\source\' source{i}], source{i});
end


end

%% Auxiliary  function
function label=getlabel(anntype,signal,ann,comments)
% get the label
% input
% anntype  -- label(char)   Non-beat annotations
% signal -- ecg data
% ann -- the index of plb
% comments -- label(cell)

if ~isequal(length(signal),ann(end))
    ann(end+1)= length(signal);   
end
label = ones(length(signal),1)*0;
% if type == 1
%    y = cudb_label(anntype,label,ann,comments);
% else
y = vfdb_label(anntype,label,ann,comments);
% end
label = y;

end

function num = commtonum(comment)
% convert char to num & get standard_table
% input -- comment (char)
% output -- a num
load('.\std_table')
std = std_table(1,:);
lable = std_table(2,:);
num = find(strcmp(std, comment));
if isempty(num)
    num = 0;
else
%     if num == 7
%         keyboard;
%     end
    sprintf('��⵽��ǩ%s',comment)
    num = lable{num};
end
end
function  y = vfdb_label(anntype,label,ann,comments)
%% �����ݿ���ǩ
%%% ��Щע��ʱʹ��comments
commentsTable = {'[','!'};
num = 12;
for i = 1:length(ann)-1
    if ismember(anntype(i),commentsTable)
        num = commtonum(anntype(i));
        label(ann(i):ann(i+1)) = num;
    else
        if isempty(comments{i})
            label(ann(i):ann(i+1)) = num;
        else
            num = commtonum(comments{i});
            label(ann(i):ann(i+1)) = num;   
        end        
    end
end
y = label;
end