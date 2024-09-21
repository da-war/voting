// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Proposal {
        uint id;
        string name;
        uint voteCount;
    }
    
    address public owner;
    mapping(address => bool) public voters;
    mapping(uint => Proposal) public proposals;
    mapping(address => uint) public votes;
    uint public proposalsCount;
    uint public totalVotes;

    event ProposalCreated(uint id, string name);
    event Voted(uint proposalId, address voter);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    modifier hasNotVoted() {
        require(votes[msg.sender] == 0, "You have already voted");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function createProposal(string memory _name) public onlyOwner {
        proposalsCount++;
        proposals[proposalsCount] = Proposal(proposalsCount, _name, 0);
        emit ProposalCreated(proposalsCount, _name);
    }
    
    function vote(uint _proposalId) public hasNotVoted {
        require(_proposalId > 0 && _proposalId <= proposalsCount, "Invalid proposal ID");
        
        Proposal storage proposal = proposals[_proposalId];
        proposal.voteCount++;
        votes[msg.sender] = _proposalId;
        totalVotes++;
        
        emit Voted(_proposalId, msg.sender);
    }
    
    function getProposal(uint _proposalId) public view returns (string memory name, uint voteCount) {
        require(_proposalId > 0 && _proposalId <= proposalsCount, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.name, proposal.voteCount);
    }
    
    function getUserVote() public view returns (uint proposalId) {
        return votes[msg.sender];
    }
    
    function getTotalVotes() public view returns (uint) {
        return totalVotes;
    }
}
