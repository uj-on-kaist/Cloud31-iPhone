//
//  Cloud31_iPhoneAppDelegate.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cloud31_iPhoneAppDelegate : NSObject <UIApplicationDelegate> {

    NSString *app_status;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

-(void)checkLoginStatus;
- (void)application:(UIApplication *)application didReceiveRemoteNotificationFromFirstLaunch:(NSDictionary *)userInfo;

@end
