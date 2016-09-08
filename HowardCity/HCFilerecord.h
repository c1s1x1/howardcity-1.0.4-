//
//  HCFilerecord.h
//  
//
//  Created by CSX on 16/4/21.
//
//

#import <Foundation/Foundation.h>

@interface HCFilerecord : NSObject

//文件地址
@property(nonatomic,copy)NSString *address;
//根目录文件指向的项目ID
@property(nonatomic,assign)int head;
//子目录文件指向的上一级文件ID
@property(nonatomic,assign)int header;
//文件类型
@property(nonatomic,copy)NSString *kind;
//*******
@property(nonatomic,copy)NSString *map;
//文件名
@property(nonatomic,copy)NSString *name;
//项目编号
@property(nonatomic,assign)int projectid;
//文件编号
@property(nonatomic,assign)int recordid;

@end
