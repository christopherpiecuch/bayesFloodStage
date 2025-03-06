%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set_initial_values2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%v

% mean parameters
alpha=[];
beta=[];
%%% alpha=normrnd(HP.eta_tilde_alpha,sqrt(HP.zeta_tilde_alpha_2));
%%% beta=normrnd(HP.eta_tilde_beta,sqrt(HP.zeta_tilde_beta_2));
alpha=0;
beta=0;

% variance parameters
omega_2=min([var(x) 1/randraw('gamma', [0,1/HP.chi_tilde_omega_2,HP.xi_tilde_omega_2], [1,1])]); % use min to prevent needlessly large values
epsilon_2=min([var(x) 1/randraw('gamma', [0,1/HP.chi_tilde_epsilon_2,HP.xi_tilde_epsilon_2], [1,1])]); % use min to prevent needlessly large values

% inverse length scale parameters
rho=exp(normrnd(HP.eta_tilde_rho,sqrt(HP.zeta_tilde_rho_2)));

% spatial fields
u=x;        
%u=(mvnrnd(alpha*ones(N,1),omega_2*exp(-rho*D)));        
v=x;        
%ug=(mvnrnd(HP.eta_tilde_ug,HP.delta_tilde_ug_2))';