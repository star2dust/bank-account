% The purpose of the AccountManager class is to provide services to accounts. 
% For the BankAccount class, the AccountManager class listens for withdrawals 
% that cause the balance to drop into the negative range.
classdef AccountManager
    methods (Static)
        function assignStatus(BA)
            if BA.AccountBalance < 0
                if BA.AccountBalance < -200
                    BA.AccountStatus = 'closed';
                else
                    BA.AccountStatus = 'overdrawn';
                end
            end
        end
        function lh = addAccount(BA)
            % Creates listener for InsufficientFunds event and stores
            % listener handle in AccountListener property.
            lh = addlistener(BA, 'InsufficientFunds', ...
                @(src, ~)pkgBank.AccountManager.assignStatus(src));
        end
    end
end
