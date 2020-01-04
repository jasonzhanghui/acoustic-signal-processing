%********************腔长解调******************************%
clc;clear all;close;
format long;
A(:,:,1) = csvread('W0007.CSV',29); 
for i=1:1
w=A(:,1,i);   %波长
y=A(:,2,i);   %光强
plot(w,y,'Color',[rand(),rand(),rand()]);hold on;
%********************波谷解调腔长**************************%
% 选取波谷所在范围的三个点
[x,~] = ginput(3);
B=round(x'); %定义波谷所在区间范围
for j=1:3
n(j)=find(w==B(j));
end
for k=1:2
[ymin(k,i),tmin(k,i)]=min(y(n(k):n(k+1))); %找波谷
wmin(k,i)=w(tmin(k,i)+n(k)-1); %找波谷对应的波长位置
end
m_min(i)=round(wmin(1,i)./(wmin(2,i)-wmin(1,i))); %双峰确定级次
L_min(i)=m_min(i).*wmin(2,i)./2000; %单峰解调腔长
end

fprintf('Cavity Wavelength:\n')
disp(L_min')