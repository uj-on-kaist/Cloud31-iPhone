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

@interface FeedDetailViewController : RLViewController<TTNavigatorDelegate, TTPostControllerDelegate> {
    NSMutableDictionary *item;
    TTStyledTextLabel *contents_label;
    NSMutableArray *comments;
}

@property (nonatomic, retain) NSMutableDictionary *item;

-(id)initWithItem:(NSMutableDictionary *)aItem;

@end
