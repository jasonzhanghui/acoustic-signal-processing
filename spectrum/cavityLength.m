%********************ǻ�����******************************%
clc;clear all;close;
format long;
A(:,:,1) = csvread('W0007.CSV',29); 
for i=1:1
w=A(:,1,i);   %����
y=A(:,2,i);   %��ǿ
plot(w,y,'Color',[rand(),rand(),rand()]);hold on;
%********************���Ƚ��ǻ��**************************%
% ѡȡ�������ڷ�Χ��������
[x,~] = ginput(3);
B=round(x'); %���岨���������䷶Χ
for j=1:3
n(j)=find(w==B(j));
end
for k=1:2
[ymin(k,i),tmin(k,i)]=min(y(n(k):n(k+1))); %�Ҳ���
wmin(k,i)=w(tmin(k,i)+n(k)-1); %�Ҳ��ȶ�Ӧ�Ĳ���λ��
end
m_min(i)=round(wmin(1,i)./(wmin(2,i)-wmin(1,i))); %˫��ȷ������
L_min(i)=m_min(i).*wmin(2,i)./2000; %������ǻ��
end

fprintf('Cavity Wavelength:\n')
disp(L_min')