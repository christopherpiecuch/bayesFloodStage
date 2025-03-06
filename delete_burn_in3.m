%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete_burn_in
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deletes specified warm-up interations from solution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code written by CGP 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
U(1:NN_burn_thin,:)=[];
V(1:NN_burn_thin,:)=[];
ALPHA(1:NN_burn_thin)=[];
BETA(1:NN_burn_thin)=[];
RHO(1:NN_burn_thin)=[];
OMEGA_2(1:NN_burn_thin)=[];
EPSILON_2(1:NN_burn_thin)=[];
