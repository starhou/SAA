function vf = calculate_VFLEAK(senal)

% VF LEAK parameter, based on:
%
% 1) "Computer detection of ventricular fibrillation"
%    S. Kuo, D. Dillman, Computers in Cardiology, 1978, 2747-2750.
%
% 2) "Reliability of old and new ventricular fibrillation detection 
%    algorithms for automated external defibrillators"
%    A. Amann, R. Tratning, and K. Unterkofler,
%    Biomed Eng Online, 4(60), 2005.
%
% INPUT:
% - senal: ecg signal (preprocessed)
%
% OUTPUT
% - vfleak parameter
%
% by Felipe Alonso-Atienza (felipe.alonso@urjc.es)
% www.tsc.urjc.es/~felipe.alonso
% star hou   2019 .9.11  
% N = floor ( ( pi*(num)/(den) ) + 1/2 );
%-->N = floor ( ( pi*(num)/(den) ) );
% star hou   2019 .9.22  
% N = floor ( ( pi*(num)/(den) ) );
%-->N = floor ( ( pi*(num)/(den) )+ 1/2  );
senal = MinMaxScaler(senal);
num = sum (abs(senal(2:end)));
den = sum (abs( senal(2:end) - senal(1:end-1) ));

N = floor ( ( pi*(num)/(den) )+ 1/2 );

num = sum( abs( senal(N+1:end) + senal(1:end-N)) );
den = sum( abs(senal(N+1:end)) + abs(senal(1:end-N)));
  
vf = num/den;
end
function ecg = MinMaxScaler(ecg)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 把信号归一化为0到1之间
% input 
%          ecg 未归一化的数据
% output
%          ecg 归一化的数据
% example: ecg = MinMaxScaler(ecg)
% auther:  star hou 
% email:   1029588176@qq.com
% refer to sklearn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = ecg;
up = 1;
down = -1;
% method 1
X_std = (X-min(X))/(max(X)-min(X));
X_scaled = X_std * (up - down) + down;

% method 2
scale = (up - down) / (max(X) - min(X));
X_scaled2 = scale * X + down - min(X) * scale;

ecg = X_scaled;

end

