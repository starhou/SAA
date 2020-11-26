function acc_patient_id(yr,yp,ID)

Total = unique(ID);


FP = unique(ID(yr == -1 & yp == 1));
FN = unique(ID(yr == 1 & yp == -1));

TP = unique(ID(yr == 1 & yp == 1));
TN = unique(ID(yr == -1 & yp == -1));

P = unique(ID(yr == 1));
N = unique(ID(yr == -1));

CTP = setdiff(P, FN);
CTN = setdiff(N, FP);

T = intersect(CTP,CTN);
F = intersect(FP,FN);
% confusion_matrix(yr,yp)
end