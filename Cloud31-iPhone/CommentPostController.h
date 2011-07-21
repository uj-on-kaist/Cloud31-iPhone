//
//  CommentPostController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Three20/Three20.h"
#import "MBProgressHUD.h"

@interface CommentPostController : TTPostController {
    MBProgressHUD *HUD;
    NSString *feed_id;
}

@property (nonatomic, retain) NSString *feed_id;

@end
