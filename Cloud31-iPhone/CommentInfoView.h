//
//  CommentInfoView.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 19..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommentInfoView : UIView {
    UILabel *label;
    UIImageView *favorite;
    
    NSMutableArray *attach_view_arr;
}

@property (nonatomic, retain) UILabel *label;

-(void)setStarOn;
-(void)setStarOff;
-(void)setCommentCount:(int)count;

-(void)setAttachInfo:(NSArray *)file_list withLocation:(BOOL)has_location;

@end
