//
//  KBMBatteryManager.m
//  BatteryManager
//
//  Created by 千葉 俊輝 on 2013/10/20.
//  Copyright (c) 2013年 koganepj. All rights reserved.
//

#import "KBMBatteryManager.h"

@interface KBMBatteryManager()
@property (assign, nonatomic) float judgementNumeric;
- (void)initilaizeJudgementNumeric;
- (void)batteryStateDidChange;
- (void)setLocalNotification:(UIDeviceBatteryState)state;
@end

@implementation KBMBatteryManager
static KBMBatteryManager* _sharedManager = nil;

//シングルトン
+ (KBMBatteryManager*)sharedManager
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[KBMBatteryManager alloc] init];
    });
    return _sharedManager;
}

#pragma -
#pragma - SystemLifeCicle
- (id)init
{
    self = [super init];
    if (self) {
        // 初期処理
        [UIDevice currentDevice].batteryMonitoringEnabled = YES;
        
        //バッテリー残量が変わったらbatteryLevelDidChangeにメッセージを送る
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batteryLevelDidChange)
                                                     name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        //バッテリーの充電ステータスが変わったらbatteryLevelDidChangeにメッセージを送る
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(batteryStateDidChange)
                                                     name:UIDeviceBatteryStateDidChangeNotification object:nil];
        //label初期化
        _batteryLabel = [UILabel new];
        _batteryLabel.frame = CGRectMake(0, 0, 320, 100);
        _batteryLabel.backgroundColor = [UIColor grayColor];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
        _batteryLabel.font = [UIFont fontWithName:@"GeezaPro-Bold" size:20.0f];
        
        //判定数値の初期化
        [self initilaizeJudgementNumeric];
        
        //最初は明示的に呼ぶ
        [self batteryLevelDidChange];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (void)initilaizeJudgementNumeric {
    _judgementNumeric = 100;
}

//バッテリーの数値が変わったら呼ばれる
- (void)batteryLevelDidChange {
    //テキストにバッテリー残量セット
    _batteryLabel.text = [NSString stringWithFormat:@"%.1f%%",[UIDevice currentDevice].batteryLevel * 100];
    
    //バッテリーの状態取得
    [self batteryStateDidChange];
}

//バッテリーの状態が変わったら呼ばれる
- (void)batteryStateDidChange {
    //ラベルの色を初期化
    _batteryLabel.textColor = [UIColor blackColor];
    
    //通知の設定
    [self setLocalNotification:[UIDevice currentDevice].batteryState];
    
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnknown) {
        // バッテリー状態取得不能
        _batteryLabel.text = @"取得できません";
        _batteryLabel.textColor = [UIColor redColor];
        return;
    }
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateUnplugged) {
        // バッテリー使用中
        if([UIDevice currentDevice].batteryLevel * 100 <= 80) {
            _batteryLabel.textColor = [UIColor orangeColor];
            return;
        }
        
        if([UIDevice currentDevice].batteryLevel * 100 <= 60) {
            _batteryLabel.textColor = [UIColor yellowColor];
            return;
        }
        
        if([UIDevice currentDevice].batteryLevel * 100 <= 20) {
            _batteryLabel.textColor = [UIColor redColor];
            return;
        }
        
        return;
    }
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateCharging) {
        // バッテリー充電中
        _batteryLabel.textColor = [UIColor greenColor];
        return;
    }
    if ([UIDevice currentDevice].batteryState == UIDeviceBatteryStateFull) {
        // バッテリーフル充電状態
        _batteryLabel.text = @"フル充電";
        _batteryLabel.textColor = [UIColor greenColor];
        return;
    }
    
    return;
}

//バッテリーが減ったことを通知するためにセットする
- (void)setLocalNotification:(UIDeviceBatteryState)state {
    
    // 通知を一度削除
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //バッテリー使用中なら通知登録
    if (state == UIDeviceBatteryStateUnplugged && _judgementNumeric > [UIDevice currentDevice].batteryLevel * 100) {
        
        // 通知を作成する
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        notification.fireDate = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //どのくらい減ったか計算してセット
        notification.alertBody = [NSString stringWithFormat:@"バッテリーが%.1f%%消費しています",_judgementNumeric - [UIDevice currentDevice].batteryLevel * 100];
        notification.alertAction = @"対策";
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        // 通知を登録する
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        //判定数値の更新
        _judgementNumeric = [UIDevice currentDevice].batteryLevel * 100;
    }
    //充電でバッテリーが増えてる場合は判定数値を更新する
    else if(state != UIDeviceBatteryStateUnknown){
        //判定数値の更新
        _judgementNumeric = [UIDevice currentDevice].batteryLevel * 100;
    }
}

@end
