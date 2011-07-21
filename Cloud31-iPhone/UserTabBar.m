//
//  UserTabBar.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "UserTabBar.h"


@implementation UserTabBar

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

-(void)setItems{
    profile = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"usertab_profile.png"] tag:0];
    feed = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"usertab_feed.png"] tag:1];
    at = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"usertab_at.png"] tag:2];
    favorite = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"usertab_favorite.png"] tag:3];
    
    NSArray *array=[NSArray arrayWithObjects:profile,feed,at,favorite,nil];
    [self setItems:array];
    
    [self setSelectedItem:profile];
    
    bubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_bubble.png"]];
    //22
    bubble.frame=CGRectMake(30,-8, 19, 10);
    [self addSubview:bubble];
}

-(void)tabbarSelected:(int)index{
    int position = 80*index+30;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect frame = bubble.frame;
    frame.origin.x=position;
    bubble.frame=frame;
    
    // Commit the changes
    [UIView commitAnimations];
}


-(void)selectItem:(int)index{
    switch (index) {
        case 0:
            [self setSelectedItem:profile];
            break;
        case 1:
            [self setSelectedItem:feed];
            break;
        case 2:
            [self setSelectedItem:at];
            break;
        case 3:
            [self setSelectedItem:favorite];
            break;
        default:
            [self setSelectedItem:nil];
            break;
    }
}


@end
