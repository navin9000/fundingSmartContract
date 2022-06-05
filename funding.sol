//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

//contract for crowdfunding

contract Funding{
    //uint public fundAmt;
    mapping(address => uint) investors;
    address[] allAddresses;
    address payable manager;
    uint public totalAmt;
    uint public noOfInvestors;
    uint public goalAmt;
    uint public goalTime;


    //constructor for intializing manager 
    constructor(){
        manager=payable(msg.sender);
    }

    //getting fund amount to contract
    function toGetFunds() public payable{
        require(manager!=msg.sender);
        if(totalAmt==goalAmt){ //here we checking ,reached the goal before or on time 
            transferFundsToManager();//so transfering the funds to the manger address 
        }
        else{
            investors[msg.sender]=msg.value;
            allAddresses[noOfInvestors]=msg.sender;
            totalAmt+=msg.value;
            noOfInvestors+=1;
        }
    }

    
    // transfering funds to the manager 
    function transferFundsToManager() private {
        manager.transfer(address(this).balance);
    }
   //to check the details of manager 
   function managerDetails() public view returns(address ,uint ){
       return(manager,manager.balance);
   }

   //to check the contract address and balance
   function contractDetails() public view returns(address,uint ){
       return(address(this),address(this).balance);
   }


}