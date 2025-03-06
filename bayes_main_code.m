%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   function bayes_main_code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code written by CGP 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bayes_main_code

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Say hello
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pause(0.1)
disp('Hello.  Things have started.')
pause(0.1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Some preliminary input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
% name of experiment and file to be saved
nameOfExperiment='floodstagepaper';            % experiment name
save_name=nameOfExperiment;  % file name

%%%
% number of draws to perform
NN_burn=10000;             % 10,000 warm-up draws
NN_post=10000;             % 10,000 post-warm-up draws
thin_period=10;            % thin chains keeping 1 of 10

%%%%%%%%%%cl%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define iteration parameters based on input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NN_burn_thin=NN_burn/thin_period; % Total number of burn-in to keep
NN_post_thin=NN_post/thin_period; % Total number of post-burn-in to keep
NN=NN_burn+NN_post;               % Total number of draws to take 
NN_thin=NN_burn_thin+NN_post_thin;% Total number of draws to keep

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prepare and load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
% load flood stages
load('minorfloodstage.mat')
nws=log(nws);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define space and time parameters related to data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up dimensions of process
[N_nws]=numel(nws);

% bring together all target locations
N = N_nws;
LON = [lon'];
LAT = [lat'];

% define some useful space and time values
D=EarthDistances([LON LAT]);      % distances between locations
L = sum(~isnan(nws));          % number of crustal motion data sites

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the seeds of the random number generator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rng((rand+1)*sum(clock))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the hyperparameter values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
HP = set_hyperparameters4(nws);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Allocate space for the sample arrays
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
alpha=[];
initialize_output_w2

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up selection matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = zeros(N,N);
H(1:N,1:N)=eye(N);
E = zeros(L,N);
E(1:L,1:L)=eye(L);
x = nws';
ell=abs(lat)';

%%%%%%%%%%%%%%%%%%%%
% Set initial values
%%%%%%%%%%%%%%%%%%%%
set_initial_values3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up identity matrices and vectors of zeros or ones
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_N=eye(N);
ONE_N=ones(N,1);
ZERO_N=zeros(N,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loop through the Gibbs sampler with Metropolis step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
for nn=1:NN
    if mod(nn,100)==0
        toc, 
        disp([num2str(nn),' of ',num2str(NN),' iterations done.']), 
        tic, 
    end
    nn_thin=[]; nn_thin=ceil(nn/thin_period);
     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Define matrices to save time
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    OmegaMat=omega_2*exp(-rho*D); invOmegaMat=inv(OmegaMat);
    TMat=exp(-rho*D); invTMat=inv(TMat);
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sample from p(epsilon_2|.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    inside1=[]; inside2=[];
    inside1=N/2;
    inside2=1/2*(v-u)'*(v-u);
    epsilon_2=min([25 1/randraw('gamma', [0,1/(HP.chi_tilde_epsilon_2+inside2),...
      	(HP.xi_tilde_epsilon_2+inside1)], [1,1])]);
   	clear inside*
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sample from p(omega_2|.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inside1=[]; inside2=[];
    inside1=N/2;
    inside2=1/2*(u-alpha*ONE_N-beta*ell)'*invTMat*(u-alpha*ONE_N-beta*ell);
    omega_2=min([25 1/randraw('gamma', [0,1/(HP.chi_tilde_omega_2+inside2),...
      	(HP.xi_tilde_omega_2+inside1)], [1,1])]);
   	clear inside*
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sample from p(rho|.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Rho_now=log(rho);
    Rho_std=0.25;
    Rho_prp=normrnd(Rho_now,Rho_std);
    L_now=exp(-exp(Rho_now)*D);
    L_prp=exp(-exp(Rho_prp)*D);
    invL_now=inv(L_now);
    invL_prp=inv(L_prp);
    sumk_now=0;
    sumk_prp=0;
        
    sumk_now=(u-alpha*ONE_N-beta*ell)'*invL_now*(u-alpha*ONE_N-beta*ell);
    sumk_prp=(u-alpha*ONE_N-beta*ell)'*invL_prp*(u-alpha*ONE_N-beta*ell);
        
 	ins_now=-1/(2*HP.zeta_tilde_rho_2)*(Rho_now-HP.eta_tilde_rho)^2-1/(2*omega_2)*sumk_now;
   	ins_prp=-1/(2*HP.zeta_tilde_rho_2)*(Rho_prp-HP.eta_tilde_rho)^2-1/(2*omega_2)*sumk_prp;
  	MetFrac=det(L_prp*invL_now)^(-1/2)*exp(ins_prp-ins_now);
   	success_rate=min(1,MetFrac);
   	if rand(1)<=success_rate
     	Rho_now=Rho_prp; 
    end
  	rho=exp(Rho_now);
  	clear Rho_now Rho_std Rho_prp mat_now mat_prp ins_* sumk MetFrac success_rate L_*

    % redefine matrices because you just updated omega_2 and rho
    OmegaMat=omega_2*exp(-rho*D); invOmegaMat=inv(OmegaMat);
    TMat=exp(-rho*D); invTMat=inv(TMat);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sample from p(alpha|.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    alpha=0;
    clear V_ALPHA PSI_ALPHA  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sample from p(beta|.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    beta=0;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sample from p(v|.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    v=x; % don't include additional observational error

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sample from p(u|.)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   	V_U=[]; PSI_U=[]; 
    V_U=invOmegaMat*(alpha*ONE_N+beta*ell)+v/epsilon_2;
    PSI_U=inv(invOmegaMat+I_N/epsilon_2);
    u=mvnrnd(PSI_U*V_U,PSI_U)';
    clear V_U PSI_U
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Now update arrays
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    update_all_arrays3

end
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% delete the burn-in period values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete_burn_in3

%%%%%%%%%%%%%
% save output
%%%%%%%%%%%%%
if exist('bayes_model_solutions/')==0
    mkdir bayes_model_solutions/
end
save(['bayes_model_solutions/experiment_',save_name,'.mat'],...
    'U','V','ALPHA','BETA','RHO','OMEGA_2','EPSILON_2','HP','LON','LAT','ell')