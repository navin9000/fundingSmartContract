//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

//contract for crowdfunding

contract Funding{
    //uint public fundAmt; 
    mapping(address => uint) investors;                   // investors history
    mapping(address => bool) aleardyInvestor;             // sotres aleardy investors history
    address payable manager;
    uint public totalAmt;
    uint public noOfInvestors;
    uint public goalAmt;
    uint public goalTime;
    uint endTime;
    uint startTime;

    //events
    event invested(address from,uint value);
    event toManager(address from,address to,uint value);
    event toInvsetors(address from,address to,uint value);
    
    // function modifier
     modifier checkInvestor{
        require(manager!=msg.sender); 
        require(msg.value > 0 wei,"not enough funds"); 
        require(block.timestamp < endTime,"funding pool expired");   
        require(amntRequired() > 0 ,"funding goal reached"); 
        _;
     }

     //function modifier fund to manger
     modifier fundToManager{
        require(block.timestamp > endTime); 
        require(totalAmt >= goalAmt);
        require(investors[msg.sender] <= 0,"claimed aleardy");
        _;
     }

     //function modifier funds back to investors
     modifier fundToInvestors{
        require(block.timestamp > endTime);
        require(totalAmt < goalAmt);
        _;
     }

    //constructor for intializing manager 
    //goal time in days
    constructor(uint _amt,uint _time){
        goalAmt=_amt;
        goalTime=_time;
        endTime=block.timestamp + (((goalTime*25)*60)*60);  // time in days as input    
        manager=payable(msg.sender);                        //contract ---> deploy address 
    }

    //getting fund amount to contract and checking for the conditions to met
    //the first and last person who is investing can invest more than required
    function toGetFunds() public payable checkInvestor{
        if(!aleardyInvestor[msg.sender]){                 // checks for new investors
            investors[msg.sender]=msg.value;
            totalAmt+=msg.value;
            noOfInvestors+=1;                             //number of investors here 
            aleardyInvestor[msg.sender]=true;             // adding him in the investors mapping
        }
        else{                                             // aleardy investors here works
            investors[msg.sender]=msg.value+investors[msg.sender];
            totalAmt+=msg.value;
        }
        emit invested(msg.sender,msg.value);
    }

    //there are two outcomes for our project
    // 1.successful funding   2.failed funding 
   
    //1.If successful funding 
    // so funds will transfer to the fund raiser
    function FundsToManager() public payable fundToManager{
        manager.transfer(address(this).balance);
        emit toManager(address(this),manager,address(this).balance);
    }

    //2.If the funding is failed
    //here refunding the funds to the investors if funding goal is not reached
    function reFundingToInvestors() public payable fundToInvestors{
        payable(msg.sender).transfer(investors[msg.sender]);
        emit toInvsetors(address(this),msg.sender,investors[msg.sender]);
        investors[msg.sender]=0;
    }


    //to check the amount required
    function amntRequired()public view returns(uint a){
        if(totalAmt < goalAmt){
            return (goalAmt-totalAmt);
        }
        return 0;
    }

}

