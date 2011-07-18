//
//  UserInfoContainer.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfoContainer : NSObject {
    NSString *userID;
    NSString *userPW;
    
    NSDictionary *userInfo;
}
@property (nonatomic, retain)   NSString *userID;
@property (nonatomic, retain)   NSString *userPW;
@property (nonatomic, retain)   NSDictionary *userInfo;
+ (UserInfoContainer *)sharedInfo;


-(BOOL)saveUserLoginInfo;

-(BOOL)checkLogin;

-(void)logout;
@end
