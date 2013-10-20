//
//  KBMAppDelegate.m
//  BatteryManager
//
//  Created by 千葉 俊輝 on 2013/10/19.
//  Copyright (c) 2013年 koganepj. All rights reserved.
//

#import "KBMAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"
#import "KBMBatteryManager.h"

@implementation KBMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Crashlytics 初期化 絶対一番上
    [Crashlytics startWithAPIKey:@"134f98bed84563329183f9853f108d9632d03cf2"];
    
    // Flurry 初期化 クラッシュレポートは競合しちゃうので NOに
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    //[Flurry setCrashReportingEnabled:NO];
    //TODO:API Key 変更
    //[Flurry startSession:@"APIKEY"];
    
    // logイベント
    // TODO:あとで設計を考える
    //[Flurry logEvent:@"didFinishLaunch"];

    
    //backgroundfetchの設定
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    //バッテリー情報の更新や通知の設定
    [[KBMBatteryManager sharedManager] batteryLevelDidChange];
    
    completionHandler(UIBackgroundFetchResultNewData);
}
@end
