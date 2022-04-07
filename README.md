# Bank-Account

An implement of the status of bank accounts. It is an exercise of events and listener construction.

## Description
- BankAccount class

The BankAccount class determines the status of all bank accounts.
Classes store data in properties, implement operations with methods, and support notifications with events and listeners.

- AccountManager class

The purpose of the AccountManager class is to provide services to accounts. 
For the BankAccount class, the AccountManager class listens for withdrawals that cause the balance to drop into the negative range.

- using_bankaccount_example.m

An example to test the BankAccount package.
