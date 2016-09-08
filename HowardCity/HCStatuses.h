#import <Foundation/Foundation.h>

@interface HCStatuses : NSObject

//创建者
@property(nonatomic,copy)NSString *builder;
//图片
@property(nonatomic,copy)UIImage *img;
//项目信息
@property(nonatomic,copy)NSString *information;
//项目名称
@property(nonatomic,copy)NSString *name;
//*******
@property(nonatomic,copy)NSString *occupation;
//人数
@property(nonatomic,copy)NSString *people;
//项目编号
@property(nonatomic,copy)NSString *projectid;
//项目大小
@property(nonatomic,copy)NSString *space;
//项目大小
@property(nonatomic,assign)float SPI;
//项目大小
@property(nonatomic,assign)float CPI;

@end