// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {UserAuth} from "../basic/UserAuth.sol";


contract CodeOfCaculate is UserAuth{   
    struct Info {
        string name;
        string version;
        string content;
        address dataLayerAccount;
        string dataLayerHash;
    }
    string internal constant _THIS_CONTRACT_VERSIOIN = "v1.0.0";
    Info private _info;

    constructor(string memory in_name, string memory in_version, string memory in_content, address in_dataLayerAccount, string memory in_dataLayerHash) UserAuth() public {
        _info.name = in_name;
        _info.version = in_version;
        _info.content = in_content;
        _info.dataLayerAccount = in_dataLayerAccount;
        _info.dataLayerHash = in_dataLayerHash;
    }

    function getInfo() public view returns (string memory contract_version, Info memory ) {
        return (_THIS_CONTRACT_VERSIOIN, _info);
    }
}