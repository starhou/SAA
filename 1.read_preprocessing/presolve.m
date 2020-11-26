function  [y,labels]=presolve(signal,lab,fs)
%% SECTION TITLE
% pre_solving 
% signal line vecetor
if fs ~= 250
   signal = resample(signal,250,fs);
end
%% ����ȱʧֵ
if any(isnan(signal))
    [signal,labels] = slovenan(signal,lab);
else
        labels=lab;
end
sourcesignal = signal;
%% �˳�����
    N = 10;
    [C,L] = wavedec(signal(:,1),N,'bior2.6');
    cA3 = appcoef(C,L,'bior2.6',10);
    a = detcoef(C,L,1:10);
    a{7} = a{7}*0;
    a{8} = a{8}*0;
    a{9} = a{9}*0;
    a{10} = a{10}*0;
    b = fliplr(a);
    b = b';
    d = cell2mat(b);
    c = [cA3*0;d];
    mysolvedsignal = waverec(c,L,'bior2.6');
% figure
% subplot(211)
% plot(signal(8000:15000))
% title('ԭ�����ź�','FontSize',18)
% subplot(212)
% plot(mysolvedsignal(8000:15000))
% title('ƽ������ź�','FontSize',18)
% keyboard;
% close all;
%% �����˲���
%ƽ��
y = smooth(mysolvedsignal,10);

% %��ͨ
Fs = 250;
F_low = 0.5;
W_low = 2 * F_low / Fs;
[b,a] = butter(1,W_low,'high');
mysolvedsignal = filter(b,a,sourcesignal);%
mysolvedsignal = smooth(mysolvedsignal,5);
%% ��ʾ
% figure(2)
% start = 8000;
% signaLength = 12000;
% t = linspace(0,16,4000);
% ax(1)=subplot(211);
% plot(t, sourcesignal(start+1:signaLength))
% % plot(sourcesignal);
% xlabel("t(s)",'FontSize',16)
% title("ԭʼ�źţ�����VFDB���ݿ�420�Ż���",'FontSize',16,'color','b')
% ax(2)=subplot(212);
% plot(y);
% plot(t, y(start+1:signaLength));
% xlabel("t(s)",'FontSize',16)
% title("����С���任����ͻ����˲���ƽ������ź�",'FontSize',16,'color','b')
% ax(3)=subplot(313);
% plot(mysolvedsignal(start:signaLength));
% xlabel('t(s)','FontSize',12);
% ylabel('x(mv)','FontSize',12);
% title('After 0.5Hz Butterworth LPF','FontSize',16,'color','b')
% linkaxes(ax,'x')
% keyboard;
% close all;
end


