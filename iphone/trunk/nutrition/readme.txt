




有关Food_Supply_DRI_Common这个表。这个表记录的是食物的营养成分的丰富程度。
  其表结构与FoodNutritionCustom相同。
  其数据来源是根据某份DRI的值算每个食物对于每个营养的供给量，然后按100g对供给量分level，超过1000g的不算，认为含量太少，而作为0值level。其有效的数据列基本对应DRI中的数据列，除了少数特殊的营养素，如水、钠等。
  当level值为正数时，数越小代表某食物对于某营养的含量越丰富。

CREATE TABLE Food_Supply_DRI_Common ('NDB_No' TEXT PRIMARY KEY,'Shrt_Desc' REAL,
    'Water_(g)' REAL,'Energ_Kcal' REAL,'Protein_(g)' REAL,'Lipid_Tot_(g)' REAL,'Ash_(g)' REAL,'Carbohydrt_(g)' REAL,
    'Fiber_TD_(g)' REAL,'Sugar_Tot_(g)' REAL,'Calcium_(mg)' REAL,'Iron_(mg)' REAL,'Magnesium_(mg)' REAL,
    'Phosphorus_(mg)' REAL,'Potassium_(mg)' REAL,'Sodium_(mg)' REAL,'Zinc_(mg)' REAL,'Copper_(mg)' REAL,
    'Manganese_(mg)' REAL,'Selenium_(µg)' REAL,
    'Vit_C_(mg)' REAL,'Thiamin_(mg)' REAL,'Riboflavin_(mg)' REAL,'Niacin_(mg)' REAL,'Panto_Acid_mg)' REAL,
    'Vit_B6_(mg)' REAL,'Folate_Tot_(µg)' REAL,'Folic_Acid_(µg)' REAL,'Food_Folate_(µg)' REAL,'Folate_DFE_(µg)' REAL,
    'Choline_Tot_ (mg)' REAL,'Vit_B12_(µg)' REAL,'Vit_A_IU' REAL,'Vit_A_RAE' REAL,'Retinol_(µg)' REAL,'Alpha_Carot_(µg)' REAL,
    'Beta_Carot_(µg)' REAL,'Beta_Crypt_(µg)' REAL,'Lycopene_(µg)' REAL,'Lut+Zea_ (µg)' REAL,'Vit_E_(mg)' REAL,'Vit_D_(µg)' REAL,
    'Vit_D_(IU)' REAL,'Vit_K_(µg)' REAL,'FA_Sat_(g)' REAL,'FA_Mono_(g)' REAL,'FA_Poly_(g)' REAL,'Cholestrl_(mg)' REAL,
    'GmWt_1' REAL,'GmWt_Desc1' TEXT,'GmWt_2' REAL,'GmWt_Desc2' TEXT,'Refuse_Pct' REAL,'CnCaption' TEXT,'CnType' TEXT);




FoodCollocation 食物搭配历史表
CollocationId, CollocationName, CollocationCreateTime

CollocationFood 食物搭配详情，一个搭配包含多个食物
CollocationId, FoodId, FoodAmount

FoodCollocationParam 食物搭配相关参数，主要是用户信息，但是可能目前仅作记录。使用时仍用当前的。
CollocationId, ParamName, ParamValue

DROP TABLE IF EXISTS FoodCollocation;
DROP TABLE IF EXISTS CollocationFood;
DROP TABLE IF EXISTS FoodCollocationParam;
CREATE TABLE FoodCollocation(CollocationId INTEGER PRIMARY KEY AUTOINCREMENT, CollocationName TEXT, CollocationCreateTime INTEGER);
CREATE TABLE CollocationFood(CollocationId INTEGER, FoodId TEXT, FoodAmount REAL);
CREATE TABLE FoodCollocationParam(CollocationId INTEGER, ParamName TEXT, ParamValue TEXT);




