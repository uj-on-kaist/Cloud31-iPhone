//
//  UserProfileSmallView.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"


@interface UserProfileSmallView : UIControl {
    UILabel *name;
    UILabel *userID;
    UILabel *userDept;
    EGOImageView *picture;
    
    UIImageView *discloure;
}
@property (nonatomic,retain) EGOImageView *picture;
@property (nonatomic,retain) UILabel *name;
@property (nonatomic,retain) UILabel *userID;
@property (nonatomic,retain) UILabel *userDept;


-(void)disableLink;
-(void)scrollBackgroundColorSet;
@end
