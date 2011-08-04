//
//  UserTabBar.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserTabBar : UITabBar {
    UIImageView *bubble;
    
    UITabBarItem *profile;
    UITabBarItem *feed;
    UITabBarItem *at;
    UITabBarItem *favorite;
}

-(void)setItems;
-(void)tabbarSelected:(int)index;

-(void)selectItem:(int)index;
-(void)updateTrianglePosition;
@end

