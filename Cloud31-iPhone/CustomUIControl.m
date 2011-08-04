//
//  CustomUIControl.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "CustomUIControl.h"


@implementation CustomUIControl
@synthesize attach_id, parentScrollView, imageView;


-(void)deleteSelf{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Really reset?" message:@"첨부한 사진을 지우시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:nil] autorelease];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"예"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        for(UIView *view in [self.parentScrollView subviews]){
            if(view.hidden){
                continue;
            }
            if(view.frame.origin.x > self.frame.origin.x){
                CGRect frame=view.frame;
                frame.origin.x -= (self.frame.size.width+20);
                view.frame=frame;
            }else if(view.frame.origin.x == self.frame.origin.x){
                
                view.hidden=YES;
            }
        }
        CGSize size = self.parentScrollView.contentSize;
        [self.parentScrollView setContentSize:CGSizeMake(size.width-self.frame.size.width-20, self.parentScrollView.contentSize.height)];
        self.userInteractionEnabled=NO;
        self.hidden=YES;
    }
}

@end
