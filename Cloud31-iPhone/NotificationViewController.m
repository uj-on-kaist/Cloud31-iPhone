//
//  NotificationViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 29..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "NotificationViewController.h"

#import "ASIHTTPRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "NotificationTableViewCell.h"


#import "Cloud31_iPhoneAppDelegate.h"
#import "FeedDetailViewController.h"
#import "MessageDetailViewController.h"

@implementation NotificationViewController

@synthesize _tableView, items, unreadItems, readItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=@"알림";
        
        // Do any additional setup after loading the view from its nib.
        items = [[NSMutableArray alloc] init];
        unreadItems = [[NSMutableArray alloc] init];
        readItems = [[NSMutableArray alloc] init];
        
        loadingView = [[UIView alloc] initWithFrame:self.view.frame];
        loadingView.backgroundColor=[UIColor whiteColor];
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
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([loadingView superview] == nil)
        [self.view addSubview:loadingView];
    [self performSelector:@selector(loadData)];
}

#pragma mark -
#pragma mark UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *item;
    if(indexPath.row < [unreadItems count]){
        item=[unreadItems objectAtIndex:indexPath.row];
    }else{
        item=[readItems objectAtIndex:(indexPath.row - [unreadItems count])];
    }
    
    if(item == nil){
        return 44.0f;
    }
    
    if([item valueForKey:@"height"]){
        return [[item valueForKey:@"height"] floatValue];
    }else{
        CGFloat height = [NotificationTableViewCell calculateHeight:item];
        [item setValue:[NSNumber numberWithFloat:height] forKey:@"height"];
        return height;
    }
    
    return 44.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [unreadItems count]+[readItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
	// Configure the cell.
    if(indexPath.row < [unreadItems count]){
        [cell prepareData:[unreadItems objectAtIndex:indexPath.row]];
        
        cell.backgroundColor = [UIColor redColor];
    }else{
        [cell prepareData:[readItems objectAtIndex:(indexPath.row - [unreadItems count])]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *item;
    if(indexPath.row < [unreadItems count]){
        item=[unreadItems objectAtIndex:indexPath.row];
    }else{
        item=[readItems objectAtIndex:(indexPath.row - [unreadItems count])];
    }
    
    if(item == nil){
        return;
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d",NOTIFICATION_READ_URL,[[item objectForKey:@"id"] intValue]]]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [self decreaseApplicationBadge];
            
            NSMutableDictionary *feed_item=[NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"feed"]];
            if([feed_item objectForKey:@"id"] != nil){
                FeedDetailViewController *feedDetailViewController = [[[FeedDetailViewController alloc] initWithItem:feed_item] autorelease];
                Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
                [app_delegate.navigationController pushViewController:feedDetailViewController animated:YES];
            }else{
                NSMutableDictionary *dm_item=[NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"dm"]];
                if([dm_item objectForKey:@"id"] != nil){
                    MessageDetailViewController *feedDetailViewController = [[[MessageDetailViewController alloc] initWithItem:dm_item] autorelease];
                    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [app_delegate.navigationController pushViewController:feedDetailViewController animated:YES];
                }
                return;
            }
        }else{

        }
    }else{
        return;
    }
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	[self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
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
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:NOTIFICATION_GET_URL]];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void)loadDataFinished{
    if([loadingView superview]){
        [loadingView removeFromSuperview];
    }
    if([_tableView superview] == nil){
        [self.view addSubview:_tableView];
    }
    [_tableView reloadData];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    //NSLog(@"%@",response);
    NSError *theError = NULL;
    NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
    //NSLog(@"%@",json);
    if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        [self updateApplicationBadge:[[json objectForKey:@"unread_notis_count"] intValue]];
        
        NSArray *array = [json objectForKey:@"read_notis"];
        readItems = [[NSMutableArray alloc] init];
        for(NSDictionary *item in array){
            NSMutableDictionary *_item = [NSMutableDictionary dictionaryWithDictionary:item];
            [readItems addObject:_item];
        }
        
        NSArray *array2 = [json objectForKey:@"unread_notis"];
        unreadItems = [[NSMutableArray alloc] init];
        for(NSDictionary *item in array2){
            NSMutableDictionary *_item = [NSMutableDictionary dictionaryWithDictionary:item];
            [unreadItems addObject:_item];
        }
    }
    [self loadDataFinished];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self loadDataFinished];
}




-(IBAction)close{
    [self dismissModalViewControllerAnimated:YES];
}


-(void)decreaseApplicationBadge{
    NSInteger count=[[UIApplication sharedApplication] applicationIconBadgeNumber];
    count--;
    if(count <=0){
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        return;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

-(void)updateApplicationBadge:(NSInteger)count{
    if(count <=0){
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        return;
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:count];
}

@end
