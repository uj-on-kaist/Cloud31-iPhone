//
//  FeedTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

#import "Three20/Three20.h"

@interface FeedTableViewCell : UITableViewCell <EGOImageViewDelegate>{
    EGOImageView *profileView;
    
    TTStyledTextLabel *author_label;
    TTStyledTextLabel *contents_label;
    
    UILabel *date_label;
    UILabel *comment_label;
    UIImageView *favorite_image;
    UIImageView *favorite_off_image;
    
    
    UIImageView *attachFileView;
    UIImageView *attachImageView;
    UIImageView *attachGPSView;
    
    TTView *bubbleView;
    
    
    
}

-(void)prepareData:(NSMutableDictionary *)item;
+(CGFloat)calculateHeight:(NSMutableDictionary *)item;

@end
