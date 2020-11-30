 
    %% This file calculates force on actin nodes due to actin polymerization directed outward from nucleation point to enable actin growth
       
    %----Implementing Equation-5------
       RandNodes=randperm(Ac_NodeCount);
    for i= 1:Ac_NodeCount
        NodeID= RandNodes(i); % randomly pick up an actin node
        
        npfID=  Ac_Node(NodeID,ASSCNPF);  %   corresponding nucleation point 
        
        theta = Ac_Node(NodeID,THETA);% angle of the filament used to get its direction
        
        dir_C= cos(deg2rad(theta)); %% x is the col
        dir_R= -sin(deg2rad(theta)); %% taking -ve sign because the y axis of the image is pointed downwards
        

        if Ac_Node(NodeID,LEN) > Lth % cap the actin filament after a length threshold
            Fpoly(NodeID,ROW) =0 ;    % If reached certain length growth stops.
            Fpoly(NodeID,COL) =0 ;
        else
          
		  
            Fpoly(NodeID,ROW)= Knpf*dir_R;  % polymerization force
            Fpoly(NodeID,COL)= Knpf*dir_C;
        end
        
        
        %% net force on actin node 
        F_AcNet(NodeID,ROW)= Fpoly(NodeID,ROW);
        F_AcNet(NodeID,COL)= Fpoly(NodeID,COL);
        
    end
    