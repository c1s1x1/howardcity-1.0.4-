#import <Foundation/Foundation.h>
#import "HCStatuses.h"

@interface HCStatuseOriginalCellFrame : NSObject

/**
 * 项目图片Frm
 */
@property(nonatomic,assign)CGRect profileFrm;

/**
 * 项目名称Frm
 */
@property(nonatomic,assign)CGRect screenNameFrm;

/**
 * 进度Frm
 */
@property(nonatomic,assign)CGRect SPIFrm;
@property(nonatomic,assign)CGRect SPILableFrm;

/**
 * 进度Frm
 */
@property(nonatomic,assign)CGRect CPIFrm;
@property(nonatomic,assign)CGRect CPILableFrm;

/**
 * moreFrm
 */
@property(nonatomic,assign)CGRect moreFrm;


/**
 * HCStatusOriginalView(原创微博View的frm)
 */
@property(nonatomic,assign)CGRect selfFrm;

@property(nonatomic,strong)HCStatuses *statuse;

@end
