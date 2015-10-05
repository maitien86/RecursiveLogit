....
%   Link-based Recursive logit estimator
%   TIEN MAI and EMMA FREJINGER - DIRO
%   29 - July - 2013
%   MAIN PROGRAM
%   ---------------------------------------------------

%% BEGIN
Credits;
%% Email notification
global resultsTXT; 
notifyMail('set','xxx@gmail.com','xxx');

%% Variables
global file_AttEstimatedtime;
global file_linkIncidence;
global file_observations;
global file_turnAngles;
global nbobs;      
global Op;
global isLinkSizeInclusive;
global isFixedUturn;
global Gradient;

isLinkSizeInclusive = false;
isFixedUturn = false;

%% Borlange data
file_linkIncidence = './Input/linkIncidence.txt';
file_AttEstimatedtime = './Input/ATTRIBUTEestimatedtime.txt';
file_turnAngles = './Input/ATTRIBUTEturnangles.txt';
file_observations = './Input/SyntheticObservations.txt';

loadData;

%% Initialize the optimization structure
Op = Op_structure;
initialize_optimization_structure();
Op.Optim_Method = OptimizeConstant.TRUST_REGION_METHOD; % Optimization algorithm
Op.Hessian_approx = OptimizeConstant.BHHH; % Hessian approximation
Gradient = zeros(nbobs,Op.n);

% Generate Observations
% createSimulatedObs;
% file_observations = './simulatedData/ObservationsAll.txt';
% loadData;

%% Starting optimization
tic ;
disp('Optimizing ....')
[Op.value, Op.grad ] = getLL();
PrintOut(Op);
% Output
header = [sprintf('%s \n',file_observations) Op.Optim_Method];
header = [header sprintf('\n Number of observations = %d \n', nbobs)];
header = [header sprintf(' Hessian approx methods = %s \n', OptimizeConstant.getHessianApprox(Op.Hessian_approx))];
resultsTXT = header;
%% Loop
while (true)    
  Op.k = Op.k + 1;
  if strcmp(Op.Optim_Method,OptimizeConstant.LINE_SEARCH_METHOD);
    ok = line_search_iterate();
    if ok == true
        PrintOut(Op);
    else
        disp(' Unsuccessful process ...')
        break;
    end
  else
    ok = btr_interate();
    PrintOut(Op);
  end
  [isStop, Stoppingtype, isSuccess] = CheckStopping(Op);  
  %% Check stopping criteria
  if(isStop == true)
      isSuccess
      fprintf('The algorithm stops, due to %s', Stoppingtype);
      resultsTXT = [resultsTXT sprintf('The algorithm stops, due to %s \n', Stoppingtype)];
      break;
  end
end
%%   Compute Variance - Covariance matrix
getCov;
%% DONE
ElapsedTtime = toc
resultsTXT = [resultsTXT sprintf('\n Number of function evaluation %d \n', Op.nFev)];
resultsTXT = [resultsTXT sprintf('\n Estimated time %d \n', ElapsedTtime)];
%% Send email notification
try
   notifyMail('send', resultsTXT);
catch exection
   fprintf('\n Can not send email notification !!! \n');
end

%% END