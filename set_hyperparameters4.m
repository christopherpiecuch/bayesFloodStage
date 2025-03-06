%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function HP = set_hyperparameters4(DATA)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% See "Piecuch_model_description.pdf" for rationale behind the priors 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
u = DATA;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set variance inflation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var_infl=5^2;
var_infl2=10^2;
var0_infl=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the hyperparameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alpha
% see lines 29-32 in "Piecuch_model_description.pdf"
HP.eta_tilde_alpha = nanmean(u); % Mean of alpha prior
HP.zeta_tilde_alpha_2 = var0_infl*nanvar(u); % Variance of alpha prior

% beta
HP.eta_tilde_beta = 0; % Mean of alpha prior
HP.zeta_tilde_beta_2 = (0.1)^2; % Variance of alpha prior

% omega_2
% see lines 92-94 in "Piecuch_model_description.pdf"
HP.xi_tilde_omega_2 = 1/2; % Shape of tau_2 prior
HP.chi_tilde_omega_2 = 1/2*nanvar(u); % 

% epsilon_2
% see lines 89-91 in "Piecuch_model_description.pdf"
HP.xi_tilde_epsilon_2 = 1/2; % Shape of tau_2 prior
HP.chi_tilde_epsilon_2 = 1/2*nanvar(u); % Guess (1 mm/yr)^2 error variance

% rho (this one's constrained; 95% within 49 , 2673 km)
% see lines 58-61 in "Piecuch_model_description.pdf"
HP.eta_tilde_rho = -5.9; % "Mean" of phi prior
HP.zeta_tilde_rho_2 = (1)^2; % "Variance" of phi prior

return
