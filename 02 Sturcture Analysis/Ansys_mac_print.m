function Ansys_mac_print(Lines,nodes,layers_name)
    arguments
        Lines table
        nodes (:,3) double
        layers_name (1,:) cell
    end
    % 输出成Ansys的.mac宏文件

    Lines_datasize = size(Lines);
    nodes_datasize = size(nodes);
    num_nodes = nodes_datasize(1);
    
    % 清楚上一次输出的文件
    rmdir('nodes_data', 's') % 's'表示可以删除非空文件夹
    rmdir('elements_data', 's')
    
    mkdir nodes_data
    % 节点node输出格式： k,num_node,X,Y,Z
    fileID = fopen('Nodes.mac','a');
    for i = 1:num_nodes
        fprintf(fileID,'k,%d,%f,%f,%f \n',i,nodes(i,1),nodes(i,2),nodes(i,3));
    end
    fclose(fileID);
    movefile Nodes.mac nodes_data
    
    mkdir elements_data
    % 单元element输出格式：l,node_I,node_J
    % 按照不同的图层进行输出
    for i = 1:length(layers_name)
        layer_name = layers_name{i};
        file_name = [layer_name,'_elements','.mac']; % 生成文件名为 图层.txt的文件
        
        fileID = fopen(file_name,'a');
    
        for j = 1:Lines_datasize(1) % 遍历Lines
            if strcmp(Lines.layer{j},layer_name)
                fprintf(fileID,'l,%d,%d \n',Lines.num_nodeI(j),Lines.num_nodeJ(j));
            end
        end
    
        fclose(fileID);
        
    end
    movefile *_elements.mac elements_data

end