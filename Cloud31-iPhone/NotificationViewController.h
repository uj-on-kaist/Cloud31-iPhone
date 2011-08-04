//
//  NotificationViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"


@interface NotificationViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    
    NSMutableArray *items;
    NSMutableArray *unreadItems;
    NSMutableArray *readItems;
    UITableView *_tableView;
    UIView *loadingView;
    
    BOOL _load_more;
    
    BOOL _data_loading;
}

@property (nonatomic, retain) UITableView *_tableView;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *unreadItems;
@property (nonatomic, retain) NSMutableArray *readItems;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

-(void)loadData;
-(void)loadDataFinished;



-(IBAction)close;

-(void)decreaseApplicationBadge;
-(void)updateApplicationBadge:(NSInteger)count;
@end
