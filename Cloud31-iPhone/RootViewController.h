//
//  RootViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedViewController.h"

@class RootTabBar;

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDelegate, UITabBarDelegate> {
    IBOutlet RootTabBar *_tabBar;
    
    FeedViewController *feedController;
}

@property (nonatomic ,retain) IBOutlet RootTabBar *_tabBar;

@end
