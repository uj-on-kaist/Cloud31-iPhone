//
//  MessageDetailViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLViewController.h"
#import "Three20/Three20.h"
#import "MBProgressHUD.h"


@interface MessageDetailViewController : RLViewController <TTNavigatorDelegate, TTPostControllerDelegate, UIActionSheetDelegate> {
    NSMutableDictionary *item;
    BOOL from_comment_update;
    
    UIButton *commentPostView;
    
    MBProgressHUD *HUD;
}

@property (nonatomic, retain) NSMutableDictionary *item;

-(id)initWithItem:(NSMutableDictionary *)aItem;
-(void)reloadData;
@end
