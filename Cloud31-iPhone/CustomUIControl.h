//
//  CustomUIControl.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CustomUIControl : UIControl {
    NSString *attach_id;
    UIScrollView *parentScrollView;
    
    UIImageView *imageView;
    
}
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) NSString *attach_id;
@property (nonatomic, retain) UIScrollView *parentScrollView;

-(void)deleteSelf;

@end
