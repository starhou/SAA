%% ���ݶ�
function gradient = GradientSignal(x)

% ���ź��ݶ�
% 
% input   x     �źŶ� 
% 
% output  gradient  ԭ�źŵ��ݶ�
% 
% example:
% gradient = GradientSignal(x)
% 
% author��star hou  2019.8.20
% email: 1029588176@qq.com
x = [x,x(end)]; 
peak = diff(x);
gradient = peak.^2;
end