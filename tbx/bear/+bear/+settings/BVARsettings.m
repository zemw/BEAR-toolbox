classdef BVARsettings < bear.settings.BASEsettings
    %BVARSETTINGS Panel VAR settings class
    %   The bear.settings.BVARsettings class is a class that creates a
    %   settings object to run a Bayesian VAR. It can be created directly by
    %   running:
    %
    %   bear.settings.BVARsettings(ExcelPath, varargin)
    %
    %   or in its more convenient form:
    %
    %   BEARsettings('bvar', ExcelPath = 'path/To/file.xlsx')
    %
    % BVARsettings Properties:
    %    prior           - Selected prior
    %    ar              - auto-regressive coefficients
    %    PriorExcel      - Select individual priors
    %    priorsexogenous - Gibbs sampler burn-in iterations
    %    lambda1         - hyperparameter
    %    lambda2         - hyperparameter
    %    lambda3         - hyperparameter
    %    lambda4         - hyperparameter
    %    lambda5         - hyperparameter
    %    lambda6         - hyperparameter
    %    lambda7         - hyperparameter
    %    lambda8         - hyperparameter
    %    It              - Gibbs sampler iterations
    %    Bu              - Gibbs sampler burn-in iterations
    %    hogs            - grid search
    %    bex             - block exogeneity
    %    scoeff          - apply sum of coefficients
    %    iobs            - initial observation
    %    lrp             - Long run prior option
    %    priorf          - scale of prior of factor f
    %    strctident      - strctident
    %    alpha0          - hyperparameter
    
    properties    
        % Selected prior:
        % 11=Minnesota (univariate AR), 12=Minnesota (diagonal VAR estimates), 13=Minnesota (full VAR estimates)
        % 21=Normal-Wishart(S0 as univariate AR), 22=Normal-Wishart(S0 as identity)
        % 31=Independent Normal-Wishart(S0 as univariate AR), 32=Independent Normal-Wishart(S0 as identity)
        % 41=Normal-diffuse
        % 51=Dummy observations
        % 61=Mean-adjusted
        prior (1,1) bear.PRIORtype = 61;
        % hyperparameter: autoregressive coefficient
        ar=0.8; % this sets all AR coefficients to the same prior value (if PriorExcel is equal to 0)
        % switch to Excel interface
        PriorExcel=0; % set to 1 if you want individual priors, 0 for default
        %switch to Excel interface for exogenous variables
        priorsexogenous=0; % set to 1 if you want individual priors, 0 for default
        % hyperparameter: lambda1
        lambda1=10000;
        % hyperparameter: lambda2
        lambda2=0.5;
        % hyperparameter: lambda3
        lambda3=1;
        % hyperparameter: lambda4
        lambda4=1;
        % hyperparameter: lambda5
        lambda5=0.001;
        % hyperparameter: lambda6
        lambda6=1;
        % hyperparameter: lambda7
        lambda7=0.1;
        % Overall tightness on the long run prior
        lambda8=1;
        % total number of iterations for the Gibbs sampler
        It=1000;
        % number of burn-in iterations for the Gibbs sampler
        Bu=500;
        % hyperparameter optimisation by grid search (1=yes, 0=no)
        hogs (1,1) logical = 0;
        % block exogeneity (1=yes, 0=no)
        bex (1,1) logical = 0;
        % sum-of-coefficients application (1=yes, 0=no)
        scoeff=0;
        % dummy initial observation application (1=yes, 0=no)
        iobs=0;
        % Long run prior option
        lrp=0;        
        % create H matrix for the long run priors
        % now taken from excel loadH.m
        % H=[1 1 0 0;-1 1 0 0;0 0 1 1;0 0 -1 1];
        % (61=Mean-adjusted BVAR) Scale up the variance of the prior of factor f
        priorf=100;        
        % strctident
        strctident
        % hyperparameter: alpha0 Setting or result?
        alpha0=1000;
    end
    
    methods
        
        function obj = BVARsettings(excelPath, varargin)

            obj@bear.settings.BASEsettings(2, excelPath)

            obj = obj.setStrctident(obj.IRFt);
            
            obj = parseBEARSettings(obj, varargin{:});
            
        end
        
    end

    methods (Access = protected)

        function obj = checkIRFt(obj, value)
            % we could call superclass method to combine effect
            obj = checkIRFt@bear.settings.BASEsettings(obj, value);
            obj = obj.setStrctident(value);
        end
        
    end

    methods (Access = private)

        function obj = setStrctident(obj, value)
            
            switch value
                case 4
                    obj.strctident = bear.settings.StrctidentIRFt4;
                case 5                    
                    obj.strctident = bear.settings.StrctidentIRFt5;
                case 6
                    obj.strctident = bear.settings.StrctidentIRFt6;                
                otherwise
                    obj.strctident = bear.settings.Strctident.empty();
            end
            
        end

    end
end