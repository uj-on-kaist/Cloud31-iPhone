//
//  RootViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HomeViewController.h"
#import "CompanyViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"
#import "SearchViewController.h"

#import "FeedPostViewController.h"


#import "RootTabBar.h"

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDelegate, UITabBarDelegate, FeedPostDelegate> {
    UIView *titleView;
    
    IBOutlet RootTabBar *_tabBar;
    
    HomeViewController *homeViewController;
    CompanyViewController *companyViewController;
    MessageViewController *messageViewController;
    SearchViewController *searchViewController;
    SettingViewController *settingViewController;
        
    UIViewController *currentViewController;
}

@property (nonatomic ,retain) IBOutlet RootTabBar *_tabBar;

@end
