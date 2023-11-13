# 国标24行业因子库数据录入规范

## 一、 概述

​		国标24行业因子库合约中保存的因子采用SON格式保存.

​        因子JSON按24行业划分.每个行业对应一段JSON数据. 每个行业的JSON数据再按排放源进行内部细分.

## 二、 24行业及排放源对照表

- - | 行业ID | 行业名称                         | 排放源ID | 符号                            | 行业排放源                                                   |
    | ------ | -------------------------------- | -------- | ------------------------------- | ------------------------------------------------------------ |
    | 01     | 发电企业                         | 01-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 01-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 01-03    | process_1                       | 工业生产过程(脱硫过程)                                       |
    | 02     | 电网企业                         | 02-01    | repair                          | 使用六氟化硫设备修理过程                                     |
    |        |                                  | 02-02    | retire                          | 使用六氟化硫设备退役过程                                     |
    |        |                                  | 02-03    | loss                            | 输配电损耗排放                                               |
    | 03     | 钢铁生产企业                     | 03-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 03-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 03-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 03-04    | process_1                       | 工业生产过程(溶剂消耗)                                       |
    |        |                                  | 03-05    | process_2                       | 工业生产过程(电极消耗)                                       |
    |        |                                  | 03-06    | process_3                       | 工业生产过程(外购原料)                                       |
    |        |                                  | 03-07    | fixed_carbon                    | 固碳产品隐含的排放                                           |
    | 04     | 化工生产企业                     | 04-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 04-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 04-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 04-04    | process_1                       | 工业生产过程(化石燃料和其它碳氢化合物用作原材料消耗)         |
    |        |                                  | 04-05    | process_2                       | 工业生产过程(碳酸盐使用过程)                                 |
    |        |                                  | 04-06    | process_3                       | 工业生产过程(硝酸生产过程)                                   |
    |        |                                  | 04-07    | process_4                       | 工业生产过程(己二酸生产过程)                                 |
    |        |                                  | 04-08    | co2_recovery                    | CO2回收利用                                                  |
    | 05     | 电解铝生产企业                   | 05-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 05-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 05-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 05-04    | stuff                           | 能源作为原材料用途(炭阳极消耗)                               |
    |        |                                  | 05-05    | process_1                       | 工业生产过程(阳极效应排放)                                   |
    |        |                                  | 05-06    | process_2                       | 工业生产过程(煅烧石灰石排放)                                 |
    | 06     | 镁冶炼企业                       | 06-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 06-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 06-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 06-04    | stuff                           | 能源作为原材料用途(硅铁生产消耗蓝炭)                         |
    |        |                                  | 06-05    | process_1                       | 工业生产过程(煅烧白云石排放)                                 |
    | 07     | 平板玻璃生产企业                 | 07-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 07-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 07-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 07-04    | stuff_oxidize                   | 原料配料中碳粉氧化的排放                                     |
    |        |                                  | 07-05    | resolve                         | 原料碳酸盐分解的排放                                         |
    | 08     | 水泥生产企业                     | 08-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 08-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 08-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 08-04    | abiotic_fuel                    | 替代燃料和废弃物中非生物质碳的燃烧                           |
    |        |                                  | 08-05    | resolve                         | 原料碳酸盐分解                                               |
    |        |                                  | 08-06    | incineration                    | 生料中非燃料碳煅烧                                           |
    | 09     | 陶瓷生产企业                     | 09-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 09-02    | electricity                     | 净外购生产用电                                               |
    |        |                                  | 09-03    | process_1                       | 工业生产过程(陶瓷烧成工序)                                   |
    | 10     | 民航企业                         | 10-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 10-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 10-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 10-04    | biomass_fuel                    | 生物质混合燃料燃烧                                           |
    | 11     | 独立焦化企业                     | 11-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 11-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 11-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 11-04    | steam                           | 净购入使用的蒸汽                                             |
    |        |                                  | 11-05    | co2_recovery                    | CO2回收利用                                                  |
    |        |                                  | 11-06    | process_1                       | 工业生产过程(炼焦过程)                                       |
    |        |                                  | 11-07    | process_2                       | 工业生产过程(焦化产品延伸加工等其它生产过程)                 |
    | 12     | 煤炭生产企业                     | 12-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 12-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 12-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 12-04    | steam                           | 净购入使用的蒸汽                                             |
    |        |                                  | 12-05    | torch                           | 火炬燃烧CO2排放                                              |
    |        |                                  | 12-06    | under_mining_escape_ch4         | 井工开采的CH4逃逸排放                                        |
    |        |                                  | 12-07    | under_mining_escape_co2         | 井工开采的CO2逃逸排放                                        |
    |        |                                  | 12-08    | open_mining_escape_ch4          | 露天开采的CH4逃逸排放                                        |
    |        |                                  | 12-09    | after_mining_escape_ch4         | 矿后活动的CH4逃逸排放                                        |
    | 13     | 石油和天然气生产企业             | 13-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 13-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 13-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 13-04    | steam                           | 净购入使用的蒸汽                                             |
    |        |                                  | 13-05    | torch                           | 火炬燃烧CO2排放(正常工况火炬燃烧CO2排放)                     |
    |        |                                  | 13-06    | torch_accident                  | 火炬燃烧CO2排放(事故火炬燃烧CO2排放)                         |
    |        |                                  | 13-07    | torch_ch4                       | 火炬燃烧CH4排放(正常工况火炬燃烧CH4排放)                     |
    |        |                                  | 13-08    | torch_accident_ch4              | 火炬燃烧CH4排放(事故火炬燃烧CH4排放)                         |
    |        |                                  | 13-09    | process_ch4_well_testing        | 油气勘探业务工艺放空CH4排放                                  |
    |        |                                  | 13-10    | mine_ch4_evacuation             | 油气开采业务工艺放空CH4排放                                  |
    |        |                                  | 13-11    | fugitive_emission               | 油气开采业务CH4逃逸排放                                      |
    |        |                                  | 13-12    | process_evacuation_ch4          | 油气处理业务-天然气处理过程工艺放空CH4排放                   |
    |        |                                  | 13-13    | process_co2_evacuation          | 油气处理业务-天然气处理过程工艺放空CO2排放                   |
    |        |                                  | 13-14    | fugitive_emission_ch4           | 油气处理业务CH4逃逸排放                                      |
    |        |                                  | 13-15    | transport_ch4_evacuation        | 油气储运业务工艺放空CH4排放                                  |
    |        |                                  | 13-16    | oil_transport_fugitive_emission | 油气储运业务-原油输送CH4逃逸排放                             |
    |        |                                  | 13-17    | gas_transport_fugitive_emission | 油气储运业务-天然气输送CH4逃逸排放                           |
    |        |                                  | 13-18    | co2_recovery                    | CO2回收利用                                                  |
    |        |                                  | 13-19    | ch4_recovery                    | CH4回收利用                                                  |
    | 14     | 石油化工企业                     | 14-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 14-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 14-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 14-04    | steam                           | 净购入使用的蒸汽                                             |
    |        |                                  | 14-05    | torch                           | 火炬燃烧CO2排放(正常工况火炬燃烧CO2排放)                     |
    |        |                                  | 14-06    | torch_accident                  | 火炬燃烧CO2排放(事故火炬燃烧CO2排放)                         |
    |        |                                  | 14-07    | process_1                       | 工业生产过程(石化-催化裂化装置)                              |
    |        |                                  | 14-08    | process_2                       | 工业生产过程(石化-催化重整装置-连续烧焦方式)                 |
    |        |                                  | 14-09    | process_3                       | 工业生产过程(石化-其它生产装置催化剂烧焦再生-连续烧焦过程)   |
    |        |                                  | 14-10    | process_4                       | 工业生产过程(石化-制氢装置)                                  |
    |        |                                  | 14-11    | process_5                       | 工业生产过程(石化-焦化装置)                                  |
    |        |                                  | 14-12    | process_6                       | 工业生产过程(石化-石油焦煅烧装置)                            |
    |        |                                  | 14-13    | process_7                       | 工业生产过程(石化-氧化沥青装置)                              |
    |        |                                  | 14-14    | process_8                       | 工业生产过程(石化-乙烯裂解装置)                              |
    |        |                                  | 14-15    | process_9                       | 工业生产过程(石化-乙二醇/环氧乙烷生产装置)                   |
    |        |                                  | 14-16    | process_10                      | 工业生产过程(石化-其它产品生产装置)                          |
    |        |                                  | 14-17    | co2_recovery                    | CO2回收利用                                                  |
    |        |                                  | 14-18    | process_11                      | 工业生产过程(石化-催化重整装置-间歇烧焦方式)                 |
    |        |                                  | 14-19    | process_12                      | 工业生产过程(石化-其它生产装置催化剂烧焦再生-间歇烧焦再生过程) |
    | 15     | 造纸和纸制品生产企业             | 15-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 15-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 15-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 15-04    | process_1                       | 工业生产过程(煅烧石灰石排放)                                 |
    |        |                                  | 15-05    | anaerobic                       | 废水厌氧处理                                                 |
    | 16     | 其他有色金属冶炼和压延加工业企业 | 16-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 16-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 16-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 16-04    | stuff                           | 能源的原材料用途                                             |
    |        |                                  | 16-05    | process_1                       | 工业生产过程(碳酸盐和草酸分解)                               |
    | 17     | 电子设备制造企业                 | 17-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 17-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 17-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 17-04    | process_1                       | 工业生产过程(刻蚀工序与CVD腔室清洗工序)                      |
    | 18     | 机械设备制造企业                 | 18-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 18-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 18-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 18-04    | process_1                       | 工业生产过程(电气设备与制冷设备生产过程)                     |
    |        |                                  | 18-05    | process_1                       | 工业生产过程(二氧化碳气体保护焊)                             |
    | 19     | 矿山企业                         | 19-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 19-02    | electricity                     | 净购入的电力                                                 |
    |        |                                  | 19-03    | hot                             | 净购入的热力                                                 |
    |        |                                  | 19-04    | steam                           | 净购入的蒸汽                                                 |
    |        |                                  | 19-05    | process_1                       | 工业生产过程(碳酸盐分解)                                     |
    |        |                                  | 19-06    | process_2                       | 工业生产过程(碳化工艺吸收)                                   |
    | 20     | 食品、烟草及酒、饮料和精制茶企业 | 20-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 20-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 20-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 20-04    | process_1                       | 工业生产过程(碳酸盐使用过程)                                 |
    |        |                                  | 20-05    | process_2                       | 工业生产过程(外购工业生产)                                   |
    |        |                                  | 20-06    | anaerobic                       | 废水厌氧处理                                                 |
    | 21     | 公共建筑运营单位（企业）         | 21-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 21-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 21-03    | hot                             | 净购入使用的热力                                             |
    | 22     | 陆上交通运输企业                 | 22-01    | fuel_1                          | 化石燃料燃烧(陆上交通行业)-二氧化碳排放量                    |
    |        |                                  | 22-02    | fuel_2                          | 化石燃料燃烧(陆上交通行业)-甲烷和氧化亚氮排放量              |
    |        |                                  | 22-03    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 22-04    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 22-05    | steam                           | 净购入使用的蒸汽                                             |
    |        |                                  | 22-06    | purification                    | 尾气净化过程                                                 |
    | 23     | 氟化工企业                       | 23-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 23-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 23-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 23-04    | steam                           | 净购入使用的蒸汽                                             |
    |        |                                  | 23-05    | process_hcfc22                  | HCFC-22生产过程HFC-23排放                                    |
    |        |                                  | 23-06    | hfc23_destroy                   | 销毁的HFC-23转化的CO2排放                                    |
    |        |                                  | 23-07    | process_escape                  | HFCs/PFCs/SF6生产过程的副产物及逃逸排放                      |
    | 24     | 工业其他行业企业                 | 24-01    | fuel                            | 化石燃料燃烧                                                 |
    |        |                                  | 24-02    | electricity                     | 净购入使用的电力                                             |
    |        |                                  | 24-03    | hot                             | 净购入使用的热力                                             |
    |        |                                  | 24-04    | steam                           | 净购入使用的蒸汽                                             |
    |        |                                  | 24-05    | process_1                       | 工业生产过程(碳酸盐使用过程)                                 |
    |        |                                  | 24-06    | anaerobic                       | 废水厌氧处理                                                 |
    |        |                                  | 24-07    | co2_recovery                    | CO2回收利用                                                  |
    |        |                                  | 24-08    | ch4_recovery                    | CH4回收利用                                                  |
    |        |                                  | 24-09    | ch4_destroy                     | CH4销毁                                                      |



## 三、 数据标准

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



#### 因子数据字段

| 一级字段       | 二级字段 | 字段描述                                                     | 是否可调整 |
| -------------- | -------- | ------------------------------------------------------------ | ---------- |
| type           | 无       | 因子数据类型,co:常量 od:一维数据 sd:二维数据                 | No         |
| factor_id      | 无       | 因子所属排放源,如 01-01对应发电企业化石燃料燃烧              | No         |
| parameter_name | 无       | 因子数据类型对应的参数名称,如name,pressure,temperature       | No         |
| desc           | 无       | 排放源中文名称,如"化石燃料燃烧"                              | No         |
| data           | value    | 因子值                                                       | Yes        |
|                | symbol   | 因子数据的符号,如fuel对应化石燃料燃烧,OF对应氧化率,NCV对应低位热值,CC对应单位热值含碳量 | No         |
|                | unit     | 因子值对应的单位                                             | No         |
|                | desc     | 因子中文名称,如"单位热值含碳量"                              | No         |
|                | source   | 因子值的参考来源,如"IPCC国家温室气体清单指南-2006"           | Yes        |
|                | range    | 因子值的可取值范围,如{ min: 14.449, max: 26.7 }              | Yes        |

​    表中除了 data下的value,source,range可以根据每年国家发布的因子取值变化,参考来源变化以及取值范围变化调整外,其他均固定不变.

#### 数据示例

​     以下以两个典型企业:发电企业和矿山企业为例，给出json因子数据示例.

##### 01发电企业JSON因子数据示例

对应的JSON格式的因子数据为:

```
{
    "fuel": {
        type: "od",
        factor_id: "01-01",
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
        factor_id: "01-02",
        parameter_name: [],
        desc: "净购入使用的电力",
        data:
            [
                [{ value: 0.581, symbol: "EF",desc:"电力排放因子",source: "《生态环境部印发企业温室气体排放核算方法与报告指南发电设施（2021年修订版）》（征求意见稿）-2021",unit: "tCO2/MWh" }],
            ],
    },
    "process_1": {
        type: "od",
        factor_id: "01-03",
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



##### 19矿山企业JSON因子数据示例

对应的JSON格式的因子数据为:

```
{
    "fuel": {
        type: "od",
        factor_id: "19-01",
        parameter_name: ["name"],
        desc: "化石燃料燃烧",
        data:
            [
                [{ value: "燃煤", symbol: "",desc:"", unit: "" }, { value: 0.02858, symbol: "CC",desc:"单位热值含碳量",source: "IPCC国家温室气体清单指南-2006",unit: "tC/GJ" ,range: { min: 0.02858, max: 0.03085 } }，{ value: 26.7, symbol: "NCV",desc:"低位热值",source: "中国温室气体清单研究-2005",unit: "GJ/t", range: { min: 14.449, max: 26.7 } }，{ value: 98, symbol: "OF",desc:"氧化率",source: "省级温室气体清单编制指南-无",unit: "%" }],
            ],
            ],
            ......
    },
    "electricity": {
        type: "co",
        factor_id: "19-02",
        parameter_name: [],
        desc: "净购入使用的电力",
        data:
            [
                [{ value: 0.581, symbol: "EF",desc:"电力排放因子",source: "《生态环境部印发企业温室气体排放核算方法与报告指南发电设施（2021年修订版）》（征求意见稿）-2021",unit: "tCO2/MWh" }],
            ],
    },
    "hot": {
        type: "co",
        factor_id: "19-03",
        parameter_name: [],
        desc: "净购入的热力",
        data:
            [
                [{ value: 0.11, symbol: "EF",desc:"热力排放因子",source: "",unit: "tCO2/GJ" }],
            ],
    },
    "steam": {
        type: "sd",
        factor_id: "19-04",
        parameter_name: ["pressure", "temperature"],
        desc: "净购入的蒸汽",
        data:
            [
                [{ value: 0.001,  symbol: "",desc: "压力",unit: "MPa" }, { value: 6.98, symbol: "", ,desc: "温度",unit: "℃" }, { value: 2513.8,  symbol: "En",desc: "热焓",source: "",unit: "kJ/kg" },{ value: 0.11,  symbol: "EF",desc: "热力排放因子",source: "",unit: "tCO2/GJ" }],
                ......
            ],
    },
    "process_1": {
        type: "od",
        factor_id: "19-05",
        parameter_name: ["name"],
        desc: "工业生产过程(碳酸盐分解)",
        data:
            [
                [{ value: "CaCO3", symbol: "",desc: "石灰石", unit: "" }, { value: 50, symbol: "n",desc: "石灰石的分解率",source: "",unit: "%",range: { min: 0, max: 100 }  }，{ value: 0.4397, symbol: "EF $sum(0-1)",desc: "CaCO3排放因子",source: "",unit: "tCO2/t"}，{ value: 50, symbol: "PUR $sum(0-1)",desc: "矿石中CaCO3组分的质量分数",source: "",unit: "%" ,range: { min: 0, max: 100 }}],{ value: 0.522, symbol: "EF $sum(0-2)",desc: "MgCO3排放因子",source: "",unit: "tCO2/t"}，{ value: 50, symbol: "PUR $sum(0-2)",desc: "矿石中MgCO3组分的质量分数",source: "",unit: "%" ,range: { min: 0, max: 100 }}],
            ],
            ......
    },
    "process_2": {
        type: "od",
        factor_id: "19-06",
        parameter_name: ["name"],
        desc: "工业生产过程(碳化工艺吸收)",
        data:
            [
                [{ value: "CaCO3", symbol: "",desc: "轻质碳酸钙", unit: "" }, { value: 0.4397, symbol: "EF $sum(0-1)",desc: "CaCO3排放因子",source: "",unit: "tCO2/t" }],{ value: 50, symbol: "PUR $sum(0-1)",desc: "轻质碳酸钙中CaCO3组分的质量分数",source: "",unit: "%", range: { min: 0, max: 100 }}，
            ],
            ......
    },
}
```

