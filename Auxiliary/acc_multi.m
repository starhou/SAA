function out = acc_multi(yr, yp, ymulti)
%% Multi-Labels: { 0   Sh-VF, 1 Sh-VT, 2  N, 3 others}
% ������Щ�����б�׼ȷ�� 
% ������б���
    out = [];
    for i = 0:3
        a = ymulti== i;
        ayr= yr(a);
        ayp= yp(a);
        adecision = ayp == ayr;        
        aacc = length(find(adecision == 1))/length(adecision);
        out = [out; aacc];
    end
end