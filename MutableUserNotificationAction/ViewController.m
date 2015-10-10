//
//  ViewController.m
//  MutableUserNotificationAction
//
//  Created by tarena on 15/10/9.
//  Copyright (c) 2015年 ady. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//发送通知
- (IBAction)sendNotification:(UIButton *)sender {
    //1.创建消息上面要添加的动作(按钮的形式显示出来)
    UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc]init];
    action.identifier = @"action";//按钮的标识
    action.title = @"Accept";//按钮的标题
    action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
    
    UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc]init];//第二按钮
    action2.identifier = @"action2";
    action2.title = @"Reject";
    action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，后台处理
    action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
    action2.destructive = YES;
    
    //2.创建动作(按钮)的类别集合
    UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc]init];
    categorys.identifier = @"alert";//这组动作的位移标识
    [categorys setActions:@[action,action2] forContext:UIUserNotificationActionContextMinimal];
    
    //3.创建UIUserNotificationSettings，并设置消息的显示类类型
    UIUserNotificationSettings *setings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:[NSSet setWithObjects:categorys, nil]];
    
    //4.注册推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];//远程
    [[UIApplication sharedApplication] registerUserNotificationSettings:setings];
    
    //5.发送本地通知
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];//五秒后通知
    notification.timeZone = [NSTimeZone defaultTimeZone];// 设置时区（此为默认时区）
    //notification.repeatInterval = 0; // 设置重复间隔（默认0，不重复推送）
    notification.alertBody = @"测试推送快捷回复";
    notification.category = @"alert";
    notification.applicationIconBadgeNumber += 1;//应用的红色数字
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    //用这两个方法判断是否注册成功
    // NSLog(@"currentUserNotificationSettings = %@",[[UIApplication sharedApplication] currentUserNotificationSettings]);
    //[[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
}

@end
