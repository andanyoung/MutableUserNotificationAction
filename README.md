# MutableUserNotificationAction
.创建消息上面要添加的动作(按钮的形式显示出来)   
[objc] view plaincopy在CODE上查看代码片派生到我的代码片 
UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];  
action.identifier = @"action";//按钮的标示  
action.title=@"Accept";//按钮的标题  
action.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序  
//    action.authenticationRequired = YES;  
//    action.destructive = YES;  

UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮  
action2.identifier = @"action2";  
action2.title=@"Reject";  
action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理  
action.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；  
action.destructive = YES;  
2.创建动作(按钮)的类别集合
[objc] view plaincopy在CODE上查看代码片派生到我的代码片 
UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];  
categorys.identifier = @"alert";//这组动作的唯一标示  
[categorys setActions:@[action,action2] forContext:(UIUserNotificationActionContextMinimal)];  

3.创建UIUserNotificationSettings，并设置消息的显示类类型
[objc] view plaincopy在CODE上查看代码片派生到我的代码片 
UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:[NSSet setWithObjects:categorys, nil nil]];  
4.注册推送
[objc] view plaincopy在CODE上查看代码片派生到我的代码片 

[[UIApplication sharedApplication] registerUserNotificationSettings:uns];  
<pre name="code" class="objc">[[UIApplication sharedApplication] registerForRemoteNotifications];  

UserRequires call to registerUserNotificationSettings:• SilentInfo.plist UIBackgroundModes array contains remote-notification•
Can use both
离线push数据包带上特定Category字段（字段内容需要前后台一起定义，必须要保持一致），手机端收到时，就能展示上述代码对应Category设置的按钮，和响应按钮事件。
// payload example:  {"aps":{"alert":"Incoming call", "sound":"default", "badge": 1, "category":"incomingCall"}}
重大修改： 离线push数据包之前能带的数据最多为256字节，现在APPLE将该数值放大到2KB。 这个应该是只针对IOS8的。
5.发起本地推送消息
[objc] view plaincopy在CODE上查看代码片派生到我的代码片 
UILocalNotification *notification = [[UILocalNotification alloc] init];  
notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:5];  
notification.timeZone=[NSTimeZone defaultTimeZone];  
notification.alertBody=@"测试推送的快捷回复";  
notification.category = @"alert";  
[[UIApplication sharedApplication]  scheduleLocalNotification:notification];  

//用这两个方法判断是否注册成功  
// NSLog(@"currentUserNotificationSettings = %@",[[UIApplication sharedApplication] currentUserNotificationSettings]);  
//[[UIApplication sharedApplication] isRegisteredForRemoteNotifications];  
6.在AppDelegate.m里面对结果进行处理
[objc] view plaincopy在CODE上查看代码片派生到我的代码片 
//本地推送通知  
-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings  
{  
//成功注册registerUserNotificationSettings:后，回调的方法  
NSLog(@"%@",notificationSettings);  
}  

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification  
{  
//收到本地推送消息后调用的方法  
NSLog(@"%@",notification);  
}  

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler  
{  
//在非本App界面时收到本地消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮，notification为消息内容  
NSLog(@"%@----%@",identifier,notification);  
completionHandler();//处理完消息，最后一定要调用这个代码块  
}  

//远程推送通知  
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken  
{  
//向APNS注册成功，收到返回的deviceToken  
}  

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error  
{  
//向APNS注册失败，返回错误信息error  
}  

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo  
{  
//收到远程推送通知消息  
}  

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler  
{  
//在没有启动本App时，收到服务器推送消息，下拉消息会有快捷回复的按钮，点击按钮后调用的方法，根据identifier来判断点击的哪个按钮  
}  

运行之后要按shift + command +H，让程序推到后台，或者按command+L让模拟器锁屏，才会看到效果！
如果是程序退到后台了，收到消息后下拉消息，则会出现刚才添加的两个按钮；如果是锁屏了，则出现消息后，左划就会出现刚才添加的两个按钮。
效果如下：

现在只是能让消息中显示出按钮的形式，带输入框的还在研究中，如果大家研究出来了，也谢谢能分享一下啊，大家一起提高！