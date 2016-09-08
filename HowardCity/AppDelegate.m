//
//  AppDelegate.m
//  HowardCity
//
//  Created by 紫月 on 16/4/15.
//  Copyright (c) 2016年 CSX. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "HCLoginViewController.h"
#import "HCAuthTool.h"
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([HCAuthTool IsLogin]) {
//        UIWindow *window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        self.window = window;
//        window.rootViewController = [[RootViewController alloc]init];
//        [window makeKeyAndVisible];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.backgroundColor = [UIColor whiteColor];
        
        CenterViewController *centerVC = [[CenterViewController alloc] init];
        
        LeftViewController *leftVC = [LeftViewController new];
        
        RightViewController *rightVC = [RightViewController new];
        
        self.window.rootViewController = [[RootViewController alloc] initWithCenterVC:centerVC rightVC:rightVC leftVC:leftVC];
        [self.window makeKeyAndVisible];
        return YES;
    }else{
        return YES;
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (_rotation_Style == 1) {//如果是1就让屏幕强制竖屏
        
        return (UIInterfaceOrientationMaskPortrait);
        
    }
    
    else
        
    {
        return UIInterfaceOrientationMaskAll;
        
    };
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
