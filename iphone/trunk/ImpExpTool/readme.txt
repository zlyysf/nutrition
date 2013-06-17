

如果想添加食物，可以在 Food.xls 中添加若干行数据，只需要前面3列即可。然后可以用工具来生成。
    生成的文件可以在log中查看
不过，想添加食物，现在 Food.xls 文件由 Food_common.xls 取代了，而且还得修改其他一些重要文件，
    需要更新 Food_PicPath.xls 文件以及补充相应的图片，
    需要更新 Food_Limit.xls 文件




LZFacade class是一个最顶层的接口功能类。可以使用其中的方法来生成必要的数据。






USDAFullDataInSqlite.dat 含有USDA的ABBREV.xlsx中的全部数据，即所有食物的各营养成分表. 对应表名为FoodNutrition。
    可以通过 [workRe convertExcelToSqlite_USDA_ABBREV_withDebugFlag:false]; 来生成。

FoodNutritionCustom表和Food.xls中的数据可以说是一样的，都含有额外中文信息的部分食物营养成分数据。与FoodNutrition也很相似，只是多了一点中文信息列。
    但FoodNutritionCustom表的数据来源不是完全来自Food.xls中的数据，而是从Food.xls中取中文信息数据，并结合FoodNutrition的数据来连接生成。
FoodCnDescription表包含Food.xls中的那些中文信息列的数据。可以与FoodNutrition连接生成FoodNutritionCustom的数据。

FoodLimit表和Food_Limit.xls中的数据是一样的，包含各种食物摄取的符合情理的上下限值。

Food_Supply_DRI_Amount 这个表是以 某份DRI 为基准（male 25 175cm 75kg low sport），根据食物营养成分表计算出的 每种营养成分在DRI的量的情况下，分别所需食物的量。
Food_Supply_DRI_Common 这个表中的数据源于 Food_Supply_DRI_Amount ，1000以上的作为0值，1000以下的除以100取整，这样分出一些level。可以用于食物含营养丰富程度的粗排序。


CustomDB.dat 中的数据是通过调用LZFacade.generateInitialData以导入各个*.xls文件及结合USDAFullDataInSqlite.dat中的数据生成的数据文件改名而来。
    当生成一个新的.dat的数据文件后，应注意及时更新CustomDB.dat。
dataAll.dat 是包含了 CustomDB.dat 和 USDAFullDataInSqlite.dat 中的所有数据。

customUSDAdataV2.xls 和 Food.xls 其实是同一份文档，只是由于历史原因，先用的customUSDAdataV2.xls。而Food.xls应该是最新的。










