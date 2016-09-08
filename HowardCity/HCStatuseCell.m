#import "HCStatuseCell.h"
#import "HCStatuseOriginalView.h"

@interface HCStatuseCell()

@property(nonatomic,weak)HCStatuseOriginalView *originalView;

@end

@implementation HCStatuseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //项目View
        HCStatuseOriginalView *OriginalView = [[HCStatuseOriginalView alloc]init];
        
        OriginalView.backgroundColor = [UIColor whiteColor];
        //给bgView边框设置阴影
        OriginalView.layer.shadowOffset = CGSizeMake(1,1);
        OriginalView.layer.shadowOpacity = 0.3;
        OriginalView.layer.shadowColor = [UIColor blackColor].CGColor;
        [self.contentView addSubview:OriginalView];
         self.originalView = OriginalView;
        
    }
    return self;
}

+(instancetype)cellWithTabbleView:(UITableView *)tableView{
    static NSString *ID = @"StatusCell";
    
    HCStatuseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[HCStatuseCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    return cell;
}

//-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
//    if (highlighted == YES) {
//        HCLog(@"1111");
//    }else{
//        HCLog(@"2222");
//    }
//    [super setHighlighted:highlighted animated:animated];
//}

-(void)setStatusCellFrm:(HCStatuseCellFrame *)statusCellFrm{
    _statusCellFrm = statusCellFrm;
    
    //设置detailView的Frm
    self.originalView.originalFrm = statusCellFrm.originalFrm;
    
}

@end
