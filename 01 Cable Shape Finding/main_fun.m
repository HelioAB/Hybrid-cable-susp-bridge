% 清理
clear
clc

%% 
% 1. 参数初始化

% 1.1 主缆自重相关
gamma_cable = 78.5; % 主缆容重，单位kN/m^3
D_cable = 1;  % 主缆截面直径，单位m
A_cable = pi/4*D_cable^2; % 主缆截面面积，单位m^2
q_cable = A_cable * gamma_cable; % 主缆自重集度q，单位kN/m

% 1.2 主梁相关
l_beam_seg = 12.5; % 吊杆之间的主梁长度，一段主梁的长度，单位m，常数
gamma_beam = 78.5; % 主梁容重，单位kN/m^3
A_beam = 1; % 主梁截面面积，单位m^2
q_beam = A_beam * gamma_beam; % 主梁自重集度q，单位kN/m

% 1.3 吊杆相关
n = 119;    % 吊杆数目n
Li = l_beam_seg * ones([1,n+1]);   % Li为每个悬链线分段的水平长度组成的向量，length(L) = n+1
P = q_beam * l_beam_seg * ones([1,n]);   % 吊杆拉力P，P中每个元素表示第i根吊杆的拉力P_i，length(P) = n

% 1.4 顶点和中点高程
hA = 200;   % A点的高程
hB = 200;   % B点的高程
hOm = 50;  % 跨中O_m点的高程，也就是主缆垂度

% 1.5 设m为跨中中点
if mod(n,2) == 1 % n是奇数的情况
    m = (n+1)/2;
elseif mod(n,2) == 0 % n是偶数的情况
    m = n/2;
end

% 1.6 将目标函数中需要的数据写一个.mat文件
save('InitData.mat','q_cable','q_beam','l_beam_seg','n','Li','P','hA','hB','hOm','m')



%%
% 2. 其他参数的设定

% 2.1 优化问题的初值的设定
% 水平力的初始值H通过抛物线确定，a1初始值为0。
x0 = zeros([1,2]); % x的初始值向量
x0(1) = Init_H();

% 2.2 设置线性约束
% 只设置水平力的线性约束
A = [-1,0;0,0];
b = [0;0];

% 2.3 优化算法的选择
% options = optimoptions('fmincon','Display','iter','Algorithm','sqp');



%%
% 3. 优化函数的调用
fun = @ObjectFun;
A;
b;
Aeq = [];
beq = [];
lb = [];
ub = [];
nonlcon = [];
x0;
[x,fval] = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon);



%%
% 4. 作图生成悬链线形状
[Xi,Yi] = Seg_catenary(q_cable,n,Li,P,x);
X = zeros([1,length(Xi)+1]);
Y = zeros([1,length(Yi)+1]);

for i=2:length(X)
    X(i) = Xi(i-1) + X(i-1);
    Y(i) = Yi(i-1) + Y(i-1);
end

plot(X,-Y)
title('主缆线形')
xlabel('距A点水平距离')
ylabel('距A点竖直距离')
