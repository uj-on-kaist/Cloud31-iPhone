//
//  CommentTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface CommentTableViewCell : UITableViewCell {
    EGOImageView *profileView;
    
    UILabel *author_label;
    UILabel *contents_label;
    
    UILabel *date_label;
        
    UIImageView *bgView;
}

-(void)prepareData:(NSMutableDictionary *)item;
+(CGFloat)calculateHeight:(NSMutableDictionary *)item;

@end
