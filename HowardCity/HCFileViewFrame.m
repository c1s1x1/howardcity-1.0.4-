#import "HCFileViewFrame.h"

@implementation HCFileViewFrame

-(void)setFilerecord:(HCFilerecord *)Filerecord{
    
    _Filerecord = Filerecord;
    
    //开始计算frm
    //1.图片
    CGFloat profileX = HCStatusCellInset;
    CGFloat profileY = HCStatusCellInset * 2;
    CGFloat profileW = 60;
    CGFloat profileH = 60;
    self.profileFrm = CGRectMake(profileX, profileY, profileW, profileH);
    
    
    //2.项目名称(字体大小14)
    CGFloat snX = CGRectGetMaxX(self.profileFrm) + HCStatusCellInset + 20;
    CGFloat snY = HCStatusCellInset + 25;
    // 计算 "名称" 尺寸size
    NSDictionary *att = @{NSFontAttributeName:HCStatusOriginalSNFont};
    CGSize snSize = [Filerecord.name sizeWithAttributes:att];
    self.screenNameFrm = (CGRect){snX,snY,snSize};
    
    
    self.selfFrm = CGRectMake(20, 5, UIScreenW - 40, CGRectGetMaxY(self.profileFrm) + HCStatusCellInset);
    
}

@end
