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
    UITabBarItem *home = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_home.png"] tag:0];
    UITabBarItem *company = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_company.png"] tag:1];
    UITabBarItem *message = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_message2.png"] tag:2];
    UITabBarItem *search = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_search.png"] tag:3];
    UITabBarItem *setting = [[UITabBarItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"tab_setting.png"] tag:4];
    
    NSArray *array=[NSArray arrayWithObjects:home,company,message,search,setting,nil];
    [self setItems:array];
    
    [self setSelectedItem:home];
    
    bubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar_bubble.png"]];
    //22
    bubble.frame=CGRectMake(22,-8, 19, 10);
    [self addSubview:bubble];
    
    
    [self updateCount];
}

int startPosition = 22;
int distance = 64;

-(void)tabbarSelected:(int)index{
    int position = distance*index+startPosition;
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

-(void)updateCount{
    UITabBarItem *setting = (UITabBarItem *)[[self items] objectAtIndex:4];
    
    NSInteger badge = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    if(badge == 0){
        [setting setBadgeValue:nil];
    }else{
        [setting setBadgeValue:[NSString stringWithFormat:@"%d",badge]];
    }
    
}

-(void)updateTrianglePosition{
    UIDeviceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight ){
        startPosition = 38; distance = 96;
    }else{
        startPosition = 22; distance = 64;
    }
    
    [self tabbarSelected:[[self selectedItem] tag]];
}

@end
