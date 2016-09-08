//
//  LeanMessage.m
//  HowardCity
//
//  Created by CSX on 16/5/20.
//  Copyright © 2016年 CSX. All rights reserved.
//

#import "LeanMessage.h"

@interface LeanMessage () <AVIMClientDelegate>

@property (nonatomic, strong) AVIMClient *client;;

@end

@implementation LeanMessage

-(void)gg{
    // Tom 创建了一个 client，用自己的名字作为 clientId
    self.client = [[AVIMClient alloc] initWithClientId:@"Jerry"];
    
    // 设置 client 的 delegate，并实现 delegate 方法
    self.client.delegate = self;
}

// 接收消息的回调函数
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message {
    HCLog(@"%@", message.text); // 耗子，起床！
    self.receive = message.text;
}

-(void)game{
    // Tom 打开 client
    [self.client openWithCallback:^(BOOL succeeded, NSError *error) {
        // Tom 建立了与 Jerry 的会话
        [self.client createConversationWithName:@"猫和老鼠" clientIds:@[@"Jerry"] callback:^(AVIMConversation *conversation, NSError *error) {
            // Tom 发了一条消息给 Jerry
            [conversation sendMessage:[AVIMTextMessage messageWithText:self.send attributes:nil] callback:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    HCLog(@"发送成功！");
                }
            }];
        }];
    }];
}

@end
