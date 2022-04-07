% Using BankAccount Objects
close all
clear

BA = pkgBank.BankAccount(123456,500);
BA.qSave;
withdraw(BA,200);
BA.getStatement;
BA.qLoad;
BA.getStatement;
withdraw(BA,600);
BA.getStatement;
BA.qSave;
deposit(BA,200)
BA.getStatement;
BA.qLoad;
BA.getStatement;

