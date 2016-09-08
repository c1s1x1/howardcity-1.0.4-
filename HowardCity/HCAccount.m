#import "HCAccount.h"

@implementation HCAccount

+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    HCAccount *account = [[self alloc] init];
    account.username = dict[@"username"];
    account.userpassword = dict[@"userpassword"];
    // 获得账号存储的时间
    account.created_time = [NSDate date];
    account.expires_in = [NSNumber numberWithInteger:604800];
    return account;
}

/**
 *  当一个对象要归档进沙盒中时，就会调用这个方法
 *  目的：在这个方法中说明这个对象的哪些属性要存进沙盒
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.userpassword forKey:@"userpassword"];
    [encoder encodeObject:self.created_time forKey:@"created_time"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
}

/**
 *  当从沙盒中解档一个对象时（从沙盒中加载一个对象时），就会调用这个方法
 *  目的：在这个方法中说明沙盒中的属性该怎么解析（需要取出哪些属性）
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.username = [decoder decodeObjectForKey:@"username"];
        self.userpassword = [decoder decodeObjectForKey:@"userpassword"];
        self.created_time = [decoder decodeObjectForKey:@"created_time"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
    }
    return self;
}

@end
