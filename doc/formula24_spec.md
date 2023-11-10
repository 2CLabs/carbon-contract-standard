# 国标24行业计算公式录入规范

## 一、 概述

​		国标24行业计算公式合约中保存的公式采用SON格式保存.

​        公式JSON按24行业划分.每个行业对应一段JSON数据. 每个行业的JSON数据再按排放源进行内部细分.

## 二、术语和定义

* **因子(factor)**：在碳排计算中，有些参数不是企业生产过程中的数量数据（比如用电、燃料数量...），而是一些直接通过国家发布的默认值，比如蒸汽热焓、燃料氧化率... 这些数据企业也可以自行测量

* **符号 (symbol）**：公式中用到的字符，用于表示因子名、填入数据名、碳排种类名

  例如发电企业中公式为`E_fuel=(FC*NCV)*CC*OF*44/12`其中：

  * E_fuel 为碳排种类名
  * FC 消耗量为，用户填入数据名
  * `CC` `OF` `NCV` 都为因子名

## 三、 24行业及公式对照表

- - | 行业ID | 行业名称                         | 公式ID | 公式                                                         | 公式描述                                                     |
    | ------ | -------------------------------- | ------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
    | 01     | 发电企业                         | 01-00  | `E_sum = E_fuel + E_electricity + E_process_1`               | 汇总公式                                                     |
    |        |                                  | 01-01  | `E_fuel=(FC*NCV)*CC*OF*44/12`                                | 化石燃料燃烧                                                 |
    |        |                                  | 01-02  | `E_electricity=AC*EF`                                        | 净购入使用的电力                                             |
    |        |                                  | 01-03  | `E_process_1=B*I*EF*TR`                                      | 工业生产过程(脱硫过程)                                       |
    | 02     | 电网企业                         | 02-00  | `E_sum = E_repair + E_retire + E_loss`                       | 汇总公式                                                     |
    |        |                                  | 02-01  | E_repair=                                                    | 使用六氟化硫设备修理过程                                     |
    |        |                                  | 02-02  | E_retire=                                                    | 使用六氟化硫设备退役过程                                     |
    |        |                                  | 02-03  | E_loss=                                                      | 输配电损耗排放                                               |
    | 03     | 钢铁生产企业                     | 03-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 03-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 03-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 03-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 03-04  | E_process_1                                                  | 工业生产过程(溶剂消耗)                                       |
    |        |                                  | 03-05  | E_process_2                                                  | 工业生产过程(电极消耗)                                       |
    |        |                                  | 03-06  | E_process_3                                                  | 工业生产过程(外购原料)                                       |
    |        |                                  | 03-07  | E_fixed_carbon                                               | 固碳产品隐含的排放                                           |
    | 04     | 化工生产企业                     | 04-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 04-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 04-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 04-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 04-04  | E_process_1                                                  | 工业生产过程(化石燃料和其它碳氢化合物用作原材料消耗)         |
    |        |                                  | 04-05  | E_process_2                                                  | 工业生产过程(碳酸盐使用过程)                                 |
    |        |                                  | 04-06  | E_process_3                                                  | 工业生产过程(硝酸生产过程)                                   |
    |        |                                  | 04-07  | E_process_4                                                  | 工业生产过程(己二酸生产过程)                                 |
    |        |                                  | 04-08  | E_co2_recovery                                               | CO2回收利用                                                  |
    | 05     | 电解铝生产企业                   | 05-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 05-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 05-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 05-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 05-04  | E_stuff                                                      | 能源作为原材料用途(炭阳极消耗)                               |
    |        |                                  | 05-05  | E_process_1                                                  | 工业生产过程(阳极效应排放)                                   |
    |        |                                  | 05-06  | E_process_2                                                  | 工业生产过程(煅烧石灰石排放)                                 |
    | 06     | 镁冶炼企业                       | 06-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 06-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 06-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 06-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 06-04  | E_stuff                                                      | 能源作为原材料用途(硅铁生产消耗蓝炭)                         |
    |        |                                  | 06-05  | E_process_1                                                  | 工业生产过程(煅烧白云石排放)                                 |
    | 07     | 平板玻璃生产企业                 | 07-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 07-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 07-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 07-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 07-04  | E_stuff_oxidize                                              | 原料配料中碳粉氧化的排放                                     |
    |        |                                  | 07-05  | E_resolve                                                    | 原料碳酸盐分解的排放                                         |
    | 08     | 水泥生产企业                     | 08-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 08-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 08-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 08-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 08-04  | E_abiotic_fuel                                               | 替代燃料和废弃物中非生物质碳的燃烧                           |
    |        |                                  | 08-05  | E_resolve                                                    | 原料碳酸盐分解                                               |
    |        |                                  | 08-06  | E_incineration                                               | 生料中非燃料碳煅烧                                           |
    | 09     | 陶瓷生产企业                     | 09-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 09-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 09-02  | E_electricity                                                | 净外购生产用电                                               |
    |        |                                  | 09-03  | E_process_1                                                  | 工业生产过程(陶瓷烧成工序)                                   |
    | 10     | 民航企业                         | 10-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 10-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 10-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 10-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 10-04  | E_biomass_fuel                                               | 生物质混合燃料燃烧                                           |
    | 11     | 独立焦化企业                     | 11-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 11-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 11-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 11-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 11-04  | E_steam                                                      | 净购入使用的蒸汽                                             |
    |        |                                  | 11-05  | E_co2_recovery                                               | CO2回收利用                                                  |
    |        |                                  | 11-06  | E_process_1                                                  | 工业生产过程(炼焦过程)                                       |
    |        |                                  | 11-07  | E_process_2                                                  | 工业生产过程(焦化产品延伸加工等其它生产过程)                 |
    | 12     | 煤炭生产企业                     | 12-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 12-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 12-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 12-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 12-04  | E_steam                                                      | 净购入使用的蒸汽                                             |
    |        |                                  | 12-05  | E_torch                                                      | 火炬燃烧CO2排放                                              |
    |        |                                  | 12-06  | E_under_mining_escape_ch4                                    | 井工开采的CH4逃逸排放                                        |
    |        |                                  | 12-07  | E_under_mining_escape_co2                                    | 井工开采的CO2逃逸排放                                        |
    |        |                                  | 12-08  | E_open_mining_escape_ch4                                     | 露天开采的CH4逃逸排放                                        |
    |        |                                  | 12-09  | E_after_mining_escape_ch4                                    | 矿后活动的CH4逃逸排放                                        |
    | 13     | 石油和天然气生产企业             | 13-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 13-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 13-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 13-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 13-04  | E_steam                                                      | 净购入使用的蒸汽                                             |
    |        |                                  | 13-05  | E_torch                                                      | 火炬燃烧CO2排放(正常工况火炬燃烧CO2排放)                     |
    |        |                                  | 13-06  | E_torch_accident                                             | 火炬燃烧CO2排放(事故火炬燃烧CO2排放)                         |
    |        |                                  | 13-07  | E_torch_ch4                                                  | 火炬燃烧CH4排放(正常工况火炬燃烧CH4排放)                     |
    |        |                                  | 13-08  | E_torch_accident_ch4                                         | 火炬燃烧CH4排放(事故火炬燃烧CH4排放)                         |
    |        |                                  | 13-09  | E_process_ch4_well_testing                                   | 油气勘探业务工艺放空CH4排放                                  |
    |        |                                  | 13-10  | E_mine_ch4_evacuation                                        | 油气开采业务工艺放空CH4排放                                  |
    |        |                                  | 13-11  | E_fugitive_emission                                          | 油气开采业务CH4逃逸排放                                      |
    |        |                                  | 13-12  | E_process_evacuation_ch4                                     | 油气处理业务-天然气处理过程工艺放空CH4排放                   |
    |        |                                  | 13-13  | E_process_co2_evacuation                                     | 油气处理业务-天然气处理过程工艺放空CO2排放                   |
    |        |                                  | 13-14  | E_fugitive_emission_ch4                                      | 油气处理业务CH4逃逸排放                                      |
    |        |                                  | 13-15  | E_transport_ch4_evacuation                                   | 油气储运业务工艺放空CH4排放                                  |
    |        |                                  | 13-16  | E_oil_transport_fugitive_emission                            | 油气储运业务-原油输送CH4逃逸排放                             |
    |        |                                  | 13-17  | E_gas_transport_fugitive_emission                            | 油气储运业务-天然气输送CH4逃逸排放                           |
    |        |                                  | 13-18  | E_co2_recovery                                               | CO2回收利用                                                  |
    |        |                                  | 13-19  | E_ch4_recovery                                               | CH4回收利用                                                  |
    | 14     | 石油化工企业                     | 14-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 14-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 14-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 14-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 14-04  | E_steam                                                      | 净购入使用的蒸汽                                             |
    |        |                                  | 14-05  | E_torch                                                      | 火炬燃烧CO2排放(正常工况火炬燃烧CO2排放)                     |
    |        |                                  | 14-06  | E_torch_accident                                             | 火炬燃烧CO2排放(事故火炬燃烧CO2排放)                         |
    |        |                                  | 14-07  | E_process_1                                                  | 工业生产过程(石化-催化裂化装置)                              |
    |        |                                  | 14-08  | E_process_2                                                  | 工业生产过程(石化-催化重整装置-连续烧焦方式)                 |
    |        |                                  | 14-09  | E_process_3                                                  | 工业生产过程(石化-其它生产装置催化剂烧焦再生-连续烧焦过程)   |
    |        |                                  | 14-10  | E_process_4                                                  | 工业生产过程(石化-制氢装置)                                  |
    |        |                                  | 14-11  | E_process_5                                                  | 工业生产过程(石化-焦化装置)                                  |
    |        |                                  | 14-12  | E_process_6                                                  | 工业生产过程(石化-石油焦煅烧装置)                            |
    |        |                                  | 14-13  | E_process_7                                                  | 工业生产过程(石化-氧化沥青装置)                              |
    |        |                                  | 14-14  | E_process_8                                                  | 工业生产过程(石化-乙烯裂解装置)                              |
    |        |                                  | 14-15  | E_process_9                                                  | 工业生产过程(石化-乙二醇/环氧乙烷生产装置)                   |
    |        |                                  | 14-16  | E_process_10                                                 | 工业生产过程(石化-其它产品生产装置)                          |
    |        |                                  | 14-17  | E_co2_recovery                                               | CO2回收利用                                                  |
    |        |                                  | 14-18  | E_process_11                                                 | 工业生产过程(石化-催化重整装置-间歇烧焦方式)                 |
    |        |                                  | 14-19  | E_process_12                                                 | 工业生产过程(石化-其它生产装置催化剂烧焦再生-间歇烧焦再生过程) |
    | 15     | 造纸和纸制品生产企业             | 15-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 15-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 15-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 15-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 15-04  | E_process_1                                                  | 工业生产过程(煅烧石灰石排放)                                 |
    |        |                                  | 15-05  | E_anaerobic                                                  | 废水厌氧处理                                                 |
    | 16     | 其他有色金属冶炼和压延加工业企业 | 16-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 16-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 16-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 16-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 16-04  | E_stuff                                                      | 能源的原材料用途                                             |
    |        |                                  | 16-05  | E_process_1                                                  | 工业生产过程(碳酸盐和草酸分解)                               |
    | 17     | 电子设备制造企业                 | 17-00  | 汇总公式                                                     |                                                              |
    |        |                                  | 17-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 17-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 17-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 17-04  | E_process_1                                                  | 工业生产过程(刻蚀工序与CVD腔室清洗工序)                      |
    | 18     | 机械设备制造企业                 | 18-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 18-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 18-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 18-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 18-04  | E_process_1                                                  | 工业生产过程(电气设备与制冷设备生产过程)                     |
    |        |                                  | 18-05  | E_process_1                                                  | 工业生产过程(二氧化碳气体保护焊)                             |
    | 19     | 矿山企业                         | 19-00  | E_fuel + E_electricity + E_hot + E_steam + E_process_1 - E_process_2 | 汇总公式                                                     |
    |        |                                  | 19-01  | E_fuel=(FC*NCV)*CC*OF*44/12                                  | 化石燃料燃烧                                                 |
    |        |                                  | 19-02  | E_electricity=AD*EF                                          | 净购入的电力                                                 |
    |        |                                  | 19-03  | E_hot=[Ma*(T-20)]*4.1868/1000*EF                             | 净购入的热力                                                 |
    |        |                                  | 19-04  | E_steam=[Ma*(En-83.74)/1000]*EF                              | 净购入的蒸汽                                                 |
    |        |                                  | 19-05  | E_process_1=AD*n*∑(EF*PUR)                                   | 工业生产过程(碳酸盐分解)                                     |
    |        |                                  | 19-06  | E_process_2=AD*∑(EF*PUR)                                     | 工业生产过程(碳化工艺吸收)                                   |
    | 20     | 食品、烟草及酒、饮料和精制茶企业 | 20-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 20-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 20-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 20-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 20-04  | E_process_1                                                  | 工业生产过程(碳酸盐使用过程)                                 |
    |        |                                  | 20-05  | E_process_2                                                  | 工业生产过程(外购工业生产)                                   |
    |        |                                  | 20-06  | E_anaerobic                                                  | 废水厌氧处理                                                 |
    | 21     | 公共建筑运营单位（企业）         | 21-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 21-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 21-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 21-03  | E_hot                                                        | 净购入使用的热力                                             |
    | 22     | 陆上交通运输企业                 | 22-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 22-01  | E_fuel_1                                                     | 化石燃料燃烧(陆上交通行业)-二氧化碳排放量                    |
    |        |                                  | 22-02  | E_fuel_2                                                     | 化石燃料燃烧(陆上交通行业)-甲烷和氧化亚氮排放量              |
    |        |                                  | 22-03  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 22-04  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 22-05  | E_steam                                                      | 净购入使用的蒸汽                                             |
    |        |                                  | 22-06  | E_purification                                               | 尾气净化过程                                                 |
    | 23     | 氟化工企业                       | 23-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 23-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 23-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 23-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 23-04  | E_steam                                                      | 净购入使用的蒸汽                                             |
    |        |                                  | 23-05  | E_process_hcfc22                                             | HCFC-22生产过程HFC-23排放                                    |
    |        |                                  | 23-06  | E_hfc23_destroy                                              | 销毁的HFC-23转化的CO2排放                                    |
    |        |                                  | 23-07  | E_process_escape                                             | HFCs/PFCs/SF6生产过程的副产物及逃逸排放                      |
    | 24     | 工业其他行业企业                 | 24-00  | E_sum =                                                      | 汇总公式                                                     |
    |        |                                  | 24-01  | E_fuel                                                       | 化石燃料燃烧                                                 |
    |        |                                  | 24-02  | E_electricity                                                | 净购入使用的电力                                             |
    |        |                                  | 24-03  | E_hot                                                        | 净购入使用的热力                                             |
    |        |                                  | 24-04  | E_steam                                                      | 净购入使用的蒸汽                                             |
    |        |                                  | 24-05  | E_process_1                                                  | 工业生产过程(碳酸盐使用过程)                                 |
    |        |                                  | 24-06  | E_anaerobic                                                  | 废水厌氧处理                                                 |
    |        |                                  | 24-07  | E_co2_recovery                                               | CO2回收利用                                                  |
    |        |                                  | 24-08  | E_ch4_recovery                                               | CH4回收利用                                                  |
    |        |                                  | 24-09  | E_ch4_destroy                                                | CH4销毁                                                      |



## 三、 数据标准

#### 公式数据字段

| 字段            | 字段描述                                                  |
| --------------- | --------------------------------------------------------- |
| type            | 公式类型,emission_summary:汇总公式 emission_item:分项公式 |
| formula_id      | 公式id,如 01-01对应发电企业化石燃料燃烧公式               |
| name            | 公式名称,如化石燃料燃烧产生的CO2排放量                    |
| formula         | 公式                                                      |
| factor          | 对应的因子id,如01-01对应发电企业化石燃料燃烧因子          |
| calculate_logic | 计算逻辑                                                  |

​    表中所有字段均固定不变.

#### 数据示例

​     以下以两个典型企业:发电企业和矿山企业为例，给出json计算公式数据示例.

##### 01发电企业JSON公式数据示例

对应的JSON格式的公式数据为:

```
{

"E_sum":{
    type: "emission_summary",
    formula_id: "01-00",
    name: "汇总公式",
    formula: "E_fuel + E_electricity + E_process_1",
    factor: "01-00", //关联因子
    calculate_logic: "", // 计算逻辑
 },

“E_fuel":{
    type: "emission_item",
    formula_id: "01-01",
    name: "化石燃料燃烧产生的CO2排放量",
    formula: "(FC*NCV)*CC*OF*44/12",
    factor: "01-01", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_electricity":{
    type: "emission_item",
    formula_id: "01-02",
    name: "净购入使用的电力产生的CO2排放量",
    formula: "AC*EF",
    factor: "01-02", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_process_1":{
    type: "emission_item",
    formula_id: "01-03",
    name: "工业生产过程(脱硫过程)产生的CO2排放量",
    formula: "B*I*EF*TR",
    factor: "01-03", //关联因子
    calculate_logic: "", // 计算逻辑
 },
}
```



##### 19矿山企业JSON公式数据示例

对应的JSON格式的公式数据为:

```
{

"E_sum":{
    type: "emission_summary",
    formula_id: "19-00",
    name: "汇总公式",
    formula: "E_fuel + E_electricity + E_hot + E_steam + E_process_1 - E_process_2",
    factor: "19-00", //关联因子
    calculate_logic: "", // 计算逻辑
 },

“E_fuel":{
    type: "emission_item",
    formula_id: "19-01",
    name: "化石燃料燃烧产生的CO2排放量",
    formula: "(FC*NCV)*CC*OF*44/12",
    factor: "19-01", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_electricity":{
    type: "emission_item",
    formula_id: "19-02",
    name: "净购入使用的电力产生的CO2排放量",
    formula: "AD*EF",
    factor: "19-02", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_hot":{
    type: "emission_item",
    formula_id: "19-03",
    name: "净购入的热力产生的CO2排放量",
    formula: "[Ma*(T-20)]*4.1868/1000*EF",
    factor: "19-03", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_steam":{
    type: "emission_item",
    formula_id: "19-04",
    name: "净购入的蒸汽产生的CO2排放量",
    formula: "[Ma*(En-83.74)/1000]*EF",
    factor: "19-04", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_process_1":{
    type: "emission_item",
    formula_id: "19-05",
    name: "工业生产过程(碳酸盐分解)产生的CO2排放量",
    formula: "AD*n*∑(EF*PUR)",
    factor: "19-05", //关联因子
    calculate_logic: "", // 计算逻辑
 },
 “E_process_2":{
    type: "emission_item",
    formula_id: "19-06",
    name: "工业生产过程(碳化工艺吸收)产生的CO2排放量",
    formula: "AD*∑(EF*PUR)",
    factor: "19-06", //关联因子
    calculate_logic: "", // 计算逻辑
 },
}
```

