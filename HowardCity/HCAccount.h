#import <Foundation/Foundation.h>

@interface HCAccount : NSObject

/**　string	用户账号*/
@property (nonatomic, copy) NSString *username;

/**　string	用户密码*/
@property (nonatomic, copy) NSString *userpassword;

/**	用户登录的时间 */
@property (nonatomic, strong) NSDate *created_time;

/**　用户的生命周期，单位是秒数。*/
@property (nonatomic, copy) NSNumber *expires_in;

+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
