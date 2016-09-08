#import "HCFileView.h"
#import "KSStringMatching.h"
@interface HCFileView()

@property(nonatomic,weak) UIImageView *profileImgView;//头像
@property(nonatomic,weak) UILabel *screenNameLabel;//昵称
@end

@implementation HCFileView

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
    
    }
    
    return self;
}

-(void)setFileFrm:(HCFileViewFrame *)FileFrm{
    _FileFrm = FileFrm;
    
    HCFilerecord *Filerecord = FileFrm.Filerecord;
    
    // 设置自身frm
    self.frame = FileFrm.selfFrm;
    
    // 设置项目图片
    self.profileImgView.frame = FileFrm.profileFrm;
    if ([Filerecord.kind isEqualToString:@"folder"]){
        self.profileImgView.image = [UIImage imageNamed:@"folder"];
    }else{
//        NSString *searchText = @"// Do any additional setup after loading the view, typically from a nib.";
//        NSError *error = NULL;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(?:[^,])*\\." options:NSRegularExpressionCaseInsensitive error:&error];
//        NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
//        if (result) {
//            NSLog(@"%@\n", [searchText substringWithRange:result.range]);
//        }
//        NSRange range = [Filerecord.name rangeOfString:@"."];
//        NSUInteger location = range.location;
//        NSString *kind = [Filerecord.name substringFromIndex:location];
        NSRange lastSymbol = [Filerecord.name rangeOfString:@"." options:NSBackwardsSearch];
        NSUInteger location = lastSymbol.location + 1;
        NSString *kind = [Filerecord.name substringFromIndex:location];
        self.profileImgView.image = [UIImage imageNamed:[kind lowercaseString]];
    };
    
    
    // 显示名称
    self.screenNameLabel.text = Filerecord.name;
    self.screenNameLabel.font = HCStatusOriginalSNFont;
    self.screenNameLabel.frame = FileFrm.screenNameFrm;
}

@end
