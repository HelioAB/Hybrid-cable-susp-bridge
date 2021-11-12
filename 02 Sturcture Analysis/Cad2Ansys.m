%%
% 清理
clear
clc



%%
% 导入.xls文件的格式
% 端点X     端点Y     端点Z     起点X     起点Y     起点Z     图层
% -12	    -4.25     0         0	      -4.25	    9.10	  '斜拉索'
% ...

% CAD导出时，如果数量那一栏不为1，说明有线段重复了，应该去掉
First_orig_data = importdata("Input_全桥.xls"); % 导入一个记载节点与线位置的.xls文件
Second_orig_data = First_orig_data(2:end,1:end-1);
Data_size = size(Second_orig_data);
Data = cellfun(@str2num,Second_orig_data);
% Data



%%
% 转换成Table类型的数据

layers = First_orig_data(2:end,end); % 图层信息
temp = [num2cell(Data),layers]; % 把cell中数值变成数值cell，再将之与图层信息合并
Lines = cell2table(temp); % cell转换成Table
Lines.Properties.VariableNames = [{'Xi'},{'Yi'},{'Zi'},{'Xj'},{'Yj'},{'Zj'},{'layer'}]; % Table的表头改变一下
Xi = Lines.Xi;
Yi = Lines.Yi;
Zi = Lines.Zi;
Xj = Lines.Xj;
Yj = Lines.Yj;
Zj = Lines.Zj;



%%
% 图层名称自己手动输入
% 这里的每个图层名称都一定要在Lines中有，也就是CAD中的图层名称要和这里保持一致
% layers_name = {'主梁','刚性横梁','主塔','锚定','辅助墩','斜拉索'};
layers_name = unique(layers);

% 可以写一个替换图层名称的函数



%%
% 在Table表格T中，新增储存IJ节点编号的列
Lines.num_nodeI = int8(zeros(Data_size(1),1)); % 存储I节点编号
Lines.num_nodeJ = int8(zeros(Data_size(1),1)); % 存储J节点编号



%%
% 节点编号排序

% 初始化一些参数
Table = Lines;
table_size = size(Table);
nodes_layer = [];


for i=1:length(layers_name) % 遍历一遍图层
    layer_name = layers_name(i);
    same_layer_lines = table();
    
    num_same_line_layer = 1; % 每遍历一次图层，都重新初始化num_line_layer
    for j=1:table_size(1) % 遍历一遍整个备份列表Table

        if strcmp(Table.layer{j},layer_name) % 如果一条线的图层名称是指定的图层名称的话

            same_layer_lines(num_same_line_layer,:) = Table(j,:); % 就把一整行赋值给layer_lines的第num_line_layer行
            % Table(j,:) = [];
            num_same_line_layer = num_same_line_layer + 1; % num_line_layer行只在进行上述赋值操作后才+1
        end

    end

    nodes_layer = [nodes_layer;Sort_nodes(same_layer_lines)]; % 合并上一图层排好序的nodes和这一图层排好序的nodes
    nodes = unique(nodes_layer,"rows","stable"); % 删除多余节点，'stable'按照原来nodes_layer的顺序进行保留

end

% 上述循环 分图层 地进行节点排序，让节点排序看起来更自然合理



%%
Lines = Gen_elem(Lines,nodes,layers_name);



%%
sorted_elem = [];

for i=1:length(layers_name) % 遍历一遍图层
    layer_name = layers_name(i);
    same_layer_lines = table();
    
    num_same_line_layer = 1; % 每遍历一次图层，都重新初始化num_line_layer
    for j=1:table_size(1) % 遍历一遍整个备份列表Table

        if strcmp(Lines.layer{j},layer_name) % 如果一条线的图层名称是指定的图层名称的话

            same_layer_lines(num_same_line_layer,:) = Lines(j,:); % same_layer_lines把图层相同的层摘了出来
            % Table(j,:) = [];
            num_same_line_layer = num_same_line_layer + 1; % num_same_line_layer行只在进行上述赋值操作后才+1
        end

    end
    same_layer_sorted_elem = sortrows(same_layer_lines,[8]);
    sorted_elem = [sorted_elem;same_layer_sorted_elem]; % 合并上一图层排好序的nodes和这一图层排好序的nodes
    
end
Lines = sorted_elem;



%%
% plot一下节点和节点编号
plot3(nodes(:,1),nodes(:,2),nodes(:,3),'o')

for i=1:length(nodes)
    text(nodes(i,1),nodes(i,2),nodes(i,3),num2str(i))
end
hold on

% plot一下单元和单元编号
X = [Xi';Xj'];
Y = [Yi';Yj'];
Z = [Zi';Zj'];
line(X,Y,Z)

for i=1:Data_size(1)
    text(mean([X(1,i),X(2,i)]),mean([Y(1,i),Y(2,i)]),mean([Z(1,i),Z(2,i)]),num2str(i))
end



%%
% 输出成Ansys的mac文件
Ansys_mac_print(Lines,nodes,layers_name);

