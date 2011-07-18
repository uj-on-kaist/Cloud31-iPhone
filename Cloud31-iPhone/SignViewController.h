//
//  SignViewController.h
//  Cloud31-iphone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginTableViewCell : UITableViewCell{
    IBOutlet UITextField *textField;
}

@property (nonatomic, retain) UITextField *textField;

-(void)cellClicked;

@end


@interface SignViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    IBOutlet UITableView *_tableView;
    
    NSString *userID;
    NSString *userPW;
}

@property (nonatomic, retain) IBOutlet UITableView *_tableView;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *userPW;


-(IBAction)start_login;
@end
