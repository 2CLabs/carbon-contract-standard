// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import {BytesLib} from "./BytesLib.sol";
import {UserAuth} from "./UserAuth.sol";

contract DataLayerMultiple is UserAuth {
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
        uint32 status; // 状态： 1:更新中、999无效、100:已完成（不能再更改）
        address owner; // 只有拥有者可以更新相关数据
        bool isEncrypted;
        uint32 num; // 提交数据次数，该数值只增加不减少
        // 依赖哪些数据
        uint32 depsNum; // 依赖数据 的数量
        bytes depsNameHashArray; // 必须是32字节的整数倍，每个 dataNameHash 都应该是已经完成的状态
    }

    mapping(bytes32 => DataLayer) private _mapLayer; //dataLayerNameHash => DataLayer
    mapping(bytes32 => DataBlock) private _mapBlock; //dataBlockHash => DataBlock

    string internal constant ERR_DATA_LAYER_NOT_FOUNT = "Data Layer not found";
    string internal constant ERR_DATA_LAYER_IS_EXIST = "Data Layer is exist";
    string internal constant ERR_DATA_LAYER_IS_NOT_ONGOING =
        "Data Layer is not ongoing";
    string internal constant ERR_DATA_LAYER_IS_ENCRYPT =
        "Data Layer is encrypt";
    string internal constant ERR_DATA_LAYER_IS_NOT_ENCRYPT =
        "Data Layer is not encrypt";
    string internal constant ERR_INVALID_DATABLOCK_INDEX =
        "invalid dataBlock index";
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
        require(uint32(depsData.length) % 32 == 0, ERR_DEPS_DATA_LENGTH);
    }

    function _DataLayer(
        bytes32 dataLayerNameHash
    ) internal view returns (DataLayer memory dl) {
        dl = _mapLayer[dataLayerNameHash];
        require(dl.status != 0, ERR_DATA_LAYER_NOT_FOUNT);
    }

    function _checkDataLayer(bytes32 dataLayerNameHash) internal view {
        DataLayer memory dl = _mapLayer[dataLayerNameHash];
        require(dl.status != 0, ERR_DATA_LAYER_NOT_FOUNT);
    }

    function _checkDataLayerOnging(bytes32 dataLayerNameHash) internal view {
        DataLayer memory dl = _mapLayer[dataLayerNameHash];
        require(dl.status != 0, ERR_DATA_LAYER_NOT_FOUNT);
        require(
            dl.status == ST_DATA_LAYER_ONGOING,
            ERR_DATA_LAYER_IS_NOT_ONGOING
        );
    }

    function _makeSureDataLayerIsEncrypted(
        bytes32 dataLayerNameHash
    ) internal view {
        DataLayer memory dl = _mapLayer[dataLayerNameHash];
        require(dl.status != 0, ERR_DATA_LAYER_NOT_FOUNT);
        require(dl.isEncrypted == true, ERR_DATA_LAYER_IS_NOT_ONGOING);
    }

    function _makeSureDataLayerIsNotEncrypted(
        bytes32 dataLayerNameHash
    ) internal view {
        DataLayer memory dl = _mapLayer[dataLayerNameHash];
        require(dl.status != 0, ERR_DATA_LAYER_NOT_FOUNT);
        require(dl.isEncrypted == false, ERR_DATA_LAYER_IS_NOT_ONGOING);
    }

    function _pushDataBlock(
        bytes32 dataLayerNameHash,
        uint32 index,
        DataBlock memory db
    ) internal {
        require(
            _mapLayer[dataLayerNameHash].num == index,
            "invalid dataBlock index"
        );
        bytes32 dataBlockHash = genDataBLockHash(dataLayerNameHash, index);
        _mapBlock[dataBlockHash] = db;
        _mapLayer[dataLayerNameHash].num = _mapLayer[dataLayerNameHash].num + 1;
    }

    function hash(bytes memory data) public pure returns (bytes32) {
        require(uint32(data.length) > 0, "invalid data length");
        return sha256(data);
    }

    function dataLayerIsExist(
        bytes32 dataLayerNameHash
    ) internal view returns (bool) {
        DataLayer memory dl = _mapLayer[dataLayerNameHash];
        return (dl.status != 0);
    }

    /************* Insert & update Data Layer ***********/
    function createLayer(
        bytes32 dataLayerNameHash,
        bytes memory depsData,
        bool isEncrypted
    ) public {
        // 需要附带一个数据
        _checkDepsDataLength(depsData);
        DataLayer memory dl = _mapLayer[dataLayerNameHash];
        require(dl.status == 0, ERR_DATA_LAYER_IS_EXIST);
        DataLayer memory newInfo = DataLayer(
            ST_DATA_LAYER_ONGOING,
            msg.sender,
            isEncrypted,
            0,
            uint32(depsData.length) / 32,
            depsData
        );
        _mapLayer[dataLayerNameHash] = newInfo;
    }

    // 更新依赖 dataLayer 的 hash 列表
    function updateDeps(
        bytes32 dataLayerNameHash,
        bytes calldata depsData
    ) external {
        _checkDepsDataLength(depsData);
        _checkDataLayerOnging(dataLayerNameHash);

        _mapLayer[dataLayerNameHash].depsNum = uint32(depsData.length) / 32;
        _mapLayer[dataLayerNameHash].depsNameHashArray = depsData;
    }

    // 添加依赖 dataLayer 的 hash
    function appendDeps(
        bytes32 dataLayerNameHash,
        bytes calldata depsData
    ) external {
        _checkDepsDataLength(depsData);
        _checkDataLayerOnging(dataLayerNameHash);

        // TODO: 连接depsData 到 _mapLayer[dataLayerNameHash].depsNameHashArray
        _mapLayer[dataLayerNameHash].depsNameHashArray = _mapLayer[
            dataLayerNameHash
        ].depsNameHashArray.concat(depsData);
        _mapLayer[dataLayerNameHash].depsNum =
            uint32(_mapLayer[dataLayerNameHash].depsNameHashArray.length) /
            32;
    }

    function closeDataLayer(bytes32 dataLayerNameHash) external {
        checkOperator();
        // DataLayer 关闭后就不再允许修改
        _checkDataLayerOnging(dataLayerNameHash);

        _mapLayer[dataLayerNameHash].status = ST_DATA_LAYER_FINISHED;
    }

    function cancellDataLayer(bytes32 dataLayerNameHash) external {
        checkOperator();
        // DataLayer 关闭后就不再允许修改
        _checkDataLayerOnging(dataLayerNameHash);

        _mapLayer[dataLayerNameHash].status = ST_DATA_LAYER_CANCELLED;
    }

    function genDataBLockHash(
        bytes32 dataLayerNameHash,
        uint32 index
    ) public pure returns (bytes32) {
        bytes memory data = byte32ToBytes(dataLayerNameHash);
        data = data.concat(uint32ToBytes(index));
        return sha256(data);
    }

    /************* Insert Data Block ***********/
    /* 添加一个未加密的 DataBLock (仅仅包含数据hash)*/
    function createDataBlock(
        bytes32 dataLayerNameHash,
        uint32 index,
        uint32 updateType /* 覆盖所有、 修改*/,
        bytes32 originalHash,
        bytes32 finalHash
    ) external {
        checkOperator();
        // _checkDataLayerOnging(dataLayerNameHash);
        _makeSureDataLayerIsNotEncrypted(dataLayerNameHash);

        DataBlock memory db = DataBlock(
            finalHash,
            true,
            updateType,
            originalHash,
            originalHash,
            ""
        );
        _pushDataBlock(dataLayerNameHash, index, db);
    }

    /* 添加一个加密的 DataBLock (仅仅包含数据hash)*/
    function createEncryptedDataBlock(
        bytes32 dataLayerNameHash,
        uint32 index,
        uint32 updateType /* 覆盖所有、 修改*/,
        bytes32 storageHash,
        bytes32 originalHash,
        bytes32 finalHash
    ) external {
        checkOperator();
        // _checkDataLayerOnging(dataLayerNameHash);
        _makeSureDataLayerIsEncrypted(dataLayerNameHash);

        DataBlock memory db = DataBlock(
            finalHash,
            true,
            updateType,
            storageHash,
            originalHash,
            ""
        );
        _pushDataBlock(dataLayerNameHash, index, db);
    }

    /* 添加一个未加密的 DataBLock (包含数据)*/
    function createDataBlockWithData(
        bytes32 dataLayerNameHash,
        uint32 index,
        uint32 updateType /* 覆盖所有、 修改*/,
        bytes calldata data,
        bytes32 finalHash
    ) external {
        checkOperator();
        // _checkDataLayerOnging(dataLayerNameHash);
        _makeSureDataLayerIsNotEncrypted(dataLayerNameHash);

        bytes32 storageHash = hash(data);
        DataBlock memory db = DataBlock(
            finalHash,
            true,
            updateType,
            storageHash,
            storageHash,
            data
        );
        _pushDataBlock(dataLayerNameHash, index, db);
    }

    /* 添加一个加密的 DataBLock (包含数据)*/
    function createEncryptedDataBlockWithData(
        bytes32 dataLayerNameHash,
        uint32 index,
        uint32 updateType /* 覆盖所有、 修改*/,
        bytes calldata encryptedData,
        bytes32 originalHash,
        bytes32 finalHash
    ) external {
        checkOperator();
        // _checkDataLayerOnging(dataLayerNameHash);
        _makeSureDataLayerIsEncrypted(dataLayerNameHash);

        bytes32 storageHash = hash(encryptedData);
        DataBlock memory db = DataBlock(
            finalHash,
            true,
            updateType,
            storageHash,
            originalHash,
            encryptedData
        );
        _pushDataBlock(dataLayerNameHash, index, db);
    }

    // 获取dataLayer信息
    function dataLayerInfo(
        bytes32 dataLayerNameHash
    )
        external
        view
        returns (
            uint32 status,
            address owner,
            bool isEncrypted,
            uint32 num,
            uint32 depsNum,
            bytes memory depsNameHashArray
        )
    {
        _checkDataLayer(dataLayerNameHash);
        DataLayer memory dl = _mapLayer[dataLayerNameHash];

        status = dl.status;
        owner = dl.owner;
        isEncrypted = dl.isEncrypted;
        num = dl.num;
        depsNum = dl.depsNum;
        depsNameHashArray = dl.depsNameHashArray;
    }

    // 获取一个dataLayer一个修改信息
    function getDataBlock(
        bytes32 dataLayerNameHash,
        uint32 index
    )
        external
        view
        returns (
            bytes32 finalHash,
            bool onlyDataHash,
            uint32 updateType,
            bytes32 storageHash,
            bytes32 originalHash,
            bytes memory data
        )
    {
        _checkDataLayer(dataLayerNameHash);

        DataLayer memory dl = _mapLayer[dataLayerNameHash];
        require(index < dl.num, ERR_INVALID_DATABLOCK_INDEX);

        bytes32 blockIndex = genDataBLockHash(dataLayerNameHash, index);
        DataBlock memory dataDlock = _mapBlock[blockIndex];
        finalHash = dataDlock.finalHash;
        onlyDataHash = dataDlock.onlyDataHash;
        updateType = dataDlock.updateType;
        storageHash = dataDlock.storageHash;
        originalHash = dataDlock.originalHash;
        data = dataDlock.data;
    }
}
