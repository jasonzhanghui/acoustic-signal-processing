%******************************腔长解调******************************%
clc;clear;
format short;
% 路径2:硬盘中存储数据的路径
dir2 = 'D:\Jason\Study\Postgraduate Projects\光纤超声\可控探头制作\100微米探头\探头2-13\';
% dir2 = 'D:\Jason\Study\Postgraduate Projects\光纤超声\可控探头制作\0微米探头\直接旋涂探头';
% 如果不存在则创建该路径
if ~exist(dir2,'dir')
    mkdir(dir2);
end
% 该路径中的csv文件列表
filelist2 = ls([dir2,'\*.csv']);
% 读取U盘中的文件列表，如果某个csv不包含于上面文件夹，则复制到上面文件夹
if exist('I:\','dir')
    dir1 = 'I:\';       % 路径1:U盘
    filelist1 = ls([dir1,'*.csv']);
    idx = ismember(filelist1,filelist2,'rows');
    for i = 1:size(filelist1,1)
        if ~idx(i)
            copyfile([dir1,filelist1(i,:)],dir2);
        end
    end
    filelist2 = ls([dir2,'\*.csv']);
end
N = size(filelist2,1);
for i = 1:N
    data(:,:,i) = csvread([dir2,'\',filelist2(i,:)],30);
end
% 初始化存储波峰，波谷，干涉级次等参数的变量
init = @(m) zeros(N,m);
troughWL = init(2);
L = init(1);    % peakWL = init(1); m = init(1);  R1 = init(1); R2 = init(1); n1 = init(1); n2 = init(1);
for i=1:N
    wavelength = data(:,1,i);   %波长
    % y=10.^(A(:,2,i)./10);
    intensity = smooth(data(:,2,i),200,'lowess');   %光强
    plot(wavelength,intensity,'linewidth',2);hold on;

    % ********************单双峰解调腔长************************%
    % 寻找波谷所对应的波长
    [troughs,locs] = findpeaks(-intensity,wavelength);
    troughWL(i,:) = mink(locs',2);
    trough = -troughs(1);
    w1 = troughWL(i,1);
    w2 = troughWL(i,2);
    % 计算干涉级次
    m(i) = round(w1./(w2-w1));
    % 计算腔长
    L(i) = m(i).*w2./2./1000;
    % m_min(i)=round((wmin(1,i)./(wmin(2,i)-wmin(1,i)))); %确定干涉级次m
    % L_min(i)=m_min(i).*wmin(2,i)./2000;                 %求腔长
    % text(wmin(1,i),y(tmin(1,i)+n(1)-1),'▲','color',color,'HorizontalAlignment','center');
    % 定义波峰所在区间求反射率
    
%     % 求波峰的大小及位置
%     [pks,locs] = findpeaks(intensity,wavelength);
%     % 求出若干个波峰位置，取第一个
%     peakWL(i) = min(locs);
%     peak = pks(1);
%     a = w1.*L(i)./37714.8;
%     coff = (4+4.*a.^2)./((2+a.^2).^2);
%     % 计算反射率
%     R1(i) = (((sqrt(peak)+sqrt(trough))/2).^2);
%     R2(i) = (((sqrt(peak)-sqrt(trough))/2).^2)/coff;
%     % 计算折射率
%     n1(i) = (sqrt(R1(i))+1)./(1-sqrt(R1(i)))*1.4682;
%     n2(i) = (sqrt(R2(i))+1)./(1-sqrt(R2(i)))*1;
end
hold off
% plot(wavelength,reshape(data(:,2,:),10000,N))
fprintf('Cavity length:\n')
disp(L')
if N > 5
    disp('Average cavity length:')
    disp(mean(L(end-4:end)))
end
