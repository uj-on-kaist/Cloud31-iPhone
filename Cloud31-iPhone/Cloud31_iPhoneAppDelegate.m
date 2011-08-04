//
//  Cloud31_iPhoneAppDelegate.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "Cloud31_iPhoneAppDelegate.h"
#import "UserInfoContainer.h"

#import "RootViewController.h"
#import "SignViewController.h"
#import "NotificationViewController.h"
#import <AudioToolbox/AudioToolbox.h>

#import "StyleSheet.h"
#import "Three20/Three20.h"
@implementation Cloud31_iPhoneAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;


-(void)checkLoginStatus{
    if(![[UserInfoContainer sharedInfo] checkLogin]){
        [self.navigationController setViewControllers:[NSArray arrayWithObject:[[SignViewController alloc] init]]];
    }
    [self.window makeKeyAndVisible];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TTStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];
    [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
    
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    
    self.navigationController.navigationBar.tintColor=RGB2(29, 45, 64);
    
    if([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] != nil){
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotificationFromFirstLaunch:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
    }
    //[self checkLoginStatus];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [self checkLoginStatus];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{ 
    NSMutableString *deviceId = [NSMutableString string]; 
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes]; 
    NSLog(@"%@",deviceToken);
    for(int i = 0 ; i < 32 ; i++) 
    { 
        [deviceId appendFormat:@"%02x", ptr[i]]; 
    } 
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:deviceId forKey:@"apsn_device_token"];
    [prefs synchronize];
    NSLog(@"APNS Device Token: %@", deviceId);
} 
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"Failed: %@",error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{ 
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //NSLog(@"%@",userInfo);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]];
    if([self.navigationController.visibleViewController respondsToSelector:@selector(got_notification)]){
        [self.navigationController.visibleViewController performSelector:@selector(got_notification)];
    }
    
    if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
        return;
    }

    if(![self.navigationController.visibleViewController isKindOfClass:[SignViewController class]] ){
        NotificationViewController *notificationViewController=[[NotificationViewController alloc] init];
        [self.navigationController pushViewController:notificationViewController animated:YES];
        
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotificationFromFirstLaunch:(NSDictionary *)userInfo
{ 
    if(![[UserInfoContainer sharedInfo] checkLogin]){
        [self.navigationController setViewControllers:[NSArray arrayWithObject:[[SignViewController alloc] init]]];
        [self.window makeKeyAndVisible];
        return;
    }else{
        [self.navigationController setViewControllers:[NSArray arrayWithObject:[[RootViewController alloc] init]]];
    }
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //NSLog(@"%@",userInfo);
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue]];
    if([self.navigationController.visibleViewController respondsToSelector:@selector(got_notification)]){
        [self.navigationController.visibleViewController performSelector:@selector(got_notification)];
    }
    
    NotificationViewController *notificationViewController=[[NotificationViewController alloc] init];
    [self.navigationController pushViewController:notificationViewController animated:YES];
    
}

@end
