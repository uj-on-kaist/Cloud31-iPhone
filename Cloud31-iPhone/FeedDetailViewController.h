//
//  FeedDetailViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLViewController.h"

#import "Three20/Three20.h"
#import "MBProgressHUD.h"

@class  CommentInfoView;
@interface FeedDetailViewController : RLViewController<TTNavigatorDelegate, TTPostControllerDelegate, UIActionSheetDelegate> {
    NSMutableDictionary *item;
    TTStyledTextLabel *contents_label;
    NSMutableArray *comments;
    
    BOOL from_comment_update;
    
    CommentInfoView *comment_info;
    
    MBProgressHUD *HUD;
    
}

@property (nonatomic, retain) NSMutableDictionary *item;

-(id)initWithItem:(NSMutableDictionary *)aItem;
-(void)reloadData;
-(void)showTopicDetailController:(NSString *)query;
-(void)showUserDetailController:(NSString *)query;

@end
