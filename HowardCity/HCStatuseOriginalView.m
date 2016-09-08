#import "HCStatuseOriginalView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "HCAuthTool.h"
#import "HCAccount.h"
#import "HCUserInfo.h"
#import "LXGradientProcessView.h"

@interface HCStatuseOriginalView()

@property(nonatomic,weak) UIImageView *profileImgView;//头像
@property(nonatomic,weak) UILabel *screenNameLabel;//昵称
@property(nonatomic,weak) UILabel *moreLabel;//more
@property(nonatomic,weak) UILabel *SPILabel;//昵称
@property(nonatomic,weak) UILabel *CPILabel;//昵称
@property (nonatomic, strong) LXGradientProcessView *SPI;
@property (nonatomic, strong) LXGradientProcessView *CPI;

@end

@implementation HCStatuseOriginalView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        // 1.头像
        UIImageView *profileImgView = [[UIImageView alloc] init];
        profileImgView.layer.masksToBounds = YES;
        profileImgView.layer.cornerRadius = 20;
        [self addSubview:profileImgView];
        self.profileImgView = profileImgView;
        
        // 2.名称
        UILabel *screenNameLabel = [[UILabel alloc] init];
//        screenNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:screenNameLabel];
        self.screenNameLabel = screenNameLabel;
        HCLog(@"UIScreenW%f",UIScreenW);
        // 3.SPI
        //名称
        UILabel *SPILabel = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenW - 270, 10, 120, 40)];
        [self addSubview:SPILabel];
        self.SPILabel = SPILabel;
        // 渐变进度条
        LXGradientProcessView *SPIprogressView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(UIScreenW - 240, 20, 120, 40)];
        [self addSubview:SPIprogressView];
        self.SPI = SPIprogressView;
        
        // 4.CPI
        //名称
        UILabel *CPILabel = [[UILabel alloc] initWithFrame:CGRectMake(UIScreenW - 270, 50 + HCStatusCellInset, 120, 40)];
        [self addSubview:CPILabel];
        self.CPILabel = CPILabel;
        // 渐变进度条
        LXGradientProcessView *CPIprogressView = [[LXGradientProcessView alloc] initWithFrame:CGRectMake(UIScreenW - 240, 60 + HCStatusCellInset, 120.f, 45.f)];
        [self addSubview:CPIprogressView];
        self.CPI = CPIprogressView;
        
        // 2.名称
        UILabel *moreLabel = [[UILabel alloc] init];
//        moreLabel.textColor = [UIColor whiteColor];
        [self addSubview:moreLabel];
        self.moreLabel = moreLabel;
    
    }
    
    return self;
}

-(void)setOriginalFrm:(HCStatuseOriginalCellFrame *)originalFrm{
    _originalFrm = originalFrm;
    
    HCStatuses *statuse = originalFrm.statuse;
    
    // 设置自身frm
    self.frame = originalFrm.selfFrm;
    
    // 设置项目图片
    self.profileImgView.frame = originalFrm.profileFrm;
    self.profileImgView.image = statuse.img;
    
    // 显示名称
    self.screenNameLabel.text = statuse.name;
    self.screenNameLabel.font = HCStatusOriginalSNFont;
    self.screenNameLabel.frame = originalFrm.screenNameFrm;
    
    // 显示进度
    self.SPILabel.text = @"SPI:";
    self.SPILabel.font = HCStatusOriginalSCFont;
    self.SPI.percent = statuse.SPI / 2 * 100;
    self.SPILabel.frame = originalFrm.SPILableFrm;
    self.SPI.frame = originalFrm.SPIFrm;
    
    // 显示进度
    self.CPILabel.text = @"CPI:";
    self.CPILabel.font = HCStatusOriginalSCFont;
    self.CPI.percent = statuse.CPI / 2 * 100;
    NSLog(@"%f",statuse.CPI);
    if (statuse.CPI == 0) {
        self.CPI.percent = 50;
    };
    self.CPILabel.frame = originalFrm.CPILableFrm;
    self.CPI.frame = originalFrm.CPIFrm;
    
    // 显示more
    self.moreLabel.text = @"more";
    self.moreLabel.font = HCStatusOriginalSCFont;
    self.moreLabel.frame = originalFrm.moreFrm;
    
}


@end
