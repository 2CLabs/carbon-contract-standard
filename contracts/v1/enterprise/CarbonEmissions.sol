// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {UserAuth} from "../basic/UserAuth.sol";

contract CarbonEmmissions is UserAuth {
    struct Emmission {
        bytes32 dataHash;
        bool isValid;
        bool isAggregated;
        string title;
        uint256 result;
    }

    string internal constant ERR_NO_ANNUAL_DATA = "No this annual data";
    string internal constant ERR_INDEX_INVALID = "Index invalid";
    string internal constant ERR_DATA_HASH_IS_INVALID = "Data hash is invalid";

    string internal constant _THIS_CONTRACT_VERSIOIN = "v1.0.0";
    bytes32 emptyBytes32;

    string private _name;
    address private _dataLayerAccount;
    mapping(string => uint32) private _annualDataNum;
    mapping(string => mapping(uint32 => Emmission)) private _info;

    constructor(
        string memory in_name,
        address in_dataLayerAccount
    ) public UserAuth() {
        _name = in_name;
        _dataLayerAccount = in_dataLayerAccount;
    }

    function add(
        string memory year,
        bytes32 dataHash,
        string memory title,
        bool isAggregated,
        uint256 result
    ) public {
        checkOperator();
        require(dataHash != emptyBytes32, ERR_DATA_HASH_IS_INVALID);
        Emmission memory emmission = Emmission(
            dataHash,
            true,
            isAggregated,
            title,
            result
        );
        uint32 index = _annualDataNum[year];
        _info[year][index] = emmission;
    }

    function get(
        string memory year,
        uint32 index
    ) public view returns (Emmission memory) {
        require(_annualDataNum[year] > 0, ERR_NO_ANNUAL_DATA);
        require(_annualDataNum[year] > index, ERR_INDEX_INVALID);
        return _info[year][index];
    }

    function disable(string memory year, uint32 index) public {
        checkOperator();
        require(_annualDataNum[year] > 0, ERR_NO_ANNUAL_DATA);
        require(_annualDataNum[year] > index, ERR_INDEX_INVALID);
        _info[year][index].isValid = false;
    }

    function info()
        public
        view
        returns (
            string memory contract_version,
            string memory enterprise_name,
            address dataLayerAccount
        )
    {
        contract_version = _THIS_CONTRACT_VERSIOIN;
        enterprise_name = _name;
        dataLayerAccount = _dataLayerAccount;
    }
}
