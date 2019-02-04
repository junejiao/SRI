function [SRI,Days] = SRI_calculator(W,n)
% Function for calculating sleep regularity from scored epoch-by-epoch sleep data.
% 
% [SRI,Days] = SRI_calculator(W,n)
%
% OUTPUTS:
%
% SRI = The Sleep Regularity Index (SRI)
%
% * This metric ranges from 0 (random) to 100 (perfectly repeating). 
%
% * See Phillips et al. (2017) Sci Reports for description and use of the metric. 
% 
% * A typical population range is ~30-90. 
%
% * Negative values are theoretically possible, but usually do not
% occur outside of highly contrived circumstances 
% (negative values should be checked, as they may indicate bad data).
% 
% Days = The number of valid days of data used in the computation (i.e.,
% the total non-missing overlap between the sleep/wake time series and
% itself shifted by 24 hours). 
%
% * If there are no missing data, the value of
% Days will be the number of days recorded minus 1.
%
% * For days<5, SRI is unlikely to be a reliable estimator for sleep regularity and you may wish to exclude the participant.
%
% INPUTS:
%
% W = Scored wake/sleep state on epoch-by-epoch basis. This can potentially
% be obtained from diaries, actigraphy, PSG, or any other method that
% scores sleep/wake state on an epoch-by-epoch basis. A time resolution of
% 15 minutes or better is recommended. There should be no jumps in time
% (use NaN values to fill in gaps if there are).
% 
% * W should be a vector composed of two numerical values, correponding to wake and
% sleep. E.g., 1=wake, 0=sleep; or 1=wake, -1=sleep; or 0=wake, 1=sleep. 
% Example W = [1,1,1,1,1,0,0,0,1,0,...]
% Any numerical scheme is fine, as long as it is consistent for the
% participant.
%
% * In cases of missing or excluded data, W should take a value of NaN (not a
% number).
%
% n = The number of epochs per 24 hours. For example, if the data are
% scored on a 1-minute basis, n=24*60=1440.
%
% Code written by AJK Phillips, last updated 8/2018

%% Perform computations

if length(unique(W(find(W>-Inf))))==2 % First check there are only two types of numerical values in the file

W1 = W(1:end-n); % Original time series (truncated)
W2 = W(1+n:end); % Time series shifted by 24 hours (truncated)

Cases = sum((W1.*W2)>-Inf); % Compute number of cases with valid data
Days = Cases/n; % Convert this to days

Matches = sum(W1==W2); % Compute number of matches for W1 and W2

SRI = 200*Matches/Cases-100; % Compute SRI (if Cases=Matches, SRI=100).

else % Display error message if necessary
    
    disp('Error: There are not two types of numerical values in W (either more or less).')
    SRI = NaN;
    Days = NaN;
    
end


