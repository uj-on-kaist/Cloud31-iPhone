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
}

@property (nonatomic, retain) UILabel *label;
@end
