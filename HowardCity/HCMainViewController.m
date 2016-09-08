//
//  HCMainViewController.m
//  HowardCity
//
//  Created by 紫月 on 16/4/18.
//  Copyright (c) 2016年 CSX. All rights reserved.
//

#import "HCMainViewController.h"
#import "ProjectEntity.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "HCFilerecord.h"
#import "MBProgressHUD.h"
#import "UIView+CZ.h"
#import "HCFileCellFrame.h"
#import "HCFileCell.h"
#import "StoryCommentCell.h"
#import <QuickLook/QuickLook.h>
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "RootViewController.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "HCUserInfo.h"
#import "NSString+ChineseCharactersToSpelling.h"
#import "LBProgressHUD.h"
#import "AppDelegate.h"


@interface HCMainViewController ()<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>
//文件夹数组
@property (nonatomic,strong) NSMutableArray *FilesCellFrame;
//预览参数
@property (nonatomic,strong) UIDocumentInteractionController *documentController;
//目录路径数组
@property (nonatomic,strong) NSMutableArray *FilePathArray;
//目录路径
@property (nonatomic,strong) UILabel *FilePath;
//连续点击判断（是否同一行）
@property (nonatomic,assign) NSInteger Index;
//根目录判断变量
@property (nonatomic,assign) NSInteger flag;

@end

@implementation HCMainViewController

@synthesize projectEntity;

#pragma mark 懒加载FilePathArray
-(NSMutableArray *)FilePathArray{
    if (!_FilePathArray) {
        _FilePathArray = [NSMutableArray array];
    }
    
    return _FilePathArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self setTableviewInfo];
    
#pragma mark 获取初始数据
    [self OpenProjectWithProjectid:self.projectEntity.statuse.projectid];
    
#pragma mark 设置返回按钮
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *leftB = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:(UIBarButtonItemStylePlain) target:self action:@selector(LeftAction:)];
        leftB;
    });
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15], NSFontAttributeName,nil] forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
#pragma mark 设置tableview的分割线
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
#pragma mark 设置无多余的分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UILabel *FilePath = [[UILabel alloc]init];
    FilePath.text = [self SetPath];
    FilePath.textColor = [UIColor blackColor];
    FilePath.textAlignment = NSTextAlignmentLeft;
    self.FilePath = FilePath;
    
#pragma mark 初始化点击判断变量
    self.Index = 2000;
    
    self.FilePath.frame = CGRectMake(0, -32, self.view.w, 25);
    
    [self.view addSubview:self.FilePath];
    
    self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0);
    self.flag = 1;
}

#pragma mark 设置头部文件路径
-(NSString *)SetPath{
    NSString *Path = [[NSString alloc]initWithFormat:@"    项目目录：%@", self.projectEntity.statuse.name ];
    for (HCFilerecord *ST in self.FilePathArray) {
        NSString *name =[@"/" stringByAppendingString:ST.name];
        Path = [Path stringByAppendingString:name];
    };
    return Path;
}

-(void)setTableviewInfo{
#pragma mark 设置代理和数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark 左边按钮事件
- (void)LeftAction:(UIBarButtonItem *)sender {
    //先去除随后一位
    [self.FilePathArray removeLastObject];
    //从新设置目录路径
    self.FilePath.text = [self SetPath];
    //获取最后一位
    HCFilerecord *NewlastPath = [self.FilePathArray lastObject];
    //根目录flag（第一次）
    if ([self.FilePath.text isEqualToString:[[NSString alloc]initWithFormat:@"    项目目录：%@",self.projectEntity.statuse.name]]) {
        self.flag ++;
        //当一次来就会++变成2
        if (self.flag == 2) {
            //跳转
            CenterViewController *centerVC = [[CenterViewController alloc] init];
            
            LeftViewController *leftVC = [LeftViewController new];
            
            RightViewController *rightVC = [RightViewController new];
            
            self.view.window.rootViewController = [[RootViewController alloc] initWithCenterVC:centerVC rightVC:rightVC leftVC:leftVC];
        }
        else{
            [self OpenProjectWithProjectid:self.projectEntity.statuse.projectid];
        }
    }else{
        self.flag = 0;
        [LBProgressHUD showHUDto:self.view animated:YES];
        self.view.userInteractionEnabled =NO;
    #pragma mark 拼接url
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *openUrl = [[NSString alloc]initWithFormat:@"http://rovibim.cn/androidside.jsp?action=openfile&recordid=%d",NewlastPath.recordid];
        [manager GET:openUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
                
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSMutableArray *arry = responseObject;
            self.FilesCellFrame = [self ResponseObjectWithArry:arry andResponseObject:responseObject];
            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled =YES;
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            HCLog(@"请求失败%@",error);
        }];
    };
}


#pragma mark -  3. 实现数据源（代理）方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.FilesCellFrame.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCFileCellFrame *cellFrame = self.FilesCellFrame[indexPath.row];
    return [cellFrame cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delaysContentTouches = NO;
    HCFileCell *cell = [HCFileCell cellWithTabbleView:tableView];
    
    cell.FileCellFrm = self.FilesCellFrame[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.flag = 0 ;
    if (self.Index == indexPath.row) {
        return;
    };
    
    HCFileCell *cell = [[HCFileCell alloc]init];
    cell.FileCellFrm = self.FilesCellFrame[indexPath.row];
    self.Index = indexPath.row;
    //如果不是文件夹
    if (![cell.FileCellFrm.Filerecord.kind isEqualToString:@"folder"]) {
        
        NSString *path=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",cell.FileCellFrm.Filerecord.name]];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if(![fileManager fileExistsAtPath:path]) //如果不存在
        {
            [LBProgressHUD showHUDto:self.view animated:YES];
            self.view.userInteractionEnabled =NO;
            
            HCAccount *user = [HCAuthTool user];
            
            NSString *openUrl = [[NSString alloc]initWithFormat:@"http://rovibim.cn/download.action?recordid=%d&userid=%@",cell.FileCellFrm.Filerecord.recordid,user.username];
            [LBProgressHUD showHUDto:self.view animated:YES];
            // 1、 设置请求
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:openUrl]];
            // 2、初始化
            NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager * manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            // 3、开始下载
            NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 设置进度条的百分比
                    HCLog(@"%@", downloadProgress);//下载进度
                });
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSLog(@"%@",path);
                return [NSURL fileURLWithPath:path];//转化为文件路径
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
                self.view.userInteractionEnabled =YES;
                
                //下载成功
                if (error == nil) {
                    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    [self.view addSubview:HUD];
                    HUD.labelText = @"文件下载完毕，正在打开";
                    HUD.mode = MBProgressHUDModeCustomView;
                    [HUD showAnimated:YES whileExecutingBlock:^{
                        sleep(2);
                    } completionBlock:^{
                        [HUD removeFromSuperview];
                        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        //声明
                        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
                        
                        self.documentController.delegate = self;
                        
                        [self.documentController presentPreviewAnimated:YES];
                    }];
                    //如果请求没有错误(请求成功), 则打印地址
                    self.Index = 2000;
                }else{//下载失败的时候，只列举判断了两种错误状态码
                    NSString * message = nil;
                    if (error.code == - 1005) {
                        message = @"网络异常";
                    }else if (error.code == -1001){
                        message = @"请求超时";
                    }else{  
                        message = @"未知错误";  
                    }  
                    HCLog(@"%@", error);
                }  
            }];
            [task resume];
            
        }else{
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"本地文件正在打开";
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [HUD removeFromSuperview];
                //声明
                self.documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
                
                self.documentController.delegate = self;
                
                [self.documentController presentPreviewAnimated:YES];
            }];
            self.Index = 2000;
        }
    }else{
        self.Index = 2000;
        [self OpenFolderWithRecordid:cell];
    };
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(NSMutableArray *)ResponseObjectWithArry:(NSMutableArray *)array andResponseObject:(id)responseObject{
    NSMutableArray *FoldercellFrmsM = [NSMutableArray array];
    NSMutableArray *FileCellFrmsM = [NSMutableArray array];
    for (id object in array) {
        HCFileCellFrame *cellFrm = [[HCFileCellFrame alloc] init];
        NSString *name = object;
        NSDictionary *tool = responseObject[name];
        HCFilerecord *File = [HCFilerecord objectWithKeyValues:tool];
        cellFrm.Filerecord = File;
        if ([cellFrm.Filerecord.kind isEqualToString:@"folder"]) {
            [FoldercellFrmsM addObject:cellFrm];
        }else{
            [FileCellFrmsM addObject:cellFrm];
        }
    };
    if (FoldercellFrmsM.count != 0) {
        for(NSUInteger i = 0; i < FoldercellFrmsM.count - 1; i++) {
            for(NSUInteger j = 0; j < FoldercellFrmsM.count - i - 1; j++) {
                HCFileCellFrame *FileFirst = FoldercellFrmsM[j];
                HCFileCellFrame *FileSecond = FoldercellFrmsM[j + 1];
                NSString *pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.name];
                NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.name];
                //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                    HCFileCellFrame *tempString = FoldercellFrmsM[j];
                    FoldercellFrmsM[j] = FoldercellFrmsM[j + 1];
                    FoldercellFrmsM[j + 1] = tempString;
                }
            }
        };
    };
    if (FileCellFrmsM.count != 0) {
        for(NSUInteger i = 0; i < FileCellFrmsM.count - 1; i++) {
            for(NSUInteger j = 0; j < FileCellFrmsM.count - i - 1; j++) {
                HCFileCellFrame *FileFirst = FileCellFrmsM[j];
                HCFileCellFrame *FileSecond = FileCellFrmsM[j + 1];
                NSString *pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.Filerecord.name];
                NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.Filerecord.name];
                //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                    HCFileCellFrame *tempString = FileCellFrmsM[j];
                    FileCellFrmsM[j] = FileCellFrmsM[j + 1];
                    FileCellFrmsM[j + 1] = tempString;
                }
            }
        };
        [FoldercellFrmsM addObjectsFromArray:FileCellFrmsM];
    };
    return FoldercellFrmsM;
}

-(void)OpenFolderWithRecordid:(HCFileCell *)cell{
    [LBProgressHUD showHUDto:self.view animated:YES];
    self.view.userInteractionEnabled =NO;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *openUrl = [[NSString alloc]initWithFormat:@"http://rovibim.cn/androidside.jsp?action=openfile&recordid=%d",cell.FileCellFrm.Filerecord.recordid];
    [manager GET:openUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *arry = responseObject;
        if ( arry.count == 0) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"该文件夹下没有内容";
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.Index = 2000;
            return;
        };
        self.FilesCellFrame = [self ResponseObjectWithArry:arry andResponseObject:responseObject];
        [self.FilePathArray addObject:cell.FileCellFrm.Filerecord];
        self.FilePath.text = [self SetPath];
        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled =YES;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"请求失败";
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        HCLog(@"请求失败%@",error);
    }];
}

-(void)OpenProjectWithProjectid:(NSString *)projectid{
    [LBProgressHUD showHUDto:self.view animated:YES];
    self.view.userInteractionEnabled =NO;
#pragma mark 拼接url
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *openUrl = [[NSString alloc]initWithFormat:@"http://rovibim.cn/androidside.jsp?action=openproject&projectid=%@",projectid];
    [manager GET:openUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *arry = responseObject;
        if (arry.count == 0) {
            [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.labelText = @"该工程尚未开始";
            HUD.mode = MBProgressHUDModeCustomView;
            [HUD showAnimated:YES whileExecutingBlock:^{
                sleep(2);
            } completionBlock:^{
                [HUD removeFromSuperview];
            }];
            return;
        };
        self.FilesCellFrame = [self ResponseObjectWithArry:arry andResponseObject:responseObject];
        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.view.userInteractionEnabled =YES;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HCLog(@"请求失败%@",error);
        [LBProgressHUD showHUDto:self.view animated:YES];
    }];
}

//必须实现的代理方法 预览窗口以模式窗口的形式显示，因此需要在该方法中返回一个view controller ，作为预览窗口的父窗口。如果你不实现该方法，或者在该方法中返回 nil，或者你返回的 view controller 无法呈现模式窗口，则该预览窗口不会显示。
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}

//可选的2个代理方法 （主要是调整预览视图弹出时候的动画效果，如果不实现，视图从底部推出）
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller {
    return self.view.frame;
}

//- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
//
//{
//    
//    return self;
//    
//}
//
//- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
//
//{
//    
//    return self.view;
//    
//}
//
//- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
//
//{
//    
//    return self.view.frame;
//    
//}
//
//- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)_controller
//
//{
//    NSLog(@"qwerqrqrqereqreqrqw");
////    [_controller autorelease];
//    
//}

@end

