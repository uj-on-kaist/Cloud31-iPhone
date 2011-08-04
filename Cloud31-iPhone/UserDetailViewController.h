//
//  UserDetailViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserTabBar.h"
#import "UserProfileSmallView.h"

#import "FeedListViewController.h"

@interface UserDetailViewController : UIViewController <UITableViewDelegate, UITableViewDelegate, UITabBarDelegate>{
    IBOutlet UserTabBar *_tabBar;
    
    NSString *_userID;
    
    IBOutlet UITableView *_userInfoView;
    
    NSMutableDictionary *userInfo;
    
    UserProfileSmallView *profileView;
    
    UIViewController *currentViewController;
    
    
    FeedListViewController *feedController;
    FeedListViewController *atController;
    FeedListViewController *favoriteController;
}
@property (nonatomic ,retain) IBOutlet UITableView *_userInfoView;
@property (nonatomic ,retain) IBOutlet UserTabBar *_tabBar;
@property (nonatomic ,retain) NSString *_userID;
@property (nonatomic ,retain) NSMutableDictionary *userInfo;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSString*)query;

-(void)selectTab:(int)index;
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item;

-(void)updateSubviewsOrientation;

@end
