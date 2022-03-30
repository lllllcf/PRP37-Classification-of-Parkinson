%数据读取，数据有11个横的项目，最后一个0没用，1没病，2有病
%第一个数据可以忽略，没用的忽略，竖着最多二十万个数据
precision = 0;
Data1=importdata('dataset_fog_release\dataset\S01R01.txt');
Data2=importdata('dataset_fog_release\dataset\S01R02.txt');
Data3=importdata('dataset_fog_release\dataset\S02R01.txt');
Data4=importdata('dataset_fog_release\dataset\S02R02.txt');
Data5=importdata('dataset_fog_release\dataset\S03R01.txt');
Data6=importdata('dataset_fog_release\dataset\S03R02.txt');
Data7=importdata('dataset_fog_release\dataset\S03R03.txt');
Data8=importdata('dataset_fog_release\dataset\S04R01.txt');
Data9=importdata('dataset_fog_release\dataset\S05R01.txt');
Data10=importdata('dataset_fog_release\dataset\S05R02.txt');
Data11=importdata('dataset_fog_release\dataset\S06R01.txt');
Data12=importdata('dataset_fog_release\dataset\S06R02.txt');
Data13=importdata('dataset_fog_release\dataset\S07R01.txt');
Data14=importdata('dataset_fog_release\dataset\S07R02.txt');
Data15=importdata('dataset_fog_release\dataset\S08R01.txt');
Data16=importdata('dataset_fog_release\dataset\S09R01.txt');
Data17=importdata('dataset_fog_release\dataset\S10R01.txt');

Data = [Data1; Data2; Data3; Data4; Data5; Data6; Data7; Data8; Data9; Data10; Data11; Data12; Data13; Data14; Data15; Data16; Data17];
[Dsize1,Dsize2]=size(Data);

%去掉0
NewData = zeros(1,9);
Judge = zeros(1,1);

for i = 1:Dsize1
    if Data(i,11) == 1 || Data(i,11) == 2
        NewData = [NewData; Data(i,2:10)];
        Judge = [Judge; Data(i,11)];
    end
end
NewData(1,:) = [];
Judge(1,:) = [];
[NDsize1,NDsize2]=size(NewData);

%数据归一化
[NormData,min,max] = premnmx(NewData);

save('DataIntegrate.txt','NormData','-ascii');
save('Output.txt','Judge','-ascii');