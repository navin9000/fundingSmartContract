//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

//contract for crowdfunding

contract Funding{
    //uint public fundAmt;
    mapping(address => uint) investors;
    address payable manager;
    uint public totalAmt;
    uint public noOfInvestors;
    uint public goalAmt;
    uint public goalTime;
    uint endTime;
    uint startTime;


    //constructor for intializing manager 
    constructor(uint _amt,uint _time){
        goalAmt=_amt;
        goalTime=_time;
        endTime=block.timestamp + goalTime;     
        manager=payable(msg.sender); //contract ---> deploy address 
    }

    //getting fund amount to contract and checking for the conditions to met
    //the first and last person who is investing can invest more than required
    function toGetFunds() public payable {
        require(manager!=msg.sender); 
        require(msg.value > 0 wei,"not enough funds"); 
        require(block.timestamp < endTime,"funding pool expired");    //20  < 20 endTime
        require(amntRequired() > 0,"funding goal reached"); //accepting investors. // 50 wei -->30 wei  = 50-30= 
        investors[msg.sender]=msg.value;
        totalAmt+=msg.value;
        noOfInvestors+=1; //rewards
    }

    //there are two outcomes for our project
    // 1.successful funding   2.failed funding 
   
    //1.If successful funding 
    // so funds will transfer to the fund raiser
    function transferFundsToManager() public{
        require(block.timestamp > endTime); 
        require(totalAmt >= goalAmt);
        manager.transfer(address(this).balance);
    }

    //2.If the funding is failed
    //here refunding the funds to the investors if funding goal is not reached
    function reFundingToInvestors() public view { //10eth        1,1,1,
        require(block.timestamp > endTime);
        require(totalAmt < goalAmt);

    }

    //to check the amount required
    function amntRequired()public view returns(uint a){
        if(totalAmt < goalAmt){
            return (goalAmt-totalAmt);
        }
        return 0;
    }

}

