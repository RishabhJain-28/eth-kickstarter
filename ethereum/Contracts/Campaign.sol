pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;

    function createCampaign(uint256 minContri) public {
        address newCampaign = new Campaign(minContri, msg.sender);
        deployedCampaigns.push(newCampaign);
    }

    function getDeployedCampaigns() public view returns (address[]) {
        return deployedCampaigns;
    }
}

// 10000000000000000
contract Campaign {
    struct Request {
        string description;
        uint256 value;
        address recipient;
        bool complete;
        mapping(address => bool) approvals;
        uint256 approvalCount;
    }

    address public manager;
    mapping(address => bool) public approvers;
    uint256 public approversCount;
    uint256 public minimumContribution;

    Request[] public requests;

    function Campaign(uint256 minContri, address creator) public {
        manager = creator;
        minimumContribution = minContri;
    }

    function contribute() public payable {
        require(msg.value >= minimumContribution);
        approvers[msg.sender] = true;
        approversCount++;
    }

    function createRequest(
        string desc,
        uint256 value,
        address recipient
    ) public restricted {
        Request memory newRequest = Request({
            description: desc,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });

        requests.push(newRequest);
    }

    function approveRequests(uint256 requestIndex) public payable {
        Request storage request = requests[requestIndex];

        require(approvers[msg.sender]);
        require(!request.approvals[msg.sender]);

        requests[requestIndex].approvals[msg.sender] = true;
        requests[requestIndex].approvalCount++;
    }

    function finalizeRequest(uint256 reqIndex) public restricted {
        Request storage request = requests[reqIndex];

        require(!request.complete);
        require(request.approvalCount > approversCount / 2);

        request.recipient.transfer(request.value);
        request.complete = true;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
}
