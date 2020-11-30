%% SIMULATION STARTS HERE
% This file is used to run the simulation after the initialization is
% completed. It calls module 'Force_Calculation' to first calculate force on inidividual
% nodes of actin material and then moves actin nodes by calling module
% 'MoveActin'. Thereafter, the code deletes filaments that have aged. It also
% removes wall to test affect of wall removal. Finally it generates output
% in form of images to visualize and study material behavior in the given
% setup.

NodeDensity = zeros(4000,2);
for mcs=1:5000
    mcs
    
    NewActin=0;
    F_AcNet=zeros(Ac_NodeCount,2);
    
    Combo = zeros(bound,bound);
    
    %% % ----Forces calulation module-----
    
    Force_Calculation;
    
    %Since lattice was reset, wall is placed again in the following lines
    
    for NodeID = 1: Wa_NodeCount
        colNo= Wa_Node(NodeID,COL);
        rowNo= Wa_Node(NodeID,ROW);
        Combo(round(rowNo),round(colNo))=Wa;
    end
    %---Following Module is called to move actin nodes---
    MoveActin;
    
    %%%%%%%%%%%%%% For Deleting Filamnets  %%%%%%%%%%%%%%%%%%%%%%%
    kount=0;
    for NodeID= 1:Ac_NodeCount
        if NodeID>Ac_NodeCount
            break
        end
        if Ac_Node(NodeID,AGE) > (AgeTh)  
            Rno= rand(1);
            if Rno< P_del
                %             disp('count deleting nodes')
                kount= kount+1;
                NodeToDel(kount)= NodeID;
                
            end
        end
    end
    
    %
    for del = kount:-1:1  %% deleting in reverse order to avoid shifting overhead of nodeID
        NodeID= NodeToDel(del);
        Combo(round(Ac_Node(NodeID,ROW)),round(Ac_Node(NodeID,COL)))=0;
        %     disp('Deleting Now')
        Ac_Node(NodeID,:)=[];
        Ac_NodeCount=Ac_NodeCount-1;
        
    end
 
    Ac_NodeNo=ones(rows,cols).*-1;
    for NodeID= 1:Ac_NodeCount
        Ac_NodeNo(round(Ac_Node(NodeID,ROW)),round(Ac_Node(NodeID,COL)))=NodeID;
    end
    
    %%%-------Follwing lines of code will remove the wall at the assigned
    %%%simulation step 
    
    if mcs==2000% 
        % %  remove wall
        for NodeID = 1: Wa_NodeCount
            
            colNo= Wa_Node(NodeID,2);
            rowNo= Wa_Node(NodeID,1);
            Wa_NodeNo(round(rowNo),round(colNo))=-1;
            Wa_Node(NodeID,3)=0;
        end
        Wa_NodeCount=1;
        
        Wa_NodeNo(round(1),round(1))=1;
        Wa_Node(1,3)=350;
    end
    
    
    %%%%%%%%%%%%%%%%%%-----END--------%%%%%%%%%%%%%%%%%%%%%
    
    %% Following lines of code outputs the images for visualization 
    
    if mcs==2
        close all
        cd (absoluteFolderPath)
        Actinfoldername=strcat('Combo');
        mkdir(Actinfoldername);
        cd (Actinfoldername)
        filename=strcat('Actin_',num2str(mcs));
        fig = figure;
        imagesc(Combo)
        axis square
        colormap('hot')
        print(fig,filename,'-dpng');
        cd ..
        
        Pointfoldername=strcat('Points');
        mkdir(Pointfoldername);
        cd (Pointfoldername)
        Combo(find(Combo == 350)) = 0;  %%%Keeping wall
        imshow(Combo)
        %
        
        axis square
        colormap('hot')
        
        %      imshow(C, 'Colormap', jet(255))
        print(fig,filename,'-dpng');
        
        
        cd ..
        cd ..
    end
    
    if mod(mcs,100)==0
        close all
        cd (absoluteFolderPath)
        Actinfoldername=strcat('Combo');
        mkdir(Actinfoldername);
        cd (Actinfoldername)
        filename=strcat('Combo_',num2str(mcs));
        fig = figure;
        imagesc(Combo)
        axis square
        colormap('hot')
        print(fig,filename,'-dpng');
        cd ..
        
        Pointfoldername=strcat('Points');
        mkdir(Pointfoldername);
        cd (Pointfoldername)
        Combo(find(Combo == 350)) = 0;
        imshow(Combo)
        
        
        axis square
        colormap('hot')
        
        %      imshow(C, 'Colormap', jet(255))
        print(fig,filename,'-dpng');
        
        cd ..
        cd ..
        
        %
    end
    %
    M=Ac_NodeNo>0;
    nnz(M);
    ActinLenCounter(mcs)=length(find(Ac_Node(:,6)<=AgeBr));
    ActinCounter(mcs)=Ac_NodeCount;
    NewBranches(mcs)=NewActin;
    DelActin(mcs)=kount;
    
end
cd (absoluteFolderPath)
filename=strcat('ActotalPlot_',num2str(mcs));
fig = figure;
plot(ActinCounter)
print(fig,filename,'-dpng');

filename=strcat('LenPlot_',num2str(mcs));
fig = figure;
plot(ActinLenCounter)
print(fig,filename,'-dpng');

filename=strcat('NewActinPlot_',num2str(mcs));
fig = figure;
plot(NewBranches)
print(fig,filename,'-dpng');

filename=strcat('DelActinPlot_',num2str(mcs));
fig = figure;
plot(DelActin)
print(fig,filename,'-dpng');
cd ..

