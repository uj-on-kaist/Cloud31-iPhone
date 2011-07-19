//
//  UserInfoContainer.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "UserInfoContainer.h"

#import "ASIHTTPRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "Cloud31_iPhoneAppDelegate.h"
#import "SignViewController.h"

@implementation UserInfoContainer

@synthesize userID, userPW, userInfo;

static UserInfoContainer *sharedInfo = NULL;

+ (UserInfoContainer *)sharedInfo{
    @synchronized(self) {
        if (sharedInfo == NULL)
            sharedInfo = [[self alloc] init];
    }   
    return(sharedInfo);
}

-(BOOL)saveUserLoginInfo{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:userID forKey:@"userID"];
    [prefs setObject:userPW forKey:@"userPW"];
    [prefs synchronize];
    return YES;
}
-(NSString *)userID{
    NSString *_userID=userID;
    if([_userID isEqualToString:@""] || !_userID){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _userID = [prefs stringForKey:@"userID"];
    }
    return _userID;
}
-(NSString *)userPW{
    NSString *_userPW=userPW;
    if([_userPW isEqualToString:@""] || !_userPW){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _userPW = [prefs stringForKey:@"userPW"];
    }
    return _userPW;
}

-(NSDictionary *)userInfo{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDictionary *_userInfo = [prefs dictionaryForKey:@"userInfo"];
    return _userInfo;
}

-(BOOL)checkLogin{
    NSLog(@"Check Login Status");
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:LOGIN_CHECK_URL]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *theError = NULL;
        userInfo = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if(!theError && [[userInfo objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            NSDictionary *_userInfo = [NSDictionary dictionaryWithDictionary:userInfo];
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:_userInfo forKey:@"userInfo"];
            [prefs synchronize];
            return YES;
        }else{
            return NO;
        }
        
    }else{
        return NO;
    }
}

-(void)logout{
    NSLog(@"Logout");
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:LOGOUT_URL]];
    [request startSynchronous];
    
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app_delegate.navigationController setViewControllers:[NSArray arrayWithObject:[[SignViewController alloc] init]]];
}

@end
