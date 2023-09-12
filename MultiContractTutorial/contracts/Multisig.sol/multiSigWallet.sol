// SPDX-License-Identifier ""
pragma solidity ^0.8.22;

contract MultiSigWallet {
    address[] public owners;
    uint public numConfirmationRequired;

//transaction structure
struct Transaction
{
    address to;
    uint value;
    bool executed;
}

//all pending transactions
Transaction[] public transactions;

//mapping to track confirmation
mapping(uint => mapping(address => bool)) public confirmations;

constructor(address[] memory _owners, uint _numConfirmationRequired)
{
    require( _owners.length >0, "Owners list cannot be empty");
    require( _numConfirmationRequired > 0 && _numConfirmationRequired <= _owners.length,
    "Invalid number of confirmation required");

    owners = _owners;
    numConfirmationRequired = _numConfirmationRequired;
}

//modifier to ensure that the only owners cna call some functions
modifier onlyOwners()
{
    bool isOwner = false;
    for (uint i = 0; < owner.length; i++)
    {
        if(msg.sender == owners[i])
        {
            isOwner = true;
            break;
        }
    }
    require(isOwner, "Only owner can call this function");
}

//to submit a transaction by owner
function submitTrans(address _to, uint _value) public onlyOwners 
{
    require(_to != address(0), "Invalid destination");
    uint transactionId = transactions.length;
    transactions.push(Transaction({
        to: _to,
        value = _value,
        executed: false,
    }));
    confirmationTransaction(transactionId);
}

//confirm a transaction
function confirmTransaction(uint _trasactionId) public onlyOwner
{
    require(_transactionId < transaction.length, "Invalid transaction Id");
    require(!confirmations[_transactionId][msg.sender], "Transaction Valid");
    confirmations[_transactionId][msg.sender] = true;

    if(isTransactionConfirmed(_transactionId))
    {
        executeTransaction(_transactionId);
    }
}

//check if a transaction is confirmed by many owners
function isTransactionConfirmed(uint _transactionId) public view returns (bool){
    uint count = 0;
    for (uint i = 0; i < owners.length; i++)
    {
        if(confirmations[_transactionId][owner[i]]) 
        {
            count++;
        }
        if(count >=numConfirmationRequired) 
        {
            return true;
        }
    }
    return false;
}

//execute a confirmed transaction
function executeTransaction(uint _transactionId) internal 
{
require(_transactionId < transaction.length, "Invalid Transaction Id");
require(!transactions[_transactionId].executed, "Transaction already executed");
require(isTransactionConfirmed(_transactionId),"Transaction not yet confirmed");
Transaction storage transaction = transactions[_transaction];
transaction.executed = true;
(bool success) = transaction.to.call{value: transaction.value}("");
require(success, "Transaction execution failed");
}
}