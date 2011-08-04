//
//  FeedListViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLViewController.h"


@interface FeedListViewController : RLViewController {
    NSString *_queryURL;
}
@property (nonatomic, retain) NSString *_queryURL;

- (id)initWithFrame:(CGRect)frame withQueryURL:(NSString *)queryURL;

@end
