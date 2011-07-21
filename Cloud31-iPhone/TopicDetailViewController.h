//
//  TopicDetailViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RLViewController.h"
@interface TopicDetailViewController : RLViewController {
    NSString *topic_id;
    NSMutableDictionary *topic_info;
}

@property (nonatomic, retain) NSString *topic_id;
@property (nonatomic, retain) NSMutableDictionary *topic_info;
-(id)initWithTopicID:(NSString *)a_id;
@end
