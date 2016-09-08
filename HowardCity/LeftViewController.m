//
//  LeftViewController.m
//  ThreeViewsText
//
//  Created by lanouhn on 16/2/29.
//  Copyright © 2016年 杨鹤. All rights reserved.
//

#import "LeftViewController.h"
#import "UIView+CZ.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "AFNetworking.h"
#import "HCUserInfo.h"
#import "MJExtension.h"
#import "HCLoginViewController.h"

@interface LeftViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) HCUserInfo *UserInfo;

@property (nonatomic, assign) CGFloat UX;
@property (nonatomic, assign) CGFloat UY;
@property (nonatomic, assign) CGSize USize;

@end

// 账号的存储路径
#define HCAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置当前页面view的透明度
    self.view.alpha = 1;
    
    //获取个人信息数据
    [self getHCUserInfo];
    
    // Do any additional setup after loading the view.
}


/**
 *  创建控件, 添加约束
 */
- (void)addConstraint {
    
    // 头像图片
    //创建图片框架，并设置背景图片为home_back
    UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_back"]];
    //设置圆角
    headImage.layer.masksToBounds = YES;
    headImage.layer.cornerRadius = 45;
    //设置不绝对布局
    headImage.translatesAutoresizingMaskIntoConstraints = NO;
    //设置X/Y/W/H
    headImage.frame = CGRectMake(80, 80, 90, 90);
    //添加到当前页面
    [self.view addSubview:headImage];
    
    
    //创建文字框Label框架
    UILabel *UName = [[UILabel alloc]init];
    //设置用户名
    UName.text = self.UserInfo.name;
    //设置字体颜色
    UName.textColor = [UIColor whiteColor];
    //设置字体居左
    UName.textAlignment = NSTextAlignmentLeft;
    UName.translatesAutoresizingMaskIntoConstraints = NO;
    //设置不限制行数
    UName.numberOfLines = 0;
    //设置自动布局
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
    CGSize textSize = [UName.text boundingRectWithSize:CGSizeMake(800, 800) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
    self.UX = headImage.x + ( headImage.w * 0.5 ) - (textSize.width * 0.5);
    self.UY = CGRectGetMaxY(headImage.frame) + HCStatusCellInset + 10;
    //设置X/Y/W/H
    UName.frame = (CGRect){self.UX,self.UY,textSize.width,textSize.height};
    //添加到当前页面
    [self.view addSubview:UName];
    
    
    //同上
    UILabel *USex = [self setUILabelWithHeadLabel:UName WithName:[[NSString alloc]initWithFormat:@"性别：%@",self.UserInfo.sex]];
    USex.x = UName.x - 60 ;
    USex.y = UName.y + 100;
    [self.view addSubview:USex];
    
    //同上
    UILabel *UQQ = [self setUILabelWithHeadLabel:USex WithName:[[NSString alloc]initWithFormat:@"QQ：%@",self.UserInfo.qq]];
    [self.view addSubview:UQQ];
    
    //同上
    UILabel *UPhone = [self setUILabelWithHeadLabel:UQQ WithName:[[NSString alloc]initWithFormat:@"电话：%@",self.UserInfo.telephone]];
    [self.view addSubview:UPhone];
    
    //同上
    UILabel *UWehar = [self setUILabelWithHeadLabel:UPhone WithName:[[NSString alloc]initWithFormat:@"微信：%@",self.UserInfo.wechat]];
    [self.view addSubview:UWehar];
    
    
    //同上
    UILabel *UCompany = [self setUILabelWithHeadLabel:UWehar WithName:[[NSString alloc]initWithFormat:@"公司：%@",self.UserInfo.company]];
    [self.view addSubview:UCompany];
    
    UIButton *exit = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exit.frame = CGRectMake(70, 850, 120, 35);
    //设置圆角
    exit.layer.masksToBounds = YES;
    exit.layer.cornerRadius = 15;
    exit.tintColor = [UIColor whiteColor];
    exit.backgroundColor = [UIColor colorWithRed:12/255.0 green:54/255.0 blue:90/255.0 alpha:1.0];
    [exit setTitle:@"注销" forState:UIControlStateNormal];
    [exit addTarget:self action:@selector(Exit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exit];
}

-(void)Exit{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:HCAccountPath]) {
        [defaultManager removeItemAtPath:HCAccountPath error:nil];
        HCLoginViewController *LoginView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login"];
        
        self.view.window.rootViewController = LoginView;
        
        [self.view.window makeKeyAndVisible];

    }
    
}

-(UILabel *)setUILabelWithHeadLabel: (UILabel *)HeadLabel WithName: (NSString *)Info{
    UILabel *ULabel = [[UILabel alloc]init];
    
    ULabel.text = Info;
    
    ULabel.textColor = [UIColor whiteColor];
    
    ULabel.textAlignment = NSTextAlignmentLeft;
    
    ULabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    ULabel.numberOfLines = 0;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],};
    
    CGSize textSize = [ULabel.text boundingRectWithSize:CGSizeMake(200, 800) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;;
    //    //2.项目名称(字体大小14)
    self.UX = HeadLabel.x;
    self.UY = HeadLabel.y + HCUserInfoInset + 10;
    
    ULabel.frame = (CGRect){self.UX,self.UY,textSize.width,textSize.height};
    
    return ULabel;
}

-(void)getHCUserInfo{
    //获取user类
    HCAccount *user = [HCAuthTool user];
    
    //拼接url
    NSString *InfoUrl = [[NSString alloc]initWithFormat:@"http://rovibim.cn/androidside.jsp?action=check&userid=%@",user.username];
    
    //创建manager
#pragma mark 拼接url
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
#pragma mark 判断返回参数
    //获取项目数据
    [manager GET:InfoUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获取user开头的字典
        NSDictionary *tool = responseObject[@"user"];
        
        //把字典放入模型里
        self.UserInfo = [HCUserInfo objectWithKeyValues:tool];
        
        //设置内容
        [self addConstraint];
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HCLog(@"请求失败%@",error);
    }];
}


-(void)autolayout{
    //    NSDictionary *views = NSDictionaryOfVariableBindings(headImage, UName, USex, UQQ, UBirthday, UPhone, UEmail,UCity,UPostcode,UWehar,UCompany);
    //
    //    NSArray *imageHC = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[headImage(90)]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:views];
    //
    //    NSArray *imageV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[headImage(90)]-5-[UName]-5-[USex]-5-[UQQ]-5-[UBirthday]-5-[UPhone]-5-[UEmail]-5-[UCity]-5-[UPostcode]-5-[UWehar]-5-[UCompany]-500-|" options:(NSLayoutFormatAlignAllCenterX) metrics:nil views:views];
    //
    //    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:headImage attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeCenterX) multiplier:1    constant:0];
    //
    //
    //    NSArray *UNameArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UName]-50-|" options:0 metrics:0 views:views];
    //
    //    NSArray *USexArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[USex]-0-|" options:0 metrics:0 views:views];
    //
    //    NSArray *UQQArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UQQ]-0-|" options:0 metrics:0 views:views];
    //
    //    NSArray *UBirthdayArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UBirthday]-0-|" options:0 metrics:0 views:views];
    //
    //    NSArray *UPhoneArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UPhone]-0-|" options:0 metrics:0 views:views];
    //
    //    NSArray *UEmailArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UEmail]-0-|" options:0 metrics:0 views:views];
    //
    //    NSArray *UCityArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UCity]-0-|" options:0 metrics:0 views:views];
    //
    //    NSArray *UPostcodeArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UPostcode]-0-|" options:0 metrics:0 views:views];
    //
    //    NSArray *UWeharArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UWehar]-0-|" options:0 metrics:0 views:views];
    //
    //    NSArray *UCompanyArray = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-40-[UCompany]-0-|" options:0 metrics:0 views:views];
    //
    
    
    //    NSLayoutConstraint *UNameWigth = [NSLayoutConstraint constraintWithItem:UCompany attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:UWehar attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *USexWigth = [NSLayoutConstraint constraintWithItem:UCompany attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:UWehar attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *UQQWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *UBirthdayWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *UPhoneWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *UEmailWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *UCityWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *UPostcodeWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *UWeharWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    //
    //    NSLayoutConstraint *UCompanyWigth = [NSLayoutConstraint constraintWithItem:UName attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:USex attribute:(NSLayoutAttributeHeight) multiplier:1 constant:0];
    
    
    
    //    [self.view addConstraint:centerX];
    //
    //    [self.view addConstraints:imageHC];
    //
    //    [self.view addConstraints:imageV];
    //
    //    [self.view addConstraints:UNameArray];
    //
    //    [self.view addConstraints:USexArray];
    //
    //    [self.view addConstraints:UQQArray];
    //
    //    [self.view addConstraints:UBirthdayArray];
    //
    //    [self.view addConstraints:UPhoneArray];
    //
    //    [self.view addConstraints:UEmailArray];
    //
    //    [self.view addConstraints:UCityArray];
    //
    //    [self.view addConstraints:UPostcodeArray];
    //    
    //    [self.view addConstraints:UWeharArray];
    //    
    //    [self.view addConstraints:UCompanyArray];
    
    //    [self.view addConstraints:@[UNameWigth, USexWigth, UQQWigth, UBirthdayWigth, UPhoneWigth, UEmailWigth,UCityWigth,UPostcodeWigth,UWeharWigth,UCompanyWigth]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
