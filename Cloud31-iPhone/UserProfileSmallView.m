//
//  UserProfileSmallView.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "UserProfileSmallView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UserProfileSmallView

@synthesize picture, name, userID,userDept;

- (id)init{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 70)];
    if (self) {
        picture = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"empty.png"]];
        picture.frame= CGRectMake(10, 10, 50, 50);
        picture.layer.cornerRadius=5;
        picture.clipsToBounds=YES;
        picture.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:picture];
        
        name=[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 16)];
        name.backgroundColor=[UIColor clearColor];
        name.font=[UIFont boldSystemFontOfSize:16.0f];
        name.textColor = [UIColor darkTextColor];
        name.shadowColor = RGBA2(255, 255, 255, 0.75);
        name.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:name];
        
        userID=[[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 14)];
        userID.backgroundColor=[UIColor clearColor];
        userID.font=[UIFont systemFontOfSize:13.0f];
        userID.textColor = [UIColor darkTextColor];
        userID.shadowColor = RGBA2(255, 255, 255, 0.5);
        userID.shadowOffset = CGSizeMake(0.0, 1.0);
        userID.shadowOffset = CGSizeMake(1.0, 1.0);
        [self addSubview:userID];
        
        userDept=[[UILabel alloc] initWithFrame:CGRectMake(70, 45, 200, 14)];
        userDept.backgroundColor=[UIColor clearColor];
        userDept.font=[UIFont systemFontOfSize:13.0f];
        userDept.textColor = [UIColor darkTextColor];
        userDept.shadowColor = RGBA2(255, 255, 255, 0.5);
        userDept.shadowOffset = CGSizeMake(0.0, 1.0);
        userDept.shadowOffset = CGSizeMake(1.0, 1.0);
        [self addSubview:userDept];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [picture release];
    [name release];
    [userID release];
    [userDept release];
    [super dealloc];
}

@end
