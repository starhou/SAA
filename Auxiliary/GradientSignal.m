%% 求梯度
function gradient = GradientSignal(x)

% 求信号梯度
% 
% input   x     信号段 
% 
% output  gradient  原信号的梯度
% 
% example:
% gradient = GradientSignal(x)
% 
% author：star hou  2019.8.20
% email: 1029588176@qq.com
x = [x,x(end)]; 
peak = diff(x);
gradient = peak.^2;
end