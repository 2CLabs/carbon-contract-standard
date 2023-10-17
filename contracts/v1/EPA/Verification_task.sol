// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "./Emission_control_enterprise.sol";
import "./Verification_org.sol";
import "./datalayer.sol";

contract VerificationTask {
    struct Task {
        string TaskID; //UUID string
        uint32 Status; //1-9
        address EnterpriseAccount;
        address VerificationOrgAccount;
        address ReviewOrgAccount;
        uint32 EnterpriseApprovalStatusForPlan; //1-init 2-accepted 3-reject
        uint32 GovernmentApprovalStatusForPlan; //1-init 2-accepted 3-reject
        uint32 FinalApprovalStatus; //1-init 2-accepted 3-reject
        bytes32 PlanDLID;//dataLayerNameHash
        bytes32 GasReportDLID;//dataLayerNameHash
        bytes32 UncomplianceListDLID;//dataLayerNameHash
        bytes32 UncomplianceEvidenceDLID;//dataLayerNameHash
        bytes32 VerifyReportDLID;//dataLayerNameHash
        bytes32 ReviewReportDLID;//dataLayerNameHash
        string[] updateTopicList; //what
        address[] updatePersonList; //who
        uint[] updateTimeList; //when: timestamp like 1683797787
    }

    mapping(string => Task) _mapTasks;
    string[] taskList; //too much if save

    address public _owner;

    string public Year; //one contract each year
    address VerificationOrgContractAddr;
    VerificationOrg public verificationOrgContract;
    address EmissionControlEnterpriseContractAddr;
    EmissionControlEnterprise public EmissionControlEnterpriseContract;
    address DataContractAddr;
    Data public DataLayerContract;

    event ApprovalStatusChanged(string TaskID, uint32 Status);

    constructor (string memory _Year,address _VerificationOrgContractAddr,
        address _EmissionControlEnterpriseContractAddr,address _DataContractAddr) public {
        require(bytes(_Year).length == 4, "Invalid year length"); //like 2023
        require(_VerificationOrgContractAddr != address(0), "Invalid VerificationOrg contract address");
        require(_EmissionControlEnterpriseContractAddr != address(0), "Invalid EmissionControlEnterprise contract address");
        require(_DataContractAddr != address(0), "Invalid DataLayer contract address");

        require(_VerificationOrgContractAddr != _EmissionControlEnterpriseContractAddr ,
                "VerificationOrg contract address should be different from EmissionControlEnterprise contract address");
        require(_VerificationOrgContractAddr != _DataContractAddr ,
                "VerificationOrg contract address should be different from DataLayer contract address");
        require(_EmissionControlEnterpriseContractAddr != _DataContractAddr ,
                "EmissionControlEnterprise contract address should be different from DataLayer contract address");

        verificationOrgContract = VerificationOrg(address(_VerificationOrgContractAddr));
        VerificationOrgContractAddr = _VerificationOrgContractAddr;
        EmissionControlEnterpriseContract = EmissionControlEnterprise(address(_EmissionControlEnterpriseContractAddr));
        EmissionControlEnterpriseContractAddr = _EmissionControlEnterpriseContractAddr;
        DataLayerContract = Data(address(_DataContractAddr));
        DataContractAddr = _DataContractAddr;
        Year = _Year;
        _owner = msg.sender;
    }

    function createTask(string memory _TaskID, address _EnterpriseAccount,
      address _VerificationOrgAccount) public
    {
        require(msg.sender == _owner, 'Caller must be owner');
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(_EnterpriseAccount != address(0), "Invalid Enterprise account");
        require(_VerificationOrgAccount != address(0), "Invalid Verification Org account");
        require(_EnterpriseAccount != _VerificationOrgAccount,"Enterprise account and Verification Org Account should be different");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 0, "Task already exist");

        bool isEnterpriseOK = EmissionControlEnterpriseContract.isEnterpriseOK(_EnterpriseAccount);
        if(!isEnterpriseOK){
            require(1 == 0, "Enterprise not exist in EmissionControlEnterpriseContract");
        }

        bool isOrgOK = verificationOrgContract.isOrgOK(_VerificationOrgAccount);
        if(!isOrgOK){
            require(1 == 0, "Verification Org not exist in verificationOrgContract");
        }

        _mapTasks[_TaskID] = Task(_TaskID,1,_EnterpriseAccount,
            _VerificationOrgAccount,address(0),
            1,1,1,
            bytes32(0),bytes32(0),bytes32(0),
            bytes32(0),bytes32(0),bytes32(0),
            new string[](0),new address[](0),new uint[](0));

        _mapTasks[_TaskID].updateTopicList.push("createTask");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);

        taskList.push(_TaskID);

        verificationOrgContract.addTask(_VerificationOrgAccount,_TaskID);
        EmissionControlEnterpriseContract.addTask(_EnterpriseAccount,_TaskID);
    }

    function submitPlan(string memory _TaskID, bytes32 _PlanDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 1 || _mapTasks[_TaskID].Status == 31 ||
             _mapTasks[_TaskID].Status == 41, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].VerificationOrgAccount, 'Caller must be VerificationOrg Account');

        _mapTasks[_TaskID].PlanDLID = _PlanDLID;
        _mapTasks[_TaskID].Status = 2;

        _mapTasks[_TaskID].updateTopicList.push("submitPlan");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function approvalOrRejectPlanByEnterprise(string memory _TaskID, bool _bApproval) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 2, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].EnterpriseAccount, 'Caller must be Enterprise Account');

        if(_bApproval)
        {
            _mapTasks[_TaskID].EnterpriseApprovalStatusForPlan = 2;
            _mapTasks[_TaskID].Status = 3;
        }
        else
        {
            _mapTasks[_TaskID].EnterpriseApprovalStatusForPlan = 3;
            _mapTasks[_TaskID].Status = 31;
        }

        _mapTasks[_TaskID].updateTopicList.push("approvalOrRejectPlanByEnterprise");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function approvalOrRejectPlanByGovernment(string memory _TaskID, bool _bApproval) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 2, "Invalid task status");
        require(msg.sender == _owner, 'Caller must be owner');

        if(_bApproval)
        {
            _mapTasks[_TaskID].GovernmentApprovalStatusForPlan = 2;
            _mapTasks[_TaskID].Status = 4;
        }
        else
        {
            _mapTasks[_TaskID].GovernmentApprovalStatusForPlan = 3;
            _mapTasks[_TaskID].Status = 41;
        }

        _mapTasks[_TaskID].updateTopicList.push("approvalOrRejectPlanByGovernment");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function submitGasReport(string memory _TaskID, bytes32 _GasReportDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 4, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].EnterpriseAccount, 'Caller must be Enterprise Account');

        _mapTasks[_TaskID].GasReportDLID = _GasReportDLID;
        _mapTasks[_TaskID].Status = 5;

        _mapTasks[_TaskID].updateTopicList.push("submitGasReport");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function verificationPassed(string memory _TaskID, bytes32 _VerifyReportDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 5 || _mapTasks[_TaskID].Status == 51, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].VerificationOrgAccount, 'Caller must be Verification Org Account');

        _mapTasks[_TaskID].VerifyReportDLID = _VerifyReportDLID;
        _mapTasks[_TaskID].Status = 6;

        _mapTasks[_TaskID].updateTopicList.push("verificationPassed");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function verificationReject(string memory _TaskID, bytes32 _UncomplianceListDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 5 || _mapTasks[_TaskID].Status == 51, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].VerificationOrgAccount, 'Caller must be Verification Org Account');

        _mapTasks[_TaskID].UncomplianceListDLID = _UncomplianceListDLID;
        _mapTasks[_TaskID].Status = 61;

        _mapTasks[_TaskID].updateTopicList.push("verificationReject");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function submitUncomplianceEvidence(string memory _TaskID, bytes32 _UncomplianceEvidenceDLID, bytes32 _GasReportDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 61, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].EnterpriseAccount, 'Caller must be Enterprise Account');

        _mapTasks[_TaskID].UncomplianceEvidenceDLID = _UncomplianceEvidenceDLID;
        _mapTasks[_TaskID].GasReportDLID = _GasReportDLID;
        _mapTasks[_TaskID].Status = 51;

        _mapTasks[_TaskID].updateTopicList.push("submitUncompliance");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function createReviewTask(string memory _TaskID, address _ReviewOrgAccount) public
    {
        require(msg.sender == _owner, 'Caller must be owner');
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(_ReviewOrgAccount != address(0), "Invalid Verification Org account");
        require(_mapTasks[_TaskID].Status == 6, "Invalid task status");

        bool isOrgOK = verificationOrgContract.isOrgOK(_ReviewOrgAccount);
        if(!isOrgOK){
            require(1 == 0, "Review Org not exist in verificationOrgContract");
        }

        _mapTasks[_TaskID].Status = 7;

        _mapTasks[_TaskID].updateTopicList.push("createReviewTask");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);

        verificationOrgContract.addTask(_ReviewOrgAccount,_TaskID);
    }

    function reviewPassed(string memory _TaskID, bytes32 _ReviewReportDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 7 || _mapTasks[_TaskID].Status == 71 ||
            _mapTasks[_TaskID].Status == 72, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].ReviewOrgAccount, 'Caller must be Review Org Account');

        _mapTasks[_TaskID].ReviewReportDLID = _ReviewReportDLID;
        _mapTasks[_TaskID].Status = 8;

        _mapTasks[_TaskID].updateTopicList.push("reviewPassed");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function reviewGasReportReject(string memory _TaskID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 7 || _mapTasks[_TaskID].Status == 71 ||
            _mapTasks[_TaskID].Status == 72, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].ReviewOrgAccount, 'Caller must be Review Org Account');

        _mapTasks[_TaskID].Status = 82;

        _mapTasks[_TaskID].updateTopicList.push("reviewGasReportReject");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function reviewVerifyReportReject(string memory _TaskID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 7 || _mapTasks[_TaskID].Status == 71 ||
            _mapTasks[_TaskID].Status == 72, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].ReviewOrgAccount, 'Caller must be Review Org Account');

        _mapTasks[_TaskID].Status = 81;

        _mapTasks[_TaskID].updateTopicList.push("reviewVerifyReportReject");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function adjustGasReport(string memory _TaskID, bytes32 _GasReportDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 91, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].EnterpriseAccount, 'Caller must be Enterprise Account');

        _mapTasks[_TaskID].GasReportDLID = _GasReportDLID;
        _mapTasks[_TaskID].Status = 72;

        _mapTasks[_TaskID].updateTopicList.push("adjustGasReport");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function adjustVerifyReport(string memory _TaskID, bytes32 _VerifyReportDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 7 || _mapTasks[_TaskID].Status == 71 ||
            _mapTasks[_TaskID].Status == 72, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].EnterpriseAccount, 'Caller must be Enterprise Account');

        _mapTasks[_TaskID].VerifyReportDLID = _VerifyReportDLID;
        _mapTasks[_TaskID].Status = 71;

        _mapTasks[_TaskID].updateTopicList.push("reviewGasReportReject");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function approvalOrRejectFinal(string memory _TaskID, bool _bApproval) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 8 || _mapTasks[_TaskID].Status == 83, "Invalid task status");
        require(msg.sender == _owner, 'Caller must be owner');

        if(_bApproval)
        {
            _mapTasks[_TaskID].Status = 9;
        }
        else
        {
            _mapTasks[_TaskID].Status = 91;
        }

        _mapTasks[_TaskID].updateTopicList.push("approvalOrRejectPlanByGovernment");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }

    function adjustReviewReport(string memory _TaskID, bytes32 _ReviewReportDLID) public
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        require(_mapTasks[_TaskID].Status == 91, "Invalid task status");
        require(msg.sender == _mapTasks[_TaskID].ReviewOrgAccount, 'Caller must be Review Org Account');

        _mapTasks[_TaskID].ReviewReportDLID = _ReviewReportDLID;
        _mapTasks[_TaskID].Status = 83;

        _mapTasks[_TaskID].updateTopicList.push("adjustReviewReport");
        _mapTasks[_TaskID].updatePersonList.push(msg.sender);
        _mapTasks[_TaskID].updateTimeList.push(now);
    }


    function getTaskBasicInfo(string memory _TaskID) external view returns (
        uint32 _Status,address _EnterpriseAccount,
        address _VerificationOrgAccount,address _ReviewOrgAccount,
        uint32 _EnterpriseApprovalStatusForPlan, uint32 _GovernmentApprovalStatusForPlan,
        uint32 _FinalApprovalStatus)
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        return (_mapTasks[_TaskID].Status, _mapTasks[_TaskID].EnterpriseAccount,
            _mapTasks[_TaskID].VerificationOrgAccount,_mapTasks[_TaskID].ReviewOrgAccount,
            _mapTasks[_TaskID].EnterpriseApprovalStatusForPlan,_mapTasks[_TaskID].GovernmentApprovalStatusForPlan,
            _mapTasks[_TaskID].FinalApprovalStatus);
    }

    function getTaskDataLayerInfo(string memory _TaskID) external view returns (
        bytes32 _PlanDLID,bytes32 _GasReportDLID,
        bytes32 _UncomplianceListDLID,bytes32 _UncomplianceEvidenceDLID,
        bytes32 _VerifyReportDLID,bytes32 _ReviewReportDLID)
    {
        require(bytes(_TaskID).length == 32, "Invalid taskid length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        return (_mapTasks[_TaskID].PlanDLID, _mapTasks[_TaskID].GasReportDLID,
            _mapTasks[_TaskID].UncomplianceListDLID, _mapTasks[_TaskID].UncomplianceEvidenceDLID,
            _mapTasks[_TaskID].VerifyReportDLID,_mapTasks[_TaskID].ReviewReportDLID);
    }

    function getTaskUpdateLists(string memory _TaskID) external view returns (string[] memory _UpdateTopicList,
        address[] memory _UpdatePersonList,uint[] memory _UpdateTimeList)
    {
        require(bytes(_TaskID).length == 32, "Invalid task id length");
        require(bytes(_mapTasks[_TaskID].TaskID).length == 32, "Task not found");
        return (_mapTasks[_TaskID].updateTopicList,_mapTasks[_TaskID].updatePersonList,_mapTasks[_TaskID].updateTimeList);
    }
}
