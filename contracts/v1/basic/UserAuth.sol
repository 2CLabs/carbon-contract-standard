// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.6.0;

enum addressType {
    NotAdded,
    Using,
    Disabled
}

struct usersInfo {
    mapping(address => addressType) caller;
    mapping(address => addressType) operator;
    address _owner;
}

contract UserAuth {
    usersInfo users;

    constructor() public {
        users._owner = msg.sender;
    }

    function addCaller( address addr) public {
        require(msg.sender == users._owner, "Only the onwner can call this function!");
        users.caller[addr] = addressType.Using;
    }

    function delCaller(address addr) public {
        require(msg.sender == users._owner, "Only the onwner can call this function!");
        delete users.caller[addr];
    }

    function disableCaller(address addr) public {
        require(msg.sender == users._owner, "Only the onwner can call this function!");
        users.caller[addr] = addressType.Disabled;
    }

    function addOperator( address addr) public {
        require(msg.sender == users._owner, "Only the onwner can call this function!");
        users.operator[addr] = addressType.Using;
    }

    function delOperator(address addr) public {
        require(msg.sender == users._owner, "Only the onwner can call this function!");
        delete users.operator[addr];
    }

    function disableOperator(address addr) public {
        require(msg.sender == users._owner, "Only the onwner can call this function!");
        users.operator[addr] = addressType.Disabled;
    }

    function checkCaller() public view returns(bool) {
        if (users.caller[msg.sender] == addressType.Using) {
            return true;
        }
        return false;
    }

    function checkOperator() public view returns(bool) {
        if (users.operator[msg.sender] == addressType.Using) {
            return true;
        }
        return false;
    }

    function checkOwner() public view returns(bool) {
        if (msg.sender == users._owner) {
            return true;
        }
        return false;
    }

    function showOwner() public view returns(address){
        return users._owner;
    }
}