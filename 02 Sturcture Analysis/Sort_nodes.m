function nodes = Sort_nodes(Lines,sort_cols,sort_dir) % 节点排序
    % Lines:待排序的table
    % sort_cols:根据什么样的列的顺序进行排列
    % sort_dir: 每个列是正序还是倒序排列

    % 编号原则：先按Z排，再按Y排，再按X排
    % 使用矩阵排序命令B = sortrows(A,Column,Direction)
    
    % 一些参数声明和初始化
    arguments
        Lines table % 参数Lines的类型必须为table
        sort_cols (1,3) {mustBeNumeric} = [3,2,1] % 参数sort_cols的大小为1行3列，类型必须为数值，默认值为[3 2 1]
        sort_dir (1,3) cell = {'ascend' 'ascend','ascend'}
    end

    nodes_used = [Lines.Xi,Lines.Yi,Lines.Zi;Lines.Xj,Lines.Yj,Lines.Zj]; % I点和J点拼接在一起
    sorted_nodes = sortrows(nodes_used,sort_cols,sort_dir);
    nodes = unique(sorted_nodes,"rows","stable");
    

end