//
//  KBMBatteryManager.h
//  BatteryManager
//
//  Created by 千葉 俊輝 on 2013/10/20.
//  Copyright (c) 2013年 koganepj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBMBatteryManager : NSObject
@property (retain, nonatomic) UILabel *batteryLabel;
+ (KBMBatteryManager*)sharedManager;
- (void)batteryLevelDidChange;
@end
