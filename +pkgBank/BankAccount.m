% The BankAccount class determines the status of all bank accounts.
% Classes store data in properties, implement operations with methods, and support
% notifications with events and listeners.
classdef BankAccount < handle
    % handle class vs. value class(without < handle)
    % the copies of a handle object are the same object,
    % but the copies of a value object are independent objects.
    properties (Access = ?pkgBank.AccountManager)
        % AccountStatus property access by AccountManager class methods.
        AccountStatus = 'open'
    end
    
    properties (SetAccess = private)
        % AccountNumber and AccountBalance properties have private set access.
        AccountNumber
        AccountBalance
    end
    properties (Transient)
        % AccountListener property is transient so the listener handle is not saved.
        AccountListener
    end
    
    events
        InsufficientFunds
    end
    
    methods
        function BA = BankAccount(AccountNumber,InitialBalance)
            BA.AccountNumber = AccountNumber;
            BA.AccountBalance = InitialBalance;
            BA.AccountListener = pkgBank.AccountManager.addAccount(BA);
        end
        
        function deposit(BA,amt)
            BA.AccountBalance = BA.AccountBalance + amt;
            if BA.AccountBalance > 0
                BA.AccountStatus = 'open';
            end
        end
        
        function withdraw(BA,amt)
            if (strcmp(BA.AccountStatus,'closed')&& ...
                    BA.AccountBalance < 0)
                disp(['Account ',num2str(BA.AccountNumber),...
                    ' has been closed.'])
                return
            end
            newbal = BA.AccountBalance - amt;
            BA.AccountBalance = newbal;
            if newbal < 0
                % notify triggers InsufficentFunds event.
                notify(BA,'InsufficientFunds')
            end
        end
        
        function getStatement(BA)
            disp('-------------------------')
            disp(['Account: ',num2str(BA.AccountNumber)])
            ab = sprintf('%0.2f',BA.AccountBalance);
            disp(['CurrentBalance: ',ab])
            disp(['Account Status: ',BA.AccountStatus])
            disp('-------------------------')
        end
    end
    
    methods
        % For this pattern, define saveobj as an ordinary method that accepts an object of the class and returns a struct.
        function s = saveobj(obj)
            s.AccountNumber = obj.AccountNumber;
            s.AccountBalance = obj.AccountBalance;
        end
        
        function qSave(obj)
            qobj = obj;
            if exist('savedata','dir')==0
                mkdir savedata;
            end
            save savedata\fSave qobj;
        end
        
        function qLoad(obj)
            load savedata\fSave qobj;
            obj.AccountNumber = qobj.AccountNumber;
            if obj.AccountBalance ~= qobj.AccountBalance
                obj.AccountBalance = qobj.AccountBalance;
                % notify triggers InsufficentFunds event.
                notify(obj,'InsufficientFunds') 
            end
        end
    end
    methods (Static)
        % When an error occurs while an object is being loaded from a file, MATLAB does one of the following:
        % 1. If the class defines a loadobj method, MATLAB returns the saved values to the loadobj method in a struct.
        % 2. If the class does not define a loadobj method, MATLAB silently ignores the errors.
        function obj = loadobj(s)
            if isstruct(s)
                accNum = s.AccountNumber;
                initBal = s.AccountBalance;
                obj = pkgBank.BankAccount(accNum,initBal);
            elseif isa(s,'BankAccount')
                obj = s;
            else
                error('Uncompatible loading object.')
            end
        end
    end
end
