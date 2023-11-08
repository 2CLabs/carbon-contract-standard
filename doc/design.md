# 合约标准设计

## 一 、合约设计

### 合约概况

![图片](pics/contracts.png)

> 注：标准范围只涉及企业碳排的相关合约。暂时不考虑CCER,碳汇,碳交易,碳足迹等。

### 1 因子库合约

从UserAuth合约继承,可以控制只能由部署者或部署者允许的帐号才能添加/修改因子,而任何帐号均可以查看因子. 

因子库可以有多个合约,比如 24行业因子库, ISO因子库等等.

### 2 计算公式合约

从UserAuth合约继承,可以控制只能由部署者或部署者允许的帐号才能添加/修改公式,而任何帐号均可以查看公式.

计算公式合约可以有多个合约,比如 24行业计算公式合约, ISO计算公式合约等.

### 3 碳排计算代码合约

从UserAuth合约继承,可以控制只能由部署者或部署者允许的帐号才能添加/修改代码,而任何帐号均可以获取计算代码.

计算的具体JS代码保存在该合约中, JS代码需保证是原生代码，没有外部依赖库.

### 4 碳排索引合约

保存有因子库合约,计算公式合约,碳排计算代码合约相关的升级和历史信息. 

从这个索引合约可以检索到以上合约的历史记录,版本历史,从而可以找到对应的合约地址.

### 5 企业碳管理合约

从UserAuth合约继承,可以控制只有企业碳排管理员帐号可以添加/修改/查看碳排数据;

可以控制只有企业帐号可以生成/修改/查看碳排数据;

   每个企业对应一个企业碳管理合约. 

   企业和监管机构通过该合约可以较实时地监测企业碳排放量; 

   该合约记录有企业所属行业,从而便于计算碳排量时获取对应行业的因子库和计算公式进行计算.  

   主要功能有:

   **碳排数据的上传**: 可以通过IOT设备自动上报碳排数据也可以人工上报碳排数据;

​    碳排数据包括选择的因子,选择的公式,排放量。

​    每次碳排数据上报时相应台账,发票等证明文件数据和上传人,排放设备等信息也需保存.以便核查机构查看验证.

​    设计上企业自测因子也属于碳排数据的一部分,上传时需指明是使用的自测因子库以及提供自测的支撑信息，这样既支持核查机构检查自测因子的有效性,也保证了自测因子的私密性.

​    碳排数据可以选择加密或不加密;

   **碳排报告**: 企业离线计算后,生成该时间段的碳排报告保存;碳排报告可以选择加密或不加密.

   企业碳排报告核查不通过, 需要整改时, 碳排整改记录也需保存.以便核查机构再次核查时查看验证.   

### 6 碳配额合约

   从UserAuth合约继承,可以控制控制只有环境厅的管理员账户才可以下发企业碳配额;   

​    碳配额合约从ERC20继承,使其具有金融功能,该合约管理有相关企业的碳管理合约地址和年度配额,以及相关企业的碳账户地址.(为以后的碳交易准备).

   该合约年初时由环境厅下发相关企业的配额.由环境厅控制.

### 7 核查机构管理合约

从UserAuth合约继承,可以控制只能由部署者或部署者允许的帐号审批核查机构;

​    该合约管理有资质进行核查的核查机构.由环境厅控制.

### 8 碳核查合约

从UserAuth合约继承,可以控制只能由部署者或部署者允许的帐号参与碳核查;

​    该合约控制每年每个企业的碳核查流程.由环境厅控制.

### 9 DataLayer 合约

保存企业碳排数据（或则数据摘要），每个企业需要部署一个DataLayer合约，企业碳排数据，相应台账,发票等证明文件数据保存在该DataLayer中, 各数据之间可以建立关联关系，用于追溯依赖。

**状态**

* 进行中，该状态下可以修改数据，添加依赖
* 已完成
* 取消

**存储位置**

* 少量数据，可以直接存放在链上
* 较大的数据，将数据摘要（MD5 SHA256 等）存放于链上

**依赖**

* 添加DataLayer hash来关联其它数据



**所有合约都从Upgradeable合约继承,支持升级.**



## 二 、合约之间的交互

![图片](pics/interaction.png)



## 三 、碳排计算

​    碳排量上传计算和验证计算过程：计算过程和验证过程均采用离线方式.

### 计算

* 通过企业的后台系统拉取因子库合约中的JSON格式的碳排因子EF,拉取企业碳管理合约中的JSON格式的碳排量AD,
* 通过企业的后台系统拉取计算公式合约中的JSON格式的计算公式FORMULA
* 通过企业的后台系统拉取JS计算代码,
* 在后台系统通过JS代码应用FORMULA,AD,EF,计算出相应的碳排量.再将碳排量上传保存至企业碳管理合约.

### 验证

​	核查机构或环境厅获取企业数据并验证计算记过。

* 从后台系统拉取因子库合约中的JSON格式的碳排因子EF,
* 拉取企业碳管理合约中的JSON格式的碳排量AD,
* 拉取计算公式合约中的JSON格式的计算公式FORMULA和JS计算代码,
* 在后台系统通过JS代码应用FORMULA,AD,EF,计算出相应的碳排量.
* 将**企业填报碳排量**和**计算结果**比对,从而确定是否验证通过.



## 五、 数据标准

为了规范合约中的数据，我们将会约定合约中的各种命名规范，数据信息保存格式。

由于计算和验证均采用离线方式，企业碳管理合约中保存的碳排数据量AD,因子库合约中保存的因子EF,以及计算公式合约中保存的计算公式FORMULA，均采用约定的JSON格式保存. 合约内部不进行JSON格式的处理.

### 命名

#### 命名规范

碳系统索引合约中：

* 国标因子合约索引命名： `GB_${行业编号}_factor_${YYMMDD}_${预留4个字符}`
* 国标公式合约索引命名： `GB_${行业编号}_falmula_${YYMMDD}_${预留4个字符}`
* 国标计算代码合约索引命名： `GB_calculate_${YYMMDD}_${预留4个字符}`

#### 命名列表

* 国标因子合约索引命名

| 行业名       | 索引名                       |
| ------------ | ---------------------------- |
| 中国发电企业 | `GB_01_factor_20231001_0000` |
| 中国电网企业 | `GB_02_factor_20231001_0000` |
| ...          |                              |

* 国标公式合约索引命名

| 行业名       | 索引名                        |
| ------------ | ----------------------------- |
| 中国发电企业 | `GB_01_formula_20231001_0000` |
| 中国电网企业 | `GB_02_formula_20231001_0000` |
|              |                               |

* ISO因子合约索引命名

...

* ISO公式合约索引命名

...

* 国标计算代码合约索引命名

| 行业名         | 索引名                       |
| -------------- | ---------------------------- |
| 2012年计算公式 | `GB_calculate_20221001_0000` |
| 2013年计算公式 | `GB_calculate_20231001_0000` |
| ...            |                              |



### 合约1  碳系统索引合约

#### 数据结构

```
contract_num: 6,

mapping(string => address) //对应的合约地址mapping，如：
contracts: {
    "GB_01_factor_20231030_0000": "发电企业factor contract address",
    "GB_02_factor_20231030_0000": "电网企业factor contract address",
    "GB_01_formula_20231030_0000": "发电企业formula contract address",
    "GB_02_formula_20231030_0000": "电网企业formula contract address",
    “GB_calculate_20221001_0000”:"国标2022年calculate contract address",
    “GB_calculate_20231001_0000”:"国标2023年calculate contract address",
}
```





### 合约2  国标24行业因子库

#### 因子数据类型

因子数据分为3种类型

`常量(co)` `一维数据(od)` `二维数据(sd)`

- 常量

```
例：
type = co
value_symbol = f()
value_symbol： 全国电力因子
```

* 一维数据： 

```
例：
type = od
value_symbol = f(name)
name： 燃料名
value_symbol： 氧化率、低位热值、单位热值含碳量
```

* 二维数据

```
例：
type = sd
value_symbol = f( P, T )
P : 压力
T: 温度
value_symbol：热焓
```



#### 数据结构

```
industrycode:"01",
year: "2023",
name: "国标因子库-发电企业行业",
version: "v1.0.0",
datalayerhash: "DataLayer hash",
```

#### 数据示例

datalayer hash 对应的JSON格式的因子数据为:

```
{
    "fuel": {
        type: "od",
        factorid: "01-01",
        parameter_name: ["name"],
        desc: "化石燃料燃烧",
        data:
            [
                [{ value: "燃煤", symbol: "",desc:"", unit: "" }, { value: 0.02858, symbol: "CC",desc:"单位热值含碳量",source: "IPCC国家温室气体清单指南-2006",unit: "tC/GJ" ,range: { min: 0.02858, max: 0.03085 } }，{ value: 26.7, symbol: "NCV",desc:"低位热值",source: "中国温室气体清单研究-2005",unit: "GJ/t", range: { min: 14.449, max: 26.7 } }，{ value: 98, symbol: "OF",desc:"氧化率",source: "省级温室气体清单编制指南-无",unit: "%" }],
            ],
            ......
    },
    "electricity": {
        type: "co",
        factorid: "01-02",
        parameter_name: [],
        desc: "净购入使用的电力",
        data:
            [
                [{ value: 0.581, symbol: "EF",desc:"电力排放因子",source: "《生态环境部印发企业温室气体排放核算方法与报告指南发电设施（2021年修订版）》（征求意见稿）-2021",unit: "tCO2/MWh" }],
            ],
    },
    "process_1": {
        type: "od",
        factorid: "01-03",
        parameter_name: ["name"],
        desc: "工业生产过程(脱硫过程)",
        data:
            [
                [{ value: "CaCO3", symbol: "",desc: "石灰石", unit: "" }, { value: 90, symbol: "I",desc: "碳酸盐含量",source: "",unit: "%" }，{ value: 100, symbol: "TR",desc: "转化率",source: "",unit: "%"}，{ value: 0.44, symbol: "EF",desc: "碳酸盐排放因子",source: "",unit: "tCO2/t" }],
            ],
            ......
    },
}
```

具体格式请参考《factor24_spec.md》

### 合约3  国标24行业计算公式合约

#### 数据结构

```
 industrycode:"01"
 year: "2023",
 name: "国标计算公式-发电企业行业",
 version: "v1.0.0",
 datalayerhash: "DataLayer hash",
```

#### 数据示例

datalayer hash 对应的JSON格式的公式数据为:

```
{

"sum":{
    type: "emission_summary",
    formulaid: "01-00",
    name: "汇总公式",
    formula: "E_fuel + E_electricity + E_process_1",
    factor: "01-00", //关联因子
    calculate_logic: "", // 计算逻辑
 },

“E_fuel":{
    type: "emission_item",
    formulaid: "01-01",
    name: "化石燃料燃烧产生的CO2排放量",
    formula: "(FC×NCV)×CC×OF×44/12",
    factor: "01-01", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_electricity":{
    type: "emission_item",
    formulaid: "01-02",
    name: "净购入使用的电力产生的CO2排放量",
    formula: "AC×EF",
    factor: "01-02", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_process_1":{
    type: "emission_item",
    formulaid: "01-03",
    name: "工业生产过程(脱硫过程)产生的CO2排放量",
    formula: "B×I×EF×TR",
    factor: "01-03", //关联因子
    calculate_logic: "", // 计算逻辑
 },
}
```

具体格式请参考《formula24_spec.md》



### 合约4  企业碳管理合约

#### 数据结构

```
name: "xxx企业",
industrycode:"01"

mapping( string => uint32) //某个年度已经提交了多少个碳排记录 如 “2023”=>6
mapping( string => (mapping (uint32 => struct))) //具体碳排记录mapping
```



具体碳排记录的mapping如:

```
{
        "2023": {
            // is_bottom 为true 意味着 该数据我们可以 加起来 用于外部系统实时计算年度 碳排
            "01": { data: "datalayerhash", valid: true, title: "一月" , aggregated: false, result: "120.3"},
            "02": { data: "datalayerhash", valid: true, title: "二月" , aggregated: false, result: "120.31"},
            "03": { data: "datalayerhash", valid: true, title: "三月" , aggregated: false, result: "120.378"},
            "04": { data: "datalayerhash", valid: true, title: "一季度" , aggregated: true, result: "380.3"},
            "05": { data: "datalayerhash", valid: true, title: "四月" , aggregated: true, result: "120.345"},
            "05": { data: "datalayerhash", valid: false, title: "年度报告" , aggregated: true, result: "678.543"},
             "06": { data: "datalayerhash", valid: true, title: "年度报告(整改后)" , aggregated: true, result: "678.543"},
        }
}
```



#### 数据示例

datalayerhash 对应的JSON格式的碳排数据为:

```
{
    "title": "2023年XX发电厂碳排数据",
    "total": "11023.345",
    "records": [
        // 用户自测因子
        { "FC": 100,unit:"t","NCV": 26.7, "CC": 0.02858, "OF": 93, "fule": "燃煤" },
        
        // 使用默认因子，如果fule在默认因子表中不存在，就应该报错
        { "FC": 120, unit:"t", "fule": "燃料油" },
        { "FC": 210, unit:"wNm³", "fule": "天然气" },        
        { "AC": 10.45, unit:"MWh", "electricity": "净购入使用的电力" },        
        { "B": 20.33, unit:"t", "process_1": "工业生产过程(脱硫过程)-石灰石" },

    ],

    "extrainfo": [

        "文件"[
        [{ "name": "2023年4月燃料有进厂台账文件" },
        { "datalayerhash": "0x12345678901234567890123456789012" }],

        [{ "name": "2023年4月购电发票" },
        { "datalayerhash": "0x12345678901234567890123456789013" }]
        
        [{ "name": "2023年燃煤自测因子测试量具和测试方法及过程文件" },
        { "datalayerhash": "0x12345678901234567890123456789014" }]
        
        [{ "name": "2023年碳排整改文件" },
        { "datalayerhash": "0x12345678901234567890123456789015" }]

        ///......

        ]
}
```

具体格式请参考《carbon_report_spec.md》