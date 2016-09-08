//
//  HCLoginViewController.h
//  HowardCity
//
//  Created by 紫月 on 16/4/15.
//  Copyright (c) 2016年 CSX. All rights reserved.
//
#import "HCLoginViewController.h"
#import "AFNetworking.h"
#import "HCAccount.h"
#import "HCAuthTool.h"
#import "RootViewController.h"
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "MBProgressHUD.h"

@interface HCLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField             *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField             *pwdTextField;
- (IBAction)loginButton;
@property (weak, nonatomic) IBOutlet UIButton                *remberPwdButton;
@property (weak, nonatomic) IBOutlet UIButton                *loginSelfButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicatorView;

@end

@implementation HCLoginViewController

-(void)viewDidAppear:(BOOL)animated{
    //设置状态栏为白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}

- (IBAction)loginButton {
    self.view.userInteractionEnabled = NO;
    
    #pragma mark 用户名和密码
    NSString *LoginName     = self.nameTextField.text;
    NSString *LoginPassward = self.pwdTextField.text;
    
    #pragma mark 拼接url
    NSString *LoginUrl = [[NSString alloc]initWithFormat:@"http://rovibim.cn/androidside.jsp?action=login&userid=%@&password=%@",LoginName,LoginPassward];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    #pragma mark 判断返回参数
    [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"action"] isEqualToString:@"1"]) {
            //创建用户字典
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"username"]         = self.nameTextField.text;
            dic[@"userpassword"]     = self.pwdTextField.text;
            dic[@"created_time"]     = [NSDate date];
            dic[@"expires_in"]       = [NSNumber numberWithInteger:604800];
            //保存用户数据
            HCAccount *account       = [HCAccount accountWithDict:dic];
            [HCAuthTool SaveAccount:account];
            [self enterMain];
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = [[NSString alloc]initWithFormat:@"网络问题，请稍后重试%@",error];
        HCLog(@"请求失败%@",error);
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        self.view.userInteractionEnabled = YES;
    }];
}

#pragma mark 设置首页
-(void)enterMain{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"登录成功，跳转中";
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        CenterViewController *centerVC = [[CenterViewController alloc] init];
        
        LeftViewController *leftVC = [LeftViewController new];
        
        RightViewController *rightVC = [RightViewController new];
        
        self.view.window.rootViewController = [[RootViewController alloc] initWithCenterVC:centerVC rightVC:rightVC leftVC:leftVC];
    }];
}

#pragma mark 记住密码逻辑
- (IBAction)remberPwd:(UIButton *)remberPwdButton{
    if (remberPwdButton.selected && self.loginSelfButton.selected) {
        remberPwdButton.selected      = NO;
        self.loginSelfButton.selected = NO;
        return;
    }
    remberPwdButton.selected = !remberPwdButton.selected;
}

- (IBAction)loginSelf:(UIButton *)loginSelfButton{
    if (loginSelfButton.selected == NO && self.remberPwdButton.selected == NO) {
        self.remberPwdButton.selected = YES;
        loginSelfButton.selected      = YES;
        return;
    }
    loginSelfButton.selected = !loginSelfButton.selected;
}

#pragma mark 键盘处理
//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}

@end
