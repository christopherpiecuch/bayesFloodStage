%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize_output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
U = nan(NN_thin,N);         % Vector of regional  
V = nan(NN_thin,N);         % Total vector
ALPHA = nan(NN_thin,1);     % Mean non-GIA VLM rate
BETA = nan(NN_thin,1);     % Mean non-GIA VLM rate
OMEGA_2 = nan(NN_thin,1);   % Partial sill of regional VLM rate
RHO = nan(NN_thin,1);       % non-GIA VLM rate inverse range
EPSILON_2 = nan(NN_thin,1); % Variance in tide gauge data biases
