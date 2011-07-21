//
//  RLViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface RLViewController : UIViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
    EGORefreshTableHeaderView *_refreshHeaderView;
	
	//  Reloading var should really be your tableviews datasource
	//  Putting it here for demo purposes 
	BOOL _reloading;
    
    NSMutableArray *items;
    UITableView *_tableView;
    UIView *loadingView;
    
    BOOL _load_more;
    
    BOOL _data_loading;
}

@property (nonatomic, retain) UITableView *_tableView;
@property (nonatomic, retain) NSMutableArray *items;

-(id)initWithFrame:(CGRect)frame;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

-(void)loadData;
-(void)loadMoreData:(int)base_id;
-(void)loadMoreDataFinished:(int)result;


-(void)itemDeleted:(NSMutableDictionary *)item;
@end
