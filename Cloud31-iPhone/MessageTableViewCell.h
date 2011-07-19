//
//  MessageTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 19..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface MessageTableViewCell : UITableViewCell {
    EGOImageView *profileView;
    
    UILabel *member_label;
    UILabel *contents_label;
    
    UILabel *date_label;
}

-(void)prepareData:(NSMutableDictionary *)item;
+(CGFloat)calculateHeight:(NSMutableDictionary *)item;

@end
