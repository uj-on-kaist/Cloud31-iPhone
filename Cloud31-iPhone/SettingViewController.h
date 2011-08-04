//
//  SettingViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class UserProfileSmallView;
@class StyleView;
@interface SettingViewController : UIViewController  <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UITableView *_tableView;
    
    MBProgressHUD *HUD;
    UIImagePickerController *imagePickerController;
    
    UserProfileSmallView *profileView;
    StyleView* badge;
    
    
    UITableViewCell *notiCell;
}

@property (nonatomic, retain) UITableView *_tableView;

- (id)initWithFrame:(CGRect)frame;

-(void)imageUpload;
-(NSString*) stringWithUUID;

-(void)setBadgeNumber;
@end
