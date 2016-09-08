//
//  HCUserInfo.h
//  HowardCity
//
//  Created by CSX on 16/4/25.
//  Copyright © 2016年 CSX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCUserInfo : NSObject

//公司名称
@property(nonatomic,copy)NSString *company;
//姓名
@property(nonatomic,copy)NSString *name;
//qq
@property(nonatomic,copy)NSString *qq;
//性别
@property(nonatomic,copy)NSString *sex;
//电话
@property(nonatomic,copy)NSString *telephone;
//微信
@property(nonatomic,copy)NSString *wechat;

@end
