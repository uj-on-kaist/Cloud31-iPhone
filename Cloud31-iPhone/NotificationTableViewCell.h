//
//  NotificationTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 30..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

#import "Three20/Three20.h"

@interface NotificationTableViewCell : UITableViewCell {
    EGOImageView *profileView;
    
    TTStyledTextLabel *contents_label;
    
    UILabel *date_label;
    UIView *bgView;
}

-(void)prepareData:(NSMutableDictionary *)item;
+(CGFloat)calculateHeight:(NSMutableDictionary *)item;

@end
