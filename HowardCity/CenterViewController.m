#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "AFNetworking.h"
#import "HCStatuses.h"
#import "MJExtension.h"
#import "JSONKit.h"
#import "HCStatuseCellFrame.h"
#import "HCStatuseCell.h"
#import "StoryCommentCell.h"
#import "UIView+CZ.h"
#import "HCMainViewController.h"
#import "ProjectEntity.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "HCUserInfo.h"
#import "MBProgressHUD.h"
#import "LBProgressHUD.h"
#import "NSString+ChineseCharactersToSpelling.h"
#import "AppDelegate.h"

@interface CenterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isChange;
    BOOL _isH;
}
@property (nonatomic,strong) NSMutableArray *statusCellFrame;

@property (nonatomic,strong) NSMutableArray *statusCellFrameOld;

@property(nonatomic,strong)UIImage *image1;

@end

@implementation CenterViewController

-(NSMutableArray *)statuses{
    if (!_statusCellFrame) {
        _statusCellFrame = [NSMutableArray array];
    }
    
    return _statusCellFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableviewInfo];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    UIImage *NavigationLandscapeBackground =[[UIImage imageNamed:@"title_pad"]
                                             resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:NavigationLandscapeBackground forBarMetrics:UIBarMetricsDefault];
    
    // 轻扫手势
    UISwipeGestureRecognizer *leftswipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftswipeGestureAction:)];
    
    // 设置清扫手势支持的方向
    leftswipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    // 添加手势
    [self.view addGestureRecognizer:leftswipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightswipeGestureAction:)];
    
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipeGesture];
    
    [self initDate];
    
}

-(void)initDate{
    HCAccount *user = [HCAuthTool user];
    [LBProgressHUD showHUDto:self.view animated:YES];
    NSString *LoginUrl = [[NSString alloc]initWithFormat:@"http://rovibim.cn/androidside.jsp?action=projectlist&userid=%@",user.username];
#pragma mark 拼接url
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:LoginUrl parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
        HCLog(@"等待模式开启~~~~~~~~~~~~~~");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *arry = responseObject;
        NSMutableArray *cellFrmsM = [NSMutableArray array];
        for (id object in arry) {
            HCStatuseCellFrame *cellFrm = [[HCStatuseCellFrame alloc] init];
            NSString *name = object;
            NSDictionary *tool = responseObject[name];
            HCStatuses *stat = [HCStatuses objectWithKeyValues:tool];
            
            NSData *decodedImageData = [[NSData alloc]
                                        initWithBase64EncodedString:[tool objectForKey:@"img"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
            stat.img = decodedImage;
            NSString *SCPI = [tool objectForKey:@"admin"];
            HCLog(@"%@",SCPI);
            stat.SPI = [[SCPI substringToIndex:4] floatValue];
            stat.CPI = [[SCPI substringFromIndex:5] floatValue];
            stat.occupation = [tool objectForKey:@"occupation"];
            stat.people = [tool objectForKey:@"people"];
            stat.projectid = [tool objectForKey:@"projectid"];
            stat.space = [tool objectForKey:@"space"];
            cellFrm.statuse = stat;
            [cellFrmsM addObject:cellFrm];
        }
        for(NSUInteger i = 0; i < cellFrmsM.count - 1; i++) {
            for(NSUInteger j = 0; j < cellFrmsM.count - i - 1; j++) {
                HCStatuseCellFrame *FileFirst = cellFrmsM[j];
                HCStatuseCellFrame *FileSecond = cellFrmsM[j + 1];
                NSString *pinyinFirst = [NSString lowercaseSpellingWithChineseCharacters:FileFirst.statuse.name];
                NSString *pinyinSecond = [NSString lowercaseSpellingWithChineseCharacters:FileSecond.statuse.name];
                //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                    HCStatuseCellFrame *tempString = cellFrmsM[j];
                    cellFrmsM[j] = cellFrmsM[j + 1];
                    cellFrmsM[j + 1] = tempString;
                }
            }
        };
        self.statusCellFrame = cellFrmsM;
        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        HCLog(@"请求失败%@",error);
        [LBProgressHUD hideAllHUDsForView:self.view animated:YES];
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        if (error.code == - 1005) {
            HUD.labelText = @"网络异常,稍后自动重试";
        }else if (error.code == -1001){
            HUD.labelText = @"请求超时,稍后自动重试";
        }else{
            HUD.labelText = [[NSString alloc]initWithFormat:@"未知错误%ld,稍后自动重试",error.code];
        }
        HUD.mode = MBProgressHUDModeCustomView;
        [HUD showAnimated:YES whileExecutingBlock:^{
            sleep(4);
        } completionBlock:^{
            [HUD removeFromSuperview];
        }];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(initDate) userInfo:nil repeats:NO];
    }];
}


//- (void)onTapClick {
//
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    [CATransaction setAnimationDuration:2.0];
//    //    [self.colorLayer setBackgroundColor:[UIColor purpleColor].CGColor];
//    //    [self.view setBackgroundColor:[UIColor redColor]];
//    [CATransaction commit];
//    
//    //    [self.view.layer setPosition:CGPointMake(100, 100)];
//}

-(void)setTableviewInfo{
    //设置代理和数据源
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}


#pragma mark -  3. 实现数据源（代理）方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusCellFrame.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HCStatuseCellFrame *cellFrame = self.statusCellFrame[indexPath.row];
    return [cellFrame cellHeight];
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.indentationLevel = 2; // 缩进级别
    cell.indentationWidth = 40.f; // 每个缩进级别的距离
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delaysContentTouches = NO;
    HCStatuseCell *cell = [HCStatuseCell cellWithTabbleView:tableView];
    
    cell.statusCellFrm = self.statusCellFrame[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HCMainViewController *exm    = [[HCMainViewController alloc] init];
    HCStatuseCell *cell          = [HCStatuseCell cellWithTabbleView:tableView];
    cell.statusCellFrm           = self.statusCellFrame[indexPath.row];
    exm.hidesBottomBarWhenPushed = YES;
    ProjectEntity *projectEntity       = [[ProjectEntity alloc]init];
    projectEntity.statuse           = cell.statusCellFrm.statuse;
    HCLog(@"点击了%@",cell.statusCellFrm.statuse.name);
    [exm setProjectEntity:projectEntity];

    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:exm animated:YES];
}

- (UITableViewCell *)customCellForIndex:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString * detailId = kCellIdentifier;
    cell = [self.tableView dequeueReusableCellWithIdentifier:detailId];
    if (!cell)
    {
        cell = [StoryCommentCell storyCommentCellForTableWidth:self.tableView.frame.size.width];
    }
    return cell;
}

/**
 *  左轻扫
 */
- (void)leftswipeGestureAction:(UISwipeGestureRecognizer *)sender {
    
    UINavigationController *centerNC = self.navigationController;
    
    LeftViewController *leftVC  = self.navigationController.parentViewController.childViewControllers[0];
    RightViewController *rightVC = self.navigationController.parentViewController.childViewControllers[1];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            

            NSLog(@"1回来");
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            _isChange = !_isChange;
            return;
        }else {
            
            centerNC.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            leftVC.view.frame =CGRectMake(-250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            NSLog(@"左边");
            
        }
    }];
}

/**
 *  右轻扫
 */
- (void)rightswipeGestureAction:(UISwipeGestureRecognizer *)sender {
    UINavigationController *centerNC = self.navigationController;
    
    RightViewController *rightVC = self.navigationController.parentViewController.childViewControllers[1];
    
    LeftViewController *leftVC  = self.navigationController.parentViewController.childViewControllers[0];
    
    
    [UIView animateWithDuration:0.5 animations:^{
    
        
        if ( centerNC.view.center.x != self.view.center.x ) {
            
            leftVC.view.frame = CGRectMake(0, 0, 250, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 250, 0, 250, [UIScreen mainScreen].bounds.size.height);
            centerNC.view.frame = [UIScreen mainScreen].bounds;
            NSLog(@"3回来");
            
        }else{
            centerNC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            rightVC.view.frame = CGRectMake(250, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            NSLog(@"右边");

        }
    }];

}

#pragma mark 监听屏幕的旋转 ，ios8以前
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    HCLog(@"屏幕转了");
    NSMutableArray *cellFrmsM = [NSMutableArray array];
    for (HCStatuseCellFrame *object in self.statusCellFrame) {
        HCStatuseCellFrame *cellFrm = [[HCStatuseCellFrame alloc] init];
        cellFrm.statuse = object.statuse;
        [cellFrmsM addObject:cellFrm];
    };
    self.statusCellFrame = cellFrmsM;
    [self.tableView reloadData];
}


@end
