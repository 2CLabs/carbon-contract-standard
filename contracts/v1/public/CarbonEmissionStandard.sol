// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {UserAuth} from "../basic/UserAuth.sol";


contract CarbonEmissionStandard is UserAuth {
    uint32 private _contractsNum;
    address private _dataLayerAccount;
    mapping(uint32 => string) private _contractName;
    mapping(string => string) private _contract;

    string internal constant ERR_NAME_IS_INVALID = "Name is invalid";
    string internal constant ERR_NAME_IS_EXIST = "Name is exist";
    string internal constant ERR_NAME_IS_NOT_EXIST = "Name is not exist";
    string internal constant ERR_DATA_HASH_IS_INVALID = "Data hash is invalid";
    string internal constant ERR_INDEX_OUT_OF_RANGE = "Index out of range";

    string internal constant _THIS_CONTRACT_VERSIOIN = "v1.0.0";

    constructor(address dataLayerAccount) public UserAuth() {
        _contractsNum = 0;
        _dataLayerAccount = dataLayerAccount;
    }

    function add(string memory name, string memory dataHash) public {
        checkOperator();
        require(bytes(name).length > 0, ERR_NAME_IS_INVALID);
        require(bytes(dataHash).length > 0, ERR_DATA_HASH_IS_INVALID);
        string memory dataHashTmp = _contract[name];
        require(bytes(dataHashTmp).length == 0, ERR_NAME_IS_EXIST);

        _contract[name] = dataHash;
        _contractName[_contractsNum] = name;

        _contractsNum = _contractsNum + 1;
    }

    function getContractNum() public view returns (uint32) {
        return _contractsNum;
    }

    function getByName(string memory name) public view returns (string memory) {
        string memory dataHashTmp = _contract[name];
        require(bytes(dataHashTmp).length > 0, ERR_NAME_IS_NOT_EXIST);
        return dataHashTmp;
    }

    function getByIndex(
        uint32 index
    ) public view returns (string memory name, string memory dataHash) {
        require(index < _contractsNum, ERR_INDEX_OUT_OF_RANGE);
        name = _contractName[index];
        dataHash = _contract[name];
    }

    function getInfo()
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
