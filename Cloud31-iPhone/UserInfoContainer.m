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
-(NSString *)getUserID{
    NSString *_userID=userID;
    if([_userID isEqualToString:@""] || !_userID){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _userID = [prefs stringForKey:@"userID"];
    }
    return _userID;
}
-(NSString *)getUserPW{
    NSString *_userPW=userPW;
    if([_userPW isEqualToString:@""] || !_userPW){
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        _userPW = [prefs stringForKey:@"userPW"];
    }
    return _userPW;
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
}

@end
