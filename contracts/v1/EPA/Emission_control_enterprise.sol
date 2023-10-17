// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract EmissionControlEnterprise {
    struct Enterprise {
        address EnterpriseAccount;
        string EnterpriseName;
        bytes32 EnterpriseDocDLID;//dataLayerNameHash
        uint32 Status; //1-init 2-accepted 3-reject
        string[] TaskList; //UUID string list
    }

    mapping(address => Enterprise) _mapEnterprises;
    address[] public EnterpriseList;

    address public _owner;

    address public _taskContractAddr;

    event ApprovalStatusChanged(address EnterpriseAccount, uint32 Status);

    constructor () public {
        _owner = msg.sender;
    }

    function submitApply(address _EnterpriseAccount, string memory _EnterpriseName, bytes32 _EnterpriseDocDLID) public
    {
        require(msg.sender == _owner, 'Caller must be owner');
        require(bytes(_mapEnterprises[_EnterpriseAccount].EnterpriseName).length == 0, "Enterprise already exist");
        require(bytes(_EnterpriseName).length > 0, "Invalid enterprise name");
        require(_EnterpriseAccount != address(0), "Invalid enterprise account");

        _mapEnterprises[_EnterpriseAccount] = Enterprise(_EnterpriseAccount,_EnterpriseName,_EnterpriseDocDLID,1,new string[](0));

        EnterpriseList.push(_EnterpriseAccount);
    }

    function acceptApply(address _EnterpriseAccount) public
    {
        require(msg.sender == _owner, 'Caller must be owner');
        require(_EnterpriseAccount != address(0), "Invalid enterprise account address");
        require(bytes(_mapEnterprises[_EnterpriseAccount].EnterpriseName).length > 0, "Enterprise not found");

        _mapEnterprises[_EnterpriseAccount].Status = 2;
        emit ApprovalStatusChanged(_EnterpriseAccount, 2);
    }

    function rejectApply(address _EnterpriseAccount) public
    {
        require(msg.sender == _owner, 'Caller must be owner');
        require(_EnterpriseAccount != address(0), "Invalid enterprise account address");
        require(bytes(_mapEnterprises[_EnterpriseAccount].EnterpriseName).length > 0, "Enterprise not found");

        _mapEnterprises[_EnterpriseAccount].Status = 3;
        emit ApprovalStatusChanged(_EnterpriseAccount, 3);
    }

    function addTask(address _EnterpriseAccount, string memory _TaskID) public
    {
        //require(msg.sender == _owner, 'Caller must be owner'); //only called by task contract
        require(_EnterpriseAccount != address(0), "Invalid enterprise account address");
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapEnterprises[_EnterpriseAccount].EnterpriseName).length > 0, "Enterprise not found");
        require(_mapEnterprises[_EnterpriseAccount].Status == 2, "Enterprise not be accepted");

        bool bcontain = false;
        for (uint256 i = 0; i < _mapEnterprises[_EnterpriseAccount].TaskList.length; i++) {
            if (_compareStringsbyBytes(_mapEnterprises[_EnterpriseAccount].TaskList[i], _TaskID)) {
                    bcontain = true;
                    break;
                }
        }
        if(false == bcontain)
            _mapEnterprises[_EnterpriseAccount].TaskList.push(_TaskID);
    }

    function getEnterpriseInfo(address _EnterpriseAccount) external view returns (string memory _EnterpriseName,
        bytes32 _QualifyDocDLID, uint32 _Status,string[] memory _TaskList)
    {
        require(_EnterpriseAccount != address(0), "Invalid enterprise account address");
        require(bytes(_mapEnterprises[_EnterpriseAccount].EnterpriseName).length > 0, "Enterprise not found");

        return (_mapEnterprises[_EnterpriseAccount].EnterpriseName,_mapEnterprises[_EnterpriseAccount].EnterpriseDocDLID,
            _mapEnterprises[_EnterpriseAccount].Status,_mapEnterprises[_EnterpriseAccount].TaskList);
    }

    function isEnterpriseOK(address _EnterpriseAccount) external view returns (bool)
    {
        require(_EnterpriseAccount != address(0), "Invalid enterprise account address");
        if(_mapEnterprises[_EnterpriseAccount].Status == 2)
            return true;
        else
            return false;
    }

    //helper function
    function _compareStringsbyBytes(string memory s1, string memory s2) internal pure returns (bool){
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}
