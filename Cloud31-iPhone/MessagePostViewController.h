//
//  MessagePostViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Three20/Three20.h"
#import "MBProgressHUD.h"

@protocol MessagePostDelegate <NSObject>

@required
-(void)messageUploaded:(NSMutableDictionary *)item;
@end

@interface MessagePostViewController : UIViewController <UITextViewDelegate,UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UILabel *userLabel;
    IBOutlet UITextView *toTextView;
    IBOutlet UITextView *contentsTextView;
    
    UITableView *autoTableView;
    NSMutableArray *autoArray;
    
    BOOL search_user;
    
    
    UIControl *toControl;
    
    MBProgressHUD *HUD;
    MBProgressHUD *errorHUD;
    
    id<MessagePostDelegate> delegate;
}
@property (nonatomic, retain) IBOutlet UILabel *userLabel;
@property (nonatomic, retain) IBOutlet UITextView *toTextView;
@property (nonatomic, retain) IBOutlet UITextView *contentsTextView;

@property(nonatomic,retain) id<MessagePostDelegate> delegate;

-(IBAction)close;


-(IBAction)write;

-(void)detectUser:(NSString *)query;

-(void)showErrorHUD:(NSError *)error;
-(void)showErrorHUDWithString:(NSString *)error;
@end
