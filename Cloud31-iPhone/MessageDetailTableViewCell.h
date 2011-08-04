//
//  MessageDetailTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

#import "Three20/Three20.h"

@interface MessageDetailTableViewCell : UITableViewCell {
    EGOImageView *profileView;
    
    UILabel *author_label;
    TTStyledTextLabel *contents_label;
    TTView *contents_bg;
    UILabel *date_label;
    
    UIImageView *profile_frame;
    UIView *smallFix;
}

-(void)prepareData:(NSMutableDictionary *)item;
+(CGFloat)calculateHeight:(NSMutableDictionary *)item;

@end
