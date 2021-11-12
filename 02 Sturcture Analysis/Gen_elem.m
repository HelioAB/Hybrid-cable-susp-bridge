function Lines = Gen_elem(Lines,nodes,layers_name)
    arguments
        Lines table
        nodes (:,3) double
        layers_name (1,:) cell
    end

    % 已有节点，通过节点生成单元
    Lines_datasize = size(Lines);
    nodes_datasize = size(nodes);
    len_layers = length(layers_name);

    tol = eps(0.5); % 比较浮点数的容差
    %abs(a-0) < tol % 判断两个浮点数相等的方法

    
    for i=1:Lines_datasize(1)
        % 一行一行遍历整个Lines
    
        for j = 1:len_layers
            layer_name = layers_name{j};
            % 遍历所有图层
    
            if strcmp(Lines.layer{i},layer_name)
                % 如果属于某根直线属于某个图层
    
                for n = 1:nodes_datasize(1)
                    % 判断该直线的I节点和J节点的节点编号，节点编号已经在前面编好了
                    if (abs(Lines.Xi(i)-nodes(n,1)) < tol)&&(abs(Lines.Yi(i)-nodes(n,2)) < tol)&&(abs(Lines.Zi(i)-nodes(n,3)) < tol)
                        Lines.num_nodeI(i) = n;
                    end
                    if (abs(Lines.Xj(i)-nodes(n,1)) < tol)&&(abs(Lines.Yj(i)-nodes(n,2)) < tol)&&(abs(Lines.Zj(i)-nodes(n,3)) < tol)
                        Lines.num_nodeJ(i) = n;
                    end
    
    
                end
            end
    
        end
    
    end
    % 最终，所有参数都储存在一个Table表格T中
    % 这种还是使用面向对象OOP的方法进行编程比较容易
end