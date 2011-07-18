//
//  FeedTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;

@interface FeedTableViewCell : UITableViewCell {
    EGOImageView *profileView;
    
    UILabel *author_label;
    UILabel *contents_label;
    
    UILabel *date_label;
}

-(void)prepareData:(NSDictionary *)item;
+(CGFloat)calculateHeight:(NSDictionary *)item;

@end
