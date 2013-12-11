

如果想添加食物，可以在 Food.xls 中添加若干行数据，只需要前面3列即可。然后可以用工具来生成。
    生成的文件可以在log中查看
不过，想添加食物，现在 Food.xls 文件由 Food_common.xls 取代了，而且还得修改其他一些重要文件，
    需要更新 Food_PicPath.xls 文件以及补充相应的图片，
    需要更新 Food_Limit.xls 文件
目前 Food_common.xls 的数据已经包含了原有的 Food_common.xls 和 Food_PicPath.xls 和 Food_Limit.xls 中的数据。



LZFacade class是一个最顶层的接口功能类。可以使用其中的方法来生成必要的数据。






USDAFullDataInSqlite.dat 含有USDA的ABBREV.xlsx中的全部数据，即所有食物的各营养成分表. 对应表名为FoodNutrition。
    可以通过 [workRe convertExcelToSqlite_USDA_ABBREV_withDebugFlag:false]; 来生成。

FoodNutritionCustom表和Food.xls中的数据可以说是一样的，都含有额外中文信息的部分食物营养成分数据。与FoodNutrition也很相似，只是多了一点中文信息列。
    但FoodNutritionCustom表的数据来源不是完全来自Food.xls中的数据，而是从Food.xls中取中文信息数据，并结合FoodNutrition的数据来连接生成。
FoodCustom表包含Food.xls中的那些中文信息列及自定义信息列的数据。可以与FoodNutrition连接生成FoodNutritionCustom的数据。

FoodLimit表和Food_Limit.xls中的数据是一样的，包含各种食物摄取的符合情理的上下限值。这些值对应的是是一天的摄入量。
    下限值Lower_Limit(g)定义为至少需要量，即如果低于下限值，则取下限值。 对于上限值Upper_Limit(g)，如果高于上限值，则取上限值。
    而normal_value介于上下限之间，目前的意义是适当值，即某种意义上的建议值，在某种算法中，首先以建议值为上限，当超过建议值时先使用别的食物，直到找不到别的未超过建议值的食物后，再使用上限值。
    另外，对于上下限值，normal值，应该会有一个地方给出默认值。
    现在有几个值，上下限，normal_value，first_recommend 。关系是:下限 <= first_recommend <= normal_value <= 上限 . normal_value可以看作是普通限制，first_recommend 可以看做是一般推荐值。first_recommend是基于膳食宝塔中的推荐值，但是这个值比起某些需要或需求来显得不足。
    目前在渐进增量算法中，
        有标志位needUseLowLimitAsUnit来控制下限值是否作为对应食物的单位增量值。
        有标志位needUseNormalLimitWhenSmallIncrementLogic控制上限值是使用normal_value还是Upper_Limit(g)。目前实际使用的是normal_value。
        有标志位needUseFirstRecommendWhenSmallIncrementLogic控制食物第一次的增量是否使用first_recommend。
        
        
        

Food_Supply_DRI_Amount,Food_Supply_DRI_Common 是衍生数据
Food_Supply_DRI_Amount 这个表是以 某份DRI 为基准（male 25 175cm 75kg low sport），根据食物营养成分表计算出的 每种营养成分在DRI的量的情况下，分别所需食物的量。
Food_Supply_DRI_Common 这个表中的数据源于 Food_Supply_DRI_Amount ，1000以上的作为0值，1000以下的除以100取整，这样分出一些level。可以用于食物含营养丰富程度的粗排序。


CustomDB.dat 中的数据是通过调用LZFacade.generateInitialData以导入各个*.xls文件及结合USDAFullDataInSqlite.dat中的数据生成的数据文件改名而来。
    当生成一个新的.dat的数据文件后，应注意及时更新CustomDB.dat。
dataAll.dat 是包含了 CustomDB.dat 和 USDAFullDataInSqlite.dat 中的所有数据。
不过由于这次的改动，在CustomDB.dat 中加了 FoodCustom 取代了 FoodCnDescription 和 FoodNutritionCustom ，以及把 FoodNutrition 也合进来了。目前CustomDB.dat 就是全的了。dataAll.dat 没必要了。

customUSDAdataV2.xls 和 Food.xls 其实是同一份文档，只是由于历史原因，先用的customUSDAdataV2.xls。而Food.xls应该是最新的。



DRIFemale，DRIMale，DRIULFemale，DRIULMale 是原始数据，DRIULrateFemale，DRIULrateMale是衍生数据。
        DRIULFemale，DRIULMale 看来完全相等
    注意DRI的UL的数据中 镁 magnesium 的情况很特殊。对于镁，表中标注的上限值仅表示从药理学的角度得出的摄入值，而并不包括从食物和水中摄入的量。  The ULs for magnesium represent intake from a pharmacological agent only and do not include intake from food and water.
    水 和纤维没有标明上限 目前上限值设为-1（即非常大）， 胆固醇的上限为尽可能低，目前上限值设为0




Food_common.xls 由于有新增食物和修改以前食物，但具体新增修改了哪些不清楚，需要和以前比对一下。
这里先把旧版的数据保存下来
CREATE TABLE FoodCustomOld AS SELECT * FROM FoodCustom;






CREATE TABLE CustomRichFood ('NutrientID' TEXT,'NDB_No' TEXT);
CREATE TABLE CustomRichFood2 ('NutrientID' TEXT,'NDB_No' TEXT); 对应CustomRichFood.xls中的筛选页



CREATE TABLE DiseaseNutrient (Disease TEXT, NutrientID TEXT, DiseaseGroup TEXT, LackLevelMark INTEGER);
  //CREATE UNIQUE INDEX uniqueIndexDiseaseNutrient ON DiseaseNutrient(Disease, NutrientID, DiseaseGroup);
  由于疾病与营养的对应关系上还有一些其他属性，如缺乏程度分值，并且这个属性只在特定的group上出现，考虑到在特定group中疾病营养对有重复的情况，这里干脆加一个DiseaseGroup列。
CREATE TABLE DiseaseGroup(DiseaseGroup TEXT, dsGroupType TEXT); 
    由于向导页已经取消，dsGroupWizardOrder列用不着了，会被删掉
CREATE TABLE DiseaseInGroup(DiseaseGroup TEXT, Disease TEXT,DiseaseEn TEXT, DiseaseDepartment TEXT, DiseaseType TEXT, DiseaseTimeType TEXT);
    这里 Disease 与 Group 的关系目前是一个Disease只在一个Group中出现，从而可以认为Disease唯一，Group只是Disease的一个属性。
    不同group中可能有相同的disease。但后来又改过数据，目前应该不存在这种情况。从而Disease 可以作为ID用。
    目前 Disease 是中文名称，DiseaseEn 是英文名称。现在把中文名称作为ID用，虽然默认显示英文。


//CREATE TABLE UserInfo(AvgHealthValue REAL, HealthCalCount INTEGER, AllUserAvgHealthValue REAL);
CREATE TABLE UserCheckDiseaseRecord(Day INTEGER, TimeType INTEGER, UpdateTime INTEGER, Diseases TEXT, LackNutrientIDs TEXT, HealthMark INTEGER);
目前 UserCheckDiseaseRecord 没有用上



CREATE TABLE TranslationItem (ItemType TEXT, ItemID TEXT, ItemNameCn TEXT, ItemNameEn TEXT);


V2版的与症状，关联营养素，关联病症相关的支持表格.目前id同于中文名.
    ForSex : male , female, both
    Symptom 表的主键是SymptomId，而不是 SymptomTypeId+SymptomId，因为把重复的症状名称改成不重复了。

CREATE TABLE SymptomType(SymptomTypeId TEXT PRIMARY KEY, DisplayOrder INTEGER, SymptomTypeNameCn TEXT, SymptomTypeNameEn TEXT, ForSex TEXT);
CREATE TABLE Symptom(SymptomTypeId TEXT, SymptomId TEXT, DisplayOrder INTEGER, SymptomNameCn TEXT, SymptomNameEn TEXT, HealthMark REAL, PRIMARY KEY(SymptomId) );
CREATE TABLE SymptomNutrient(SymptomTypeId TEXT, SymptomId TEXT, NutrientID TEXT);
CREATE TABLE SymptomPossibleIllness(SymptomTypeId TEXT, SymptomId TEXT, IllnessId TEXT);
CREATE TABLE Illness(IllnessId TEXT PRIMARY KEY, IllnessNameCn TEXT, IllnessNameEn TEXT, UrlCn TEXT, UrlEn TEXT);

CREATE TABLE IllnessToSuggestion(IllnessId TEXT, SuggestionId TEXT);
CREATE TABLE IllnessSuggestion(SuggestionId TEXT, SuggestionCn TEXT, SuggestionEn TEXT);

CREATE TABLE UserRecordSymptom(DayLocal INTEGER, UpdateTimeUTC INTEGER, inputNameValuePairs TEXT, Note TEXT, calculateNameValuePairs TEXT);
    inputNameValuePairs contains :
        Symptoms TEXT, Temperature REAL,Weight REAL,HeartRate REAL,BloodPressureLow REAL,BloodPressureHigh REAL, 
    calculateNameValuePairs contains :
        BMI REAL, HealthMark REAL, LackNutrientIDs TEXT, InferIllnesses TEXT, Suggestion TEXT, RecommendFoodAndAmounts TEXT
    name1=value1;;;name2=value2;;;arrayName1=[item1,,,item2];;;name3=value3;;;nameValuePairArrayName1={n1=v1,,,n2=v2}































