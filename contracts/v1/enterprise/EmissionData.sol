// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

// enterprise's accountaddr should create EmissionData contract for the enterprise
contract EmissionData {
    struct FactoryInfo {
        string factoryid;
        string factoryname;
        string managerid;        
    }

    struct EMInfo {  //Electricity meter
        string EMid;
        string factoryid;
        string EMdesc;
        string operatorid;   
    }

    struct WMInfo { //Water meter
        string WMid;
        string factoryid;
        string WMdesc;
        string operatorid;   
    }

    struct GMInfo { //Gas meter
        string GMid;
        string factoryid;
        string GMdesc;
        string operatorid;   
    }

    struct ElectricityInfo {
        uint256 amount;
        uint32 recordtime; //like 1683797787,every 8 hours
    }

    struct WaterInfo {
        uint256 amount;
        uint32 recordtime; //like 1683797787,every 8 hours
    }

    struct GasInfo {
        uint256 amount;
        uint32 recordtime; //like 1683797787,every 8 hours
    }

    struct EnergyIntensityInfo {
        uint256 electricityIntensity; //Keep 3 decimal places and multiply the actual value by 1000
        uint256 waterIntensity;//For example, if the actual value is 21.456, and waterIntensity is 21456
        uint256 gasIntensity; 
        uint32 recordtime; //like 1683797787,every month
    }

    string public orgid;
    
    address owner; //owner should to enterprise's accountaddr
    mapping(string => FactoryInfo ) _mapFactory; //factoryid => facotry info
    string[] _FactoryKeys;

    mapping(string => EMInfo ) _mapEM; //emid => electricity meter info
    string[] _EMKeys;
    mapping(string => ElectricityInfo[] ) _mapElectricityInfoList; //emid => ElectricityInfo list
    
    mapping(string => WMInfo ) _mapWM; //wmid => water meter info
    string[] _WMKeys;
    mapping(string => WaterInfo[] ) _mapWaterInfoList; //wmid => WaterInfo list
    
    mapping(string => GMInfo ) _mapGM; //gmid => gas meter info
    string[] _GMKeys;
    mapping(string => GasInfo[] ) _mapGasInfoList; //gmid => GasInfo list
    
    mapping(string => EnergyIntensityInfo[] ) _mapEnergyIntensity; //factoryid => ProductionInfo

    constructor(string memory _orgid) public {
        require(bytes(_orgid).length == 32, "Invalid orgid length");
        orgid = _orgid;
        owner = msg.sender;
    }

    //////////factory
    function addFactory(string memory _factoryid, string memory _factoryname, string memory _managerid) external
    {
        require(msg.sender == owner, 'Caller must be owner');
        require(bytes(_factoryid).length == 32, "Invalid factory id length");
        require(bytes(_managerid).length == 32, "Invalid manager id length");
        require(bytes(_factoryname).length <= 256, "Factory name length too large");
        require(bytes(_mapFactory[_factoryid].factoryname).length <= 0, "Factory already exist");
        _mapFactory[_factoryid] = FactoryInfo(_factoryid, _factoryname, _managerid);
        _FactoryKeys.push(_factoryid);
    }

    function getFactory(string memory _factoryid) external view returns (FactoryInfo memory _facotryinfo)
    {
        require(bytes(_factoryid).length == 32, "Invalid Factory id length");
        require(bytes(_mapFactory[_factoryid].factoryname).length > 0, "Factory not exist");        
        return _mapFactory[_factoryid];
    }

    function getFactoryList() external view returns (string[] memory)
    {
        return _FactoryKeys;
    }

    

    /////////////em
    function addEM(string memory _EMid,string memory _factoryid, string memory _EMdesc, string memory _operatorid) external
    {
        require(msg.sender == owner, 'Caller must be owner');
        require(bytes(_EMid).length == 32, "Invalid EM id length");
        require(bytes(_factoryid).length == 32, "Invalid factory id length");
        require(bytes(_mapFactory[_factoryid].factoryname).length > 0, "Factory not exist");
        require(bytes(_operatorid).length == 32, "Invalid operator id length");
        require(bytes(_EMdesc).length <= 256, "EM description length too large");
        require(bytes(_mapEM[_EMid].EMdesc).length <= 0, "EM already exist");
        _mapEM[_EMid] = EMInfo(_EMid,_factoryid, _EMdesc, _operatorid);
       _EMKeys.push(_EMid);
    }

    function getEM(string memory _EMid) external view returns (EMInfo memory _eminfo)
    {
        require(bytes(_EMid).length == 32, "Invalid EM id length");
        require(bytes(_mapEM[_EMid].EMdesc).length > 0, "EM not exist");        
        return _mapEM[_EMid];
    }

    function getEMList() external view returns (string[] memory _emlist)
    {
        return _EMKeys;
    }

    function addElectricity(string memory _EMid, string memory _operatorid, uint256 _amount, uint32 _recordtime) external
    {
        require(msg.sender == owner, 'Caller must be owner');
        require(bytes(_EMid).length == 32, "Invalid EM id length");
        require(bytes(_operatorid).length == 32, "Invalid operator id length");
        require(bytes(_mapEM[_EMid].EMdesc).length > 0, "EM not exist");
        require(_amount>0, "Electricity amount should greater than zero");
        require(_recordtime>0, "Electricity recordtime should greater than zero");
        require(keccak256(abi.encodePacked(_mapEM[_EMid].operatorid)) == keccak256(abi.encodePacked(_operatorid)), "operatorid invalid");
        _mapElectricityInfoList[_EMid].push(ElectricityInfo(_amount,_recordtime));
    }

    function getElectricityListByEMid(string memory _EMid) external view returns (ElectricityInfo[] memory _electricityinfoarr)
    {
        require(bytes(_EMid).length == 32, "Invalid EM id length");
        require(bytes(_mapEM[_EMid].EMdesc).length > 0, "EM not exist");        
        return _mapElectricityInfoList[_EMid];
    }

    /////////////wm
    function addWM(string memory _WMid,string memory _factoryid, string memory _WMdesc, string memory _operatorid) external
    {
        require(msg.sender == owner, 'Caller must be owner');
        require(bytes(_WMid).length == 32, "Invalid WM id length");
        require(bytes(_factoryid).length == 32, "Invalid factory id length");
        require(bytes(_mapFactory[_factoryid].factoryname).length > 0, "Factory not exist");
        require(bytes(_operatorid).length == 32, "Invalid operator id length");
        require(bytes(_WMdesc).length <= 256, "WM description length too large");
        require(bytes(_mapWM[_WMid].WMdesc).length <= 0, "WM already exist");
        _mapWM[_WMid] = WMInfo(_WMid,_factoryid, _WMdesc, _operatorid);
        _WMKeys.push(_WMid);
    }

    function getWM(string memory _WMid) external view returns (WMInfo memory _wminfo)
    {
        require(bytes(_WMid).length == 32, "Invalid WM id length");
        require(bytes(_mapWM[_WMid].WMdesc).length > 0, "WM not exist");        
        return _mapWM[_WMid];
    }

    function getWMList() external view returns (string[] memory _wmlist)
    {
        return _WMKeys;
    }

    function addWater(string memory _WMid, string memory _operatorid, uint256 _amount, uint32 _recordtime) external
    {
        require(msg.sender == owner, 'Caller must be owner');
        require(bytes(_WMid).length == 32, "Invalid WM id length");
        require(bytes(_operatorid).length == 32, "Invalid operator id length");
        require(bytes(_mapWM[_WMid].WMdesc).length > 0, "WM not exist");
        require(_amount>0, "Water amount should greater than zero");
        require(_recordtime>0, "Water recordtime should greater than zero");
        require(keccak256(abi.encodePacked(_mapWM[_WMid].operatorid)) == keccak256(abi.encodePacked(_operatorid)), "operatorid invalid");
        _mapWaterInfoList[_WMid].push(WaterInfo(_amount,_recordtime));
    }

    function getWaterListByWMid(string memory _WMid) external view returns (WaterInfo[] memory _waterinfoarr)
    {
        require(bytes(_WMid).length == 32, "Invalid WM id length");
        require(bytes(_mapWM[_WMid].WMdesc).length > 0, "WM not exist");        
        return _mapWaterInfoList[_WMid];
    }

    /////////////gm
    function addGM(string memory _GMid,string memory _factoryid, string memory _GMdesc, string memory _operatorid) external
    {
        require(msg.sender == owner, 'Caller must be owner');
        require(bytes(_GMid).length == 32, "Invalid GM id length");
        require(bytes(_factoryid).length == 32, "Invalid factory id length");
        require(bytes(_mapFactory[_factoryid].factoryname).length > 0, "Factory not exist");
        require(bytes(_operatorid).length == 32, "Invalid operator id length");
        require(bytes(_GMdesc).length <= 256, "GM description length too large");
        require(bytes(_mapGM[_GMid].GMdesc).length <= 0, "GM already exist");
        _mapGM[_GMid] = GMInfo(_GMid,_factoryid, _GMdesc, _operatorid);
        _GMKeys.push(_GMid);
    }

    function getGM(string memory _GMid) external view returns (GMInfo memory _gminfo)
    {
        require(bytes(_GMid).length == 32, "Invalid GM id length");
        require(bytes(_mapGM[_GMid].GMdesc).length > 0, "GM not exist");        
        return _mapGM[_GMid];
    }

    function getGMList() external view returns (string[] memory _gmlist)
    {
        return _GMKeys;
    }

    function addGas(string memory _GMid, string memory _operatorid, uint256 _amount, uint32 _recordtime) external
    {
        require(msg.sender == owner, 'Caller must be owner');
        require(bytes(_GMid).length == 32, "Invalid GM id length");
        require(bytes(_operatorid).length == 32, "Invalid operator id length");
        require(bytes(_mapGM[_GMid].GMdesc).length > 0, "GM not exist");
        require(_amount>0, "Gas amount should greater than zero");
        require(_recordtime>0, "Gas recordtime should greater than zero");
        require(keccak256(abi.encodePacked(_mapGM[_GMid].operatorid)) == keccak256(abi.encodePacked(_operatorid)), "operatorid invalid");
        _mapGasInfoList[_GMid].push(GasInfo(_amount,_recordtime));
    }

    function getGasListByGMid(string memory _GMid) external view returns (GasInfo[] memory _gesinfoarr)
    {
        require(bytes(_GMid).length == 32, "Invalid GM id length");
        require(bytes(_mapGM[_GMid].GMdesc).length > 0, "GM not exist");        
        return _mapGasInfoList[_GMid];
    }

    ///energy intensity
    function addEnergyIntensityInfo(string memory _factoryid,uint256 _electricityIntensity,
        uint256 _waterIntensity,uint256 _gasIntensity, uint32 _recordtime) external
    {
        require(msg.sender == owner, 'Caller must be owner');
        require(bytes(_factoryid).length == 32 , "Invalid factory id length");
        require(bytes(_mapFactory[_factoryid].factoryname).length > 0, "Factory not exist");
        require(_electricityIntensity>0, "ElectricityIntensity should greater than zero");
        require(_waterIntensity>0, "WaterIntensity should greater than zero");
        require(_gasIntensity>0, "GasIntensity should greater than zero");
        require(_recordtime>0, "EnergyIntensity recordtime should greater than zero");
        _mapEnergyIntensity[_factoryid].push(EnergyIntensityInfo(_electricityIntensity,_waterIntensity,_gasIntensity,_recordtime));
    }

    function getEnergyIntensityList(string memory _factoryid) external view returns (EnergyIntensityInfo[] memory energyintensityinfoarr)
    {
        require(bytes(_factoryid).length == 32, "Invalid Factory id length");
        require(bytes(_mapFactory[_factoryid].factoryname).length > 0, "Factory not exist");        
        return _mapEnergyIntensity[_factoryid];
    }

    //////////delete records 5 years ago, tick is 157766400
    function deleteExpireRecords(uint32 num) external returns (uint32 realdelnum){
        require(msg.sender == owner, 'Caller must be owner');        
        require(num > 0 && num < 1000, 'Num should be greater than 0 and less than 1000');
        realdelnum=0;
        uint tempdelnum=0;
        for (uint i = 0; i < _EMKeys.length; i++) {
            for (uint j = 0; j < _mapElectricityInfoList[_EMKeys[i]].length; j++) {
                if(_mapElectricityInfoList[_EMKeys[i]][j].recordtime > 157766400) {
                    delete _mapElectricityInfoList[_EMKeys[i]][j];
                    realdelnum++;
                    tempdelnum++;
                }
                if(tempdelnum>=num)
                    break;
            }
            if(tempdelnum>=num)
                break;
        }

        tempdelnum=0;
        for (uint i = 0; i < _WMKeys.length; i++) {
            for (uint j = 0; j < _mapWaterInfoList[_WMKeys[i]].length; j++) {
                if(_mapWaterInfoList[_WMKeys[i]][j].recordtime > 157766400) {
                    delete _mapWaterInfoList[_WMKeys[i]][j];
                    realdelnum++;
                    tempdelnum++;
                }
                if(tempdelnum>=num)
                    break;
            }
            if(tempdelnum>=num)
                break;
        }

        tempdelnum=0;
        for (uint i = 0; i < _GMKeys.length; i++) {
            for (uint j = 0; j < _mapGasInfoList[_GMKeys[i]].length; j++) {
                if(_mapWaterInfoList[_GMKeys[i]][j].recordtime > 157766400) {
                    delete _mapWaterInfoList[_GMKeys[i]][j];
                    realdelnum++;
                    tempdelnum++;
                }
                if(tempdelnum>=num)
                    break;
            }
            if(tempdelnum>=num)
                break;
        }
        
        tempdelnum=0;
        for (uint i = 0; i < _FactoryKeys.length; i++) {
            for (uint j = 0; j < _mapEnergyIntensity[_FactoryKeys[i]].length; j++) {
                if(_mapEnergyIntensity[_FactoryKeys[i]][j].recordtime > 157766400) {
                    delete _mapEnergyIntensity[_FactoryKeys[i]][j];
                    realdelnum++;
                    tempdelnum++;
                }
                if(tempdelnum>=num)
                    break;
            }
            if(tempdelnum>=num)                
                break;
        }

        return realdelnum;
    }
   
}

