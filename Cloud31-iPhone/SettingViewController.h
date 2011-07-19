//
//  SettingViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
}

@property (nonatomic, retain) UITableView *_tableView;

- (id)initWithFrame:(CGRect)frame;
@end
