// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract VerificationOrg {
    struct Org {
        address OrgAccount;
        string OrgName;
        bytes32 QualifyDocDLID;//dataLayerNameHash
        uint32 Status; //1-init 2-accepted 3-reject
        string[] TaskList; //UUID string list
    }

    mapping(address => Org) _mapOrgs;
    address[] public OrgList;

    address public _owner;

    event ApprovalStatusChanged(address OrgAccount, uint32 Status);

    constructor () public {
        _owner = msg.sender;
    }

    function submitApply(address _OrgAccount, string memory _OrgName, bytes32 _QualifyDocDLID) public
    {
        require(msg.sender == _owner, 'Caller must be owner');
        require(bytes(_mapOrgs[_OrgAccount].OrgName).length == 0, "Org already exist");
        require(bytes(_OrgName).length > 0, "Invalid org name");
        require(_OrgAccount != address(0), "Invalid org account");

        _mapOrgs[_OrgAccount] = Org(_OrgAccount,_OrgName,_QualifyDocDLID,1,new string[](0));

        OrgList.push(_OrgAccount);
    }

    function acceptApply(address _OrgAccount) public
    {
        require(msg.sender == _owner, 'Caller must be owner');
        require(_OrgAccount != address(0), "Invalid org account address");
        require(bytes(_mapOrgs[_OrgAccount].OrgName).length > 0, "ORG not found");

        _mapOrgs[_OrgAccount].Status = 2;
        emit ApprovalStatusChanged(_OrgAccount, 2);
    }

    function rejectApply(address _OrgAccount) public
    {
        require(msg.sender == _owner, 'Caller must be owner');
        require(_OrgAccount != address(0), "Invalid org account address");
        require(bytes(_mapOrgs[_OrgAccount].OrgName).length > 0, "ORG not found");

        _mapOrgs[_OrgAccount].Status = 3;
        emit ApprovalStatusChanged(_OrgAccount, 3);
    }

    function addTask(address _OrgAccount, string memory _TaskID) public
    {
        //require(msg.sender == _owner, 'Caller must be owner');//only called by task contract
        require(_OrgAccount != address(0), "Invalid org account address");
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapOrgs[_OrgAccount].OrgName).length > 0, "Org not found");
        require(_mapOrgs[_OrgAccount].Status == 2, "Org not be accepted");

        bool bcontain = false;
        for (uint256 i = 0; i < _mapOrgs[_OrgAccount].TaskList.length; i++) {
            if (_compareStringsbyBytes(_mapOrgs[_OrgAccount].TaskList[i], _TaskID)) {
                    bcontain = true;
                    break;
                }
        }
        if(false == bcontain)
            _mapOrgs[_OrgAccount].TaskList.push(_TaskID);
    }

    function getOrgInfo(address _OrgAccount) external view returns (string memory _OrgName,
        bytes32 _QualifyDocDLID, uint32 _Status,string[] memory _TaskList)
    {
        require(_OrgAccount != address(0), "Invalid org account address");
        require(bytes(_mapOrgs[_OrgAccount].OrgName).length > 0, "Org not found");

        return (_mapOrgs[_OrgAccount].OrgName,_mapOrgs[_OrgAccount].QualifyDocDLID,
            _mapOrgs[_OrgAccount].Status,_mapOrgs[_OrgAccount].TaskList);
    }

    function isOrgOK(address _OrgAccount) external view returns (bool)
    {
        require(_OrgAccount != address(0), "Invalid org account address");
        if(_mapOrgs[_OrgAccount].Status == 2)
            return true;
        else
            return false;
    }

    //helper function
    function _compareStringsbyBytes(string memory s1, string memory s2) internal pure returns (bool){
        return keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}
