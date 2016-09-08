#import "HCStatuseOriginalCellFrame.h"

@implementation HCStatuseOriginalCellFrame

-(void)setStatuse:(HCStatuses *)statuse{
    
    _statuse = statuse;
    
    //开始计算frm
    //1.图片
    CGFloat profileX = HCStatusCellInset + 50;
    CGFloat profileY = HCStatusCellInset;
    CGFloat profileW = 100;
    CGFloat profileH = 100;
    self.profileFrm = CGRectMake(profileX, profileY, profileW, profileH);
    
    
    //2.项目名称(字体大小14)
    CGFloat snX = CGRectGetMaxX(self.profileFrm) + HCStatusCellInset + 50;
    CGFloat snY = HCStatusCellInset;
    // 计算 "名称" 尺寸size
    NSDictionary *att = @{NSFontAttributeName:HCStatusOriginalSNFont};
    CGSize snSize = [statuse.name sizeWithAttributes:att];
    self.screenNameFrm = (CGRect){snX,snY,snSize};
    
    //2.项目SPI CPI(字体大小14)
//    if (UIScreenW >= 1024) {
        self.SPILableFrm = CGRectMake(UIScreenW - 270, 10, 120, 40);
        
        self.SPIFrm = CGRectMake(UIScreenW - 240, 20, 120, 40);
        
        self.CPILableFrm = CGRectMake(UIScreenW - 270, 50 + HCStatusCellInset, 120, 40);
        
        self.CPIFrm = CGRectMake(UIScreenW - 240, 60 + HCStatusCellInset, 120.f, 45.f);
//    }else{
//        self.SPILableFrm = CGRectMake(UIScreenW - 270, 10, 120, 40);
//        
//        self.SPIFrm = CGRectMake(UIScreenW - 240, 20, 120, 40);
//        
//        self.CPILableFrm = CGRectMake(UIScreenW - 270, 10, 120, 40);
//        
//        self.CPIFrm = CGRectMake(UIScreenW - 240, 20, 120, 40);
//    }
    
    self.moreFrm = CGRectMake(UIScreenW - 80, 30, 60, 60);
    
    self.selfFrm = CGRectMake(20, 5, UIScreenW - 40 , CGRectGetMaxY(self.profileFrm) + HCStatusCellInset);
    
}


@end
