%% This file is used for initialization of the actin nodes and wall position. 

clc
clear all
close all

% Following module is called to define different parameters that are used
% in this simulation
ParameterDefination

%% ---------Wall Initialization-------------

disp('initializing Nodes')
Wa_NodeCount=1;

cellCenTemp = cellCenters(1,:);
cellCenter_x = cellCenTemp(1,2); %% col
cellCenter_y = - cellCenTemp(1,1); %% row

%%-- Following lines of code will create a circular wall
for x =cellCenter_x-WalR : cellCenter_x+ WalR
    y1= cellCenter_y - sqrt((WalR)^2- (x-cellCenter_x)^2);
    y2= cellCenter_y + sqrt((WalR)^2- (x-cellCenter_x)^2);
    for y = y1:y2
        row =round(-y);
        col = round(x);
        
        Combo(row,col)= Wa;
    end
end

for x =cellCenter_x-(CapR+40) : cellCenter_x+ (CapR+40)
    y1= cellCenter_y - sqrt((CapR+40)^2- (x-cellCenter_x)^2);
    y2= cellCenter_y + sqrt((CapR+40)^2- (x-cellCenter_x)^2);
    for y = y1:y2
        row =round(-y);
        col = round(x);
                  
            Combo(row,col)= 0;    
     end
end

disp('Making Wall Nodes')
for colNo=1:bound
    for rowNo=1:bound
        if Combo(rowNo,colNo)>0
            
            Wa_NodeNo(rowNo,colNo)=Wa_NodeCount;
            
            Wa_Node(Wa_NodeCount,ROW)=rowNo;
            Wa_Node(Wa_NodeCount,COL)=colNo;
            Wa_Node(Wa_NodeCount,COMBOVALUE)=Combo(rowNo,colNo);  %% Helpful when testing active passive nodes
                       
            Wa_NodeCount=Wa_NodeCount+1;
        end
    end
end
Wa_NodeCount=Wa_NodeCount-1;


% --------Wall Initialization complete------------

%% ---------- Initialize Arp 2/3 actin nodes and nucleation points--------

%%--Following module initialized the actin nodes and nucleation points

InitiateActin
%%---------Initialization process ends here-----------


cd (absoluteFolderPath)
filename=strcat('initialImage');
fig = figure;
imagesc(Combo)
print(fig,filename,'-dpng');
cd ..