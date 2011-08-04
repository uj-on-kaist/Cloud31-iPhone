//
//  ReplyPostViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "Three20/Three20.h"

@interface ReplyPostViewController : TTPostController {
    MBProgressHUD *HUD;
    NSString *feed_id;
}

@property (nonatomic, retain) NSString *message_id;

@end