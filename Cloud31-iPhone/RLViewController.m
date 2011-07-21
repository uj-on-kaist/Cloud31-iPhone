//
//  RLViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "RLViewController.h"
#import "FeedDetailViewController.h"
#import "Cloud31_iPhoneAppDelegate.h"

@implementation RLViewController

@synthesize _tableView, items;

- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    self.view.frame = frame;
    if (self) {
        items = [[NSMutableArray alloc] init];
        
        loadingView = [[UIView alloc] initWithFrame:self.view.frame];
        UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(140, 165, 100, 20)];
        label.text=@"Loading...";
        label.textColor=[UIColor darkGrayColor];

        label.backgroundColor=[UIColor clearColor];
        UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame=CGRectMake(110, 165, 20, 20);
        [activity startAnimating];
        
        [loadingView addSubview:activity];
        [loadingView addSubview:label];
        //loadingView.backgroundColor=BACKGROUND_COLOR;
        [self.view addSubview:loadingView];
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        //_tableView.backgroundColor=BACKGROUND_COLOR;
        
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self._tableView.bounds.size.height, self.view.frame.size.width, self._tableView.bounds.size.height)];
            view.delegate = self;
            [self._tableView addSubview:view];
            _refreshHeaderView = view;
            [view release];
            
        }
        
        //  update the last update date
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    return self;
}

- (void)dealloc
{
    _refreshHeaderView = nil;
    [loadingView release];
    [_tableView release];
    [items release];
    [super dealloc];
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([items count] == 0){
        if([loadingView superview] == nil)
            [self.view addSubview:loadingView];
        [self performSelector:@selector(loadData)];
    }
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
    
    return cell;
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self._tableView];
	[_tableView reloadData];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	return [NSDate date]; // should return date data source was last changed
}


-(void)loadData{
    if([loadingView superview]){
        [loadingView removeFromSuperview];
    }
    if([_tableView superview] == nil){
        [self.view addSubview:_tableView];
    }
    [_tableView reloadData];
    
}

-(void)loadMoreData:(int)base_id{
    if(_load_more){
        return;
    }else{
        _load_more=YES;
    }    
}
-(void)loadMoreDataFinished:(int)result{
    _load_more=NO;
    [_tableView reloadData];
}

-(void)itemDeleted:(NSMutableDictionary *)item{
    
    int item_id=[[item objectForKey:@"id"] intValue];
    NSMutableDictionary *willDeleted = nil;
    for(NSMutableDictionary *_item in items){
        int _item_id = [[_item objectForKey:@"id"] intValue];
        if(item_id == _item_id){
            willDeleted=_item;
            break;
        }
    }
    
    if(willDeleted !=nil){
        [items removeObject:willDeleted];
    }
    [self._tableView reloadData];
}
@end
