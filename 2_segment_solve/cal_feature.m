addpath('../Auxiliary/')
Database = {'cudb','ohca','mitdb','vfdb','ahadb'};
wL = [8];
for i=1:length(Database)
    for j=1:length(wL)
            database = Database{i};
            [ECG,lable,train_test,ID, multiLable] = loading(database,wL(j));
            Feat = calculate_feat(ECG,250,wL(j),0);
            X = Feat;
            y = lable;
            writename = ['..\data\table\' database '_' num2str(wL(j))];
            data = table(X,y,multiLable,ID);
            save(writename,'data')
    end
end