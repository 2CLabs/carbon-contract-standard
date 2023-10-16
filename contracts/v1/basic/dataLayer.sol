// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
import {BytesLib} from "./BytesLib.sol";

contract DataV2 {
    using BytesLib for bytes;
    struct DataBlock {
        bytes32 finalHash; // 更新后，原始数据Hash
        bool onlyDataHash; // 是否只保存数据Hash在区块链中，true: 文件数据在链下,文件数据hash为storageFileHash  false: 数据放在jsonData字段中
        uint32 updateType; // UPDATE_TYPE_OVERITE UPDATE_TYPE_UPDATE
        bytes32 storageHash; // 数据片hash, isEncrypted == true 那么 storageHash != originalHash; isEncrypted != false 那么 storageHash == originalHash，如果 onlyDataHash==true 使用该hash可以用于请求文件
        bytes32 originalHash; // 原始数据片hash，
        bytes data; // 数据片hash，如果 onlyDataHash==true 该数据内容为空
    }

    struct DataLayer {
        bytes32 dataLayerNameHash;
        uint32 status; // 状态： 1:更新中、999无效、100:已完成（不能再更改）
        address owner; // 只有拥有者可以更新相关数据
        bool isEncrypted;
        uint32 num; // 提交数据次数，该数值只增加不减少
        // 依赖哪些数据
        uint32 depsNum; // 依赖数据 的数量
        bytes depsNameHashArray; // 必须是32字节的整数倍，每个 dataNameHash 都应该是已经完成的状态
    }

    // bytes32 public _dataLayerNameHash;
    // DataLayer public _mapLayer; //dataLayerNameHash => DataLayer
    DataLayer public _thisDataLayer; //dataLayerNameHash => DataLayer
    mapping(int256 => DataBlock) _mapBlock; //dataBlockHash => DataBlock

    // bytes public depsNameHashArray; // 必须是32字节的整数倍，每个 dataNameHash 都应该是已经完成的状态

    string internal constant ERR_DATA_LAYER_NOT_FOUNT = "Data Layer not found";
    string internal constant ERR_DATA_LAYER_IS_EXIST = "Data Layer is exist";
    string internal constant ERR_DATA_LAYER_IS_NOT_ONGOING =
        "Data Layer is not ongoing";
    string internal constant ERR_DATA_LAYER_IS_ENCRYPT =
        "Data Layer is encrypt";
    string internal constant ERR_DATA_LAYER_IS_NOT_ENCRYPT =
        "Data Layer is not encrypt";
    string internal constant ERR_INVALID_DATABLOCK_INDEX = "invalid dataBlock index";
    string internal constant ERR_DEPS_DATA_LENGTH = "Invalid Dep data length";

    uint32 internal constant ST_DATA_LAYER_ONGOING = 1;
    uint32 internal constant ST_DATA_LAYER_FINISHED = 100;
    uint32 internal constant ST_DATA_LAYER_CANCELLED = 999;

    uint32 internal constant UPDATE_TYPE_OVERITE = 1; // 覆盖之前所有数据
    uint32 internal constant UPDATE_TYPE_UPDATE = 2; // 更新之前的部分数据

    function byte32ToBytes(bytes32 _data) public pure returns (bytes memory) {
        return abi.encodePacked(_data);
    }

    function uint32ToBytes(uint32 num) public pure returns (bytes memory) {
        bytes memory result = new bytes(4);
        assembly {
            mstore(add(result, 32), num)
        }
        return result;
    }

    // 检查依赖layer，数据长度是否是32的整数倍
    function _checkDepsDataLength(bytes memory depsData) internal pure {
        require(uint32(depsData.length) % 32 == 0, ERR_DATA_LAYER_IS_EXIST);
    }


    function _checkDataLayerOnging() internal view {
        require(
            _thisDataLayer.status == ST_DATA_LAYER_ONGOING,
            ERR_DATA_LAYER_IS_NOT_ONGOING
        );
    }

    function _makeSureDataLayerIsEncrypted() internal view {
        require(
            _thisDataLayer.isEncrypted == true,
            ERR_DATA_LAYER_IS_ENCRYPT
        );
    }

    function _makeSureDataLayerIsNotEncrypted() internal view {
        require(
            _thisDataLayer.isEncrypted == false,
            ERR_DATA_LAYER_IS_NOT_ENCRYPT
        );
    }

    function _pushDataBlock(uint32 index, DataBlock memory db) internal {
        require(_thisDataLayer.num == index, "invalid dataBlock index");
        _mapBlock[index] = db;
        _thisDataLayer.num = _thisDataLayer.num + 1;
    }

    function hash(bytes memory data) public pure returns (bytes32) {
        require(uint32(data.length) > 0, "invalid data length");
        return sha256(data);
    }

    /************* Insert & update Data Layer ***********/
    constructor(
        bytes32 dataLayerNameHash,
        bytes memory depsData,
        bool isEncrypted
    ) public {
        // 需要附带一个数据
        _checkDepsDataLength(depsData);
 
        _thisDataLayer.dataLayerNameHash = dataLayerNameHash;
        _thisDataLayer.status = ST_DATA_LAYER_ONGOING;
        _thisDataLayer.owner = msg.sender;
        _thisDataLayer.isEncrypted = isEncrypted;
        _thisDataLayer.num = 0;
        _thisDataLayer.depsNum = uint32(depsData.length) / 32;
        _thisDataLayer.depsNameHashArray = depsData;
        _thisDataLayer.dataLayerNameHash = dataLayerNameHash;
    }

    // 获取 dataLayer 信息
    function dataLayerInfo() external view returns(bytes32 dataLayerNameHash, uint32 status, address owner, bool isEncrypted, uint32 num, uint32 depsNum, bytes memory depsNameHashArray) {

        status = _thisDataLayer.status;
        owner = _thisDataLayer.owner;
        isEncrypted = _thisDataLayer.isEncrypted;
        num = _thisDataLayer.num;
        depsNum = _thisDataLayer.depsNum;
        depsNameHashArray = _thisDataLayer.depsNameHashArray;
        dataLayerNameHash = _thisDataLayer.dataLayerNameHash;

    }

    // 更新依赖 dataLayer 的 hash 列表
    function updateDeps(bytes memory depsData) external {
        _checkDepsDataLength(depsData);
        _checkDataLayerOnging();

        _thisDataLayer.depsNum = uint32(depsData.length) / 32;
        _thisDataLayer.depsNameHashArray = depsData;
    }

    // 添加依赖 dataLayer 的 hash
    function appendDeps(bytes memory depsData) external {
        _checkDepsDataLength(depsData);
        _checkDataLayerOnging();

        // TODO: 连接depsData 到 _thisDataLayer.depsNameHashArray
        _thisDataLayer.depsNameHashArray = _thisDataLayer
            .depsNameHashArray
            .concat(depsData);
        _thisDataLayer.depsNum =
            uint32(_thisDataLayer.depsNameHashArray.length) /
            32;
    }

    function closeDataLayer() external {
        // DataLayer 关闭后就不再允许修改
        _checkDataLayerOnging();

        _thisDataLayer.status = ST_DATA_LAYER_FINISHED;
    }

    function cancellDataLayer() external {
        // DataLayer 关闭后就不再允许修改
        _checkDataLayerOnging();

        _thisDataLayer.status = ST_DATA_LAYER_CANCELLED;
    }

    function genDataBLockHash(bytes32 dataLayerNameHash, uint32 index)
        public
        pure
        returns (bytes32)
    {
        bytes memory data = byte32ToBytes(dataLayerNameHash);
        data = data.concat(uint32ToBytes(index));
        return sha256(data);
    }

    /************* Insert Data Block ***********/
    /* 添加一个未加密的 DataBLock (仅仅包含数据hash)*/
    function createDataBlock(
        uint32 index,
        uint32 updateType, /* 覆盖所有、 修改*/
        bytes32 originalHash,
        bytes32 finalHash
    ) external {
        _checkDataLayerOnging();
        _makeSureDataLayerIsNotEncrypted();

        DataBlock memory db = DataBlock(
            finalHash,
            true,
            updateType,
            originalHash,
            originalHash,
            ""
        );
        _pushDataBlock(index, db);
    }

    /* 添加一个加密的 DataBLock (仅仅包含数据hash)*/
    function createEncryptedDataBlock(
        uint32 index,
        uint32 updateType, /* 覆盖所有、 修改*/
        bytes32 storageHash,
        bytes32 originalHash,
        bytes32 finalHash
    ) external {
        _checkDataLayerOnging();
        _makeSureDataLayerIsEncrypted();

        DataBlock memory db = DataBlock(
            finalHash,
            true,
            updateType,
            storageHash,
            originalHash,
            ""
        );
        _pushDataBlock(index, db);
    }

    /* 添加一个未加密的 DataBLock (包含数据)*/
    function createDataBlockWithData(
        uint32 index,
        uint32 updateType, /* 覆盖所有、 修改*/
        bytes memory data,
        bytes32 finalHash
    ) external {
        _checkDataLayerOnging();
        _makeSureDataLayerIsNotEncrypted();

        bytes32 storageHash = hash(data);
        DataBlock memory db = DataBlock(
            finalHash,
            true,
            updateType,
            storageHash,
            storageHash,
            data
        );
        _pushDataBlock(index, db);
    }

    /* 添加一个加密的 DataBLock (包含数据)*/
    function createEncryptedDataBlockWithData(
        uint32 index,
        uint32 updateType, /* 覆盖所有、 修改*/
        bytes memory encryptedData,
        bytes32 originalHash,
        bytes32 finalHash
    ) external {
        _checkDataLayerOnging();
        _makeSureDataLayerIsEncrypted();

        bytes32 storageHash = hash(encryptedData);
        DataBlock memory db = DataBlock(
            finalHash,
            true,
            updateType,
            storageHash,
            originalHash,
            encryptedData
        );
        _pushDataBlock(index, db);
    }

    function getDataBlock(uint32 index) external view returns (bytes32 finalHash, bool onlyDataHash, uint32 updateType, bytes32 storageHash, bytes32 originalHash, bytes memory data){
        // struct DataBlock {
        // bytes32 finalHash; // 更新后，原始数据Hash
        // bool onlyDataHash; // 是否只保存数据Hash在区块链中，true: 文件数据在链下,文件数据hash为storageFileHash  false: 数据放在jsonData字段中
        // uint32 updateType; // UPDATE_TYPE_OVERITE UPDATE_TYPE_UPDATE
        // bytes32 storageHash; // 数据片hash, isEncrypted == true 那么 storageHash != originalHash; isEncrypted != false 那么 storageHash == originalHash，如果 onlyDataHash==true 使用该hash可以用于请求文件
        // bytes32 originalHash; // 原始数据片hash，
        // bytes data; // 数据片hash，如果 onlyDataHash==true 该数据内容为空
        require(index < _thisDataLayer.num, ERR_INVALID_DATABLOCK_INDEX);
        DataBlock memory dataDlock = _mapBlock[index];
        finalHash = dataDlock.finalHash;
        onlyDataHash = dataDlock.onlyDataHash;
        updateType = dataDlock.updateType;
        storageHash = dataDlock.storageHash;
        originalHash = dataDlock.originalHash;
        data = dataDlock.data;
    }
}
