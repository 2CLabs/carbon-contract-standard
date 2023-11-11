// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {UserAuth} from "../basic/UserAuth.sol";

contract CEStandardEntry is UserAuth {
    uint32 private _contractsNum;
    address private _dataLayerAccount;
    mapping(uint32 => string) private _contractName;
    mapping(string => bytes32) private _contract;

    string internal constant ERR_NAME_IS_INVALID = "Name is invalid";
    string internal constant ERR_NAME_IS_EXIST = "Name is exist";
    string internal constant ERR_NAME_IS_NOT_EXIST = "Name is not exist";
    string internal constant ERR_DATA_HASH_IS_INVALID = "Data hash is invalid";
    string internal constant ERR_INDEX_OUT_OF_RANGE = "Index out of range";

    string internal constant _THIS_CONTRACT_VERSIOIN = "v1.0.0";
    bytes32 emptyBytes32;

    constructor(address dataLayerAccount) public UserAuth() {
        _contractsNum = 0;
        _dataLayerAccount = dataLayerAccount;
    }

    function add(string memory name, bytes32 dataHash) public {
        checkOperator();
        require(bytes(name).length > 0, ERR_NAME_IS_INVALID);
        require(dataHash != emptyBytes32, ERR_DATA_HASH_IS_INVALID);
        bytes32 dataHashTmp = _contract[name];
        require(dataHashTmp == emptyBytes32, ERR_NAME_IS_EXIST);

        _contract[name] = dataHash;
        _contractName[_contractsNum] = name;

        _contractsNum = _contractsNum + 1;
    }

    function getContractNum() public view returns (uint32) {
        return _contractsNum;
    }

    function getByName(string memory name) public view returns (bytes32) {
        bytes32 dataHashTmp = _contract[name];
        require(dataHashTmp != emptyBytes32, ERR_NAME_IS_NOT_EXIST);
        return dataHashTmp;
    }

    function getByIndex(
        uint32 index
    ) public view returns (string memory name, bytes32 dataHash) {
        require(index < _contractsNum, ERR_INDEX_OUT_OF_RANGE);
        name = _contractName[index];
        dataHash = _contract[name];
    }

    function info()
        public
        view
        returns (
            string memory contract_version,
            uint32 contractsNum,
            address dataLayerAccount
        )
    {
        contract_version = _THIS_CONTRACT_VERSIOIN;
        contractsNum = _contractsNum;
        dataLayerAccount = _dataLayerAccount;
    }
}
