//
//  RootTabBar.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "RootTabBar.h"


@implementation RootTabBar


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

-(void)setItems{
    UITabBarItem *feed = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_feed.png"] tag:0];
    UITabBarItem *message = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_message.png"] tag:1];
    UITabBarItem *search = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_search.png"] tag:2];
    UITabBarItem *more = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_more.png"] tag:3];
    
    NSArray *array=[NSArray arrayWithObjects:feed,message,search,more,nil];
    [self setItems:array];
    
    [self setSelectedItem:feed];
}

@end
