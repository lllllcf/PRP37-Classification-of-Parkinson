%数据读取，数据有11个横的项目，最后一个0没用，1没病，2有病
%第一个数据可以忽略，没用的忽略，竖着最多二十万个数据
True = 0;
recall = 0;
precision = 0;    
%TP = 0;
%FN = 0;
%FP = 0;
%TN = 0;

NewData = importdata('DataIntegrate.txt');
Judge = importdata('Output.txt');
[NDsize1,NDsize2]=size(NewData);

%数据归一化
[NormData,min,max] = premnmx(NewData);

%构造输出矩阵
Result = zeros(NDsize1, 2) ;
for i = 1 : NDsize1
   Result(i, Judge(i,1)) = 1;
end

for j = 1: 10
    %输入输出的准备，以及训练集和测试集的分离
    %十倍交叉验证
    fold = floor(NDsize1 / 10);
    NormData = NormData(1: fold * 10,:);
    Result = Result(1: fold * 10,:);
    
    testInput = NormData(((j - 1) * fold + 1):(fold * j),:);
    judgeOutput = Result(((j - 1) * fold + 1):(fold * j),:);
    judgeOutput = judgeOutput';
    
    NormData1 = NormData;
    Result1 = Result;
    NormData1(((j - 1) * fold + 1):(fold * j),:) = [];
    Result1(((j - 1) * fold + 1):(fold * j),:) = [];
    input = NormData1';
    output = Result1;

    net = newff( minmax(input) , [10 10 2] , { 'purelin' 'tansig' 'purelin' } , 'traingd' ); 
    
    net.trainparam.show = 50 ;% 显示中间结果的周期
    net.trainparam.epochs = 500 ;%最大迭代次数（学习次数）
    net.trainparam.goal = 0.01 ;%神经网络训练的目标误差
    net.trainParam.lr = 0.01 ;%学习速率（Learning rate）
    %开始训练
    %其中input为训练集的输入信号，对应output为训练集的输出结果
    net = train( net, input , output' ) ;

    %测试一下
    testInput = testInput';
    testOutput = sim(net, testInput);

    %统计识别正确率
    [outSize1, outSize2] = size(testOutput);
    hitNum = 0;
    for i = 1 : outSize2
    
        A = testOutput(: ,i );
        if A(1) > A(2)
            Index = 1;
        else
            Index = 2;
        end
    
        if judgeOutput(1,i) == 1
            judgeOutputIndex = 1;
        else
            judgeOutputIndex = 2;
        end
        
        if(Index  == judgeOutputIndex)
            hitNum = hitNum + 1 ; 
        end
        
    %    if (Index == 1 && judgeOutputIndex == 1)
    %        TN = TN + 1;
    %    end
    %    if (Index == 1 && judgeOutputIndex == 2)
    %        FN = FN + 1;
    %    end
    %    if (Index == 2 && judgeOutputIndex == 1)
    %        FP = FP + 1;
    %    end
    %    if (Index == 2 && judgeOutputIndex == 2)
    %        TP = TP + 1;
    %    end
    end
    
    True = True + 100 * hitNum / outSize2;
    %if (TP + FP == 0) 
    %    precision = precision;
    %else
    %    precision = precision + TP / (TP + FP) * 100;
    %end
    %if ((TP + FN) == 0) 
    %    recall = recall;
    %else
    %     recall = recall + TP / (TP + FN) * 100;
    %end

    %TP = 0;
    %FN = 0;
    %FP = 0;
    %TN = 0;
end

sprintf(' %3.3f%%', True / 10)
%sprintf(' %3.3f%%', precision / 10)
%sprintf(' %3.3f%%', recall / 10)
