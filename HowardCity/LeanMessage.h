//
//  LeanMessage.h
//  HowardCity
//
//  Created by CSX on 16/5/20.
//  Copyright © 2016年 CSX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVOSCloud/AVOSCloud.h>
// 如果使用了实时通信模块，请添加以下导入语句：
#import <AVOSCloudIM/AVOSCloudIM.h>

@interface LeanMessage : NSObject

@property(nonatomic, strong)NSString *send;

@property(nonatomic, strong)NSString *receive;

-(void)game;

-(void)gg;

@end
