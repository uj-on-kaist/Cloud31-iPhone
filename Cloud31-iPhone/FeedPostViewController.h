//
//  FeedPostViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FeedPostDelegate <NSObject>

@required
-(void)feedUploaded:(int)result;
@end

@interface FeedPostViewController : UIViewController <UIActionSheetDelegate> {
    IBOutlet UILabel *userLabel;
    IBOutlet UITextView *inputView;
    id<FeedPostDelegate> delegate;
    
    IBOutlet UIButton *atButton;
    IBOutlet UIButton *topicButton;
    IBOutlet UIButton *attachButton;
    IBOutlet UIButton *gpsButton;
}

@property (nonatomic, retain) IBOutlet UIButton *atButton;
@property (nonatomic, retain) IBOutlet UIButton *topicButton;
@property (nonatomic, retain) IBOutlet UIButton *attachButton;
@property (nonatomic, retain) IBOutlet UIButton *gpsButton;

@property (nonatomic, retain) IBOutlet UILabel *userLabel;
@property (nonatomic, retain) IBOutlet UITextView *inputView;
@property(nonatomic,retain) id<FeedPostDelegate> delegate;
-(IBAction)cancel;

@end
