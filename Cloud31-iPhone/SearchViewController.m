//
//  SearchViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 22..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SearchViewController.h"
#import "Cloud31_iPhoneAppDelegate.h"

#import "ASIHTTPRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "FeedTableViewCell.h"
#import "SearchUserTableViewCell.h"
#import "SearchFileTableViewCell.h"

#import "TopicDetailViewController.h"

#import "FeedDetailViewController.h"
#import "UserDetailViewController.h"


@implementation SearchViewController
-(void)orientationChanged{
    UIDeviceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight ){
        self.view.frame=CGRectMake(0, 0, 480, 230);
    }else{
        self.view.frame=CGRectMake(0, 0, 320, 378);
    }
    self.tableView.frame=self.view.frame;
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.view.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    searchItems=[[NSMutableArray alloc] init];
    items=[[NSMutableArray alloc] init];
    
    CGRect frame = CGRectMake(0.0f, 0.0f, 320, 378);
    self.view.frame=frame;
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:TOPIC_POPULAR_URL]];
    _loading_popular_topic=YES;
    [request setDelegate:self];
    [request startAsynchronous];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tableView){
        return 40.0f;
    }
    
    NSMutableDictionary *item = [searchItems objectAtIndex:indexPath.row];
    
    int index=[self.searchDisplayController.searchBar selectedScopeButtonIndex];
    if(index == 0){
        if([searchItems count] > 0){
            if([item valueForKey:@"height"]){
                return [[item valueForKey:@"height"] floatValue];
            }else{
                CGFloat height = [FeedTableViewCell calculateHeight:item];
                [item setValue:[NSNumber numberWithFloat:height] forKey:@"height"];
                return height;
            }        
        }
    }else if(index == 1){
        return 40.0f;
    }else if(index == 2){
        return 55.0f;
    }else if(index == 3){
        return 55.0f;
    }
    return 44.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(tableView == self.searchDisplayController.searchResultsTableView){
        return @"";
    }
    return @"Popular Topics";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return [searchItems count];
    
    if(items != nil){
        return [items count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FeedSearchCell = @"FeedSearchCell";
    static NSString *TopicSearchCell = @"TopicSearchCell";
    static NSString *FileSearchCell = @"FileSearchCell";
    static NSString *MemberSearchCell = @"MemberSearchCell";

    if(tableView == self.searchDisplayController.searchResultsTableView){
        NSMutableDictionary *item = [searchItems objectAtIndex:indexPath.row];
        if([[item objectForKey:@"result_type"] isEqualToString:@"feed"]){
            FeedTableViewCell *cell = (FeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FeedSearchCell];
            if (cell == nil) {
                cell = [[[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeedSearchCell] autorelease];
            }
            [cell prepareData:item];
            return cell;
        }else if([[item objectForKey:@"result_type"] isEqualToString:@"topic"]){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TopicSearchCell];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TopicSearchCell] autorelease];
            }
            cell.textLabel.text=[NSString stringWithFormat:@"#%@",[item objectForKey:@"topic_name"]];
            cell.textLabel.font=[UIFont boldSystemFontOfSize:13.0f];
            cell.textLabel.textColor=RGB2(50, 90, 180);
            cell.detailTextLabel.text=@"";
            return cell;
        }else if([[item objectForKey:@"result_type"] isEqualToString:@"member"]){
            SearchUserTableViewCell *cell = (SearchUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MemberSearchCell];
            if (cell == nil) {
                cell = [[[SearchUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MemberSearchCell] autorelease];
            }
            [cell prepareData:item];
            return cell;
        }else{
            SearchFileTableViewCell *cell = (SearchFileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FileSearchCell];
            if (cell == nil) {
                cell = [[[SearchFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FileSearchCell] autorelease];
            }
            [cell prepareData:item];
            return cell;
        }
    }else{
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        NSMutableDictionary *item = [items objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"#%@",[item objectForKey:@"topic_name"]];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:13.0f];
        cell.textLabel.textColor=RGB2(50, 90, 180);
        cell.detailTextLabel.text=@"";
        return cell;
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == self.searchDisplayController.searchResultsTableView){
        NSMutableDictionary *item = [searchItems objectAtIndex:indexPath.row];
        if([[item objectForKey:@"result_type"] isEqualToString:@"feed"]){
            FeedDetailViewController *feedDetailViewController = [[[FeedDetailViewController alloc] initWithItem:item] autorelease];
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController pushViewController:feedDetailViewController animated:YES];
        }else if([[item objectForKey:@"result_type"] isEqualToString:@"topic"]){
            TopicDetailViewController *topicDetailViewController =  [[TopicDetailViewController alloc] initWithTopicID:[item objectForKey:@"id"]];
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController pushViewController:topicDetailViewController animated:YES];
        }else if([[item objectForKey:@"result_type"] isEqualToString:@"member"]){
            UserDetailViewController *userDetailViewController =  [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil withUserID:[item objectForKey:@"userID"]];
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController pushViewController:userDetailViewController animated:YES];
        }else{
            TTWebController *webController=[[TTWebController alloc]init];
            [webController openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"url"]]]];
            
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController pushViewController:webController animated:YES];
        }
    }
    else{
        NSMutableDictionary *item = [items objectAtIndex:indexPath.row];
        NSString *query =[item objectForKey:@"id"];
        TopicDetailViewController *topicDetailViewController =  [[TopicDetailViewController alloc] initWithTopicID:query];
        Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app_delegate.navigationController pushViewController:topicDetailViewController animated:YES];
    }
}


#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	if(searchItems == nil){
        searchItems=[[NSMutableArray alloc] init];
    }
    [searchItems removeAllObjects]; // First clear the filtered array.
    
    int index=[self.searchDisplayController.searchBar selectedScopeButtonIndex];
    NSString *urlStr=@"";
    if(index == 0){
        urlStr = TOTAL_SEARCH_FEED_URL;
    }else if(index == 1){
        urlStr = TOTAL_SEARCH_TOPIC_URL;
    }else if(index == 2){
        urlStr = TOTAL_SEARCH_MEMBER_URL;
    }else if(index == 3){
        urlStr = TOTAL_SEARCH_FILE_URL;
    }
    
    NSString *query = [NSString stringWithFormat:@"%@?q=%@",urlStr,searchText];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:query]];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(_loading_popular_topic){
        NSString *response = [request responseString];
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            NSArray *array = [json objectForKey:@"topics"];
            items=[[NSMutableArray alloc] init];
            for(NSDictionary *item in array){
                NSMutableDictionary *_item = [NSMutableDictionary dictionaryWithDictionary:item];
                [items addObject:_item];
            }
            [self.tableView reloadData];
        }
        _loading_popular_topic=NO;
        return;
    }
    NSString *response = [request responseString];
    //NSLog(@"%@",response);
    NSError *theError = NULL;
    NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
    if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        NSArray *array = [json objectForKey:@"items"];
        [searchItems removeAllObjects];
        for(NSDictionary *item in array){
            NSMutableDictionary *_item = [NSMutableDictionary dictionaryWithDictionary:item];
            [_item setObject:@"false" forKey:@"load_more"];
            [searchItems addObject:_item];
        }
        if([searchItems count] != 0){
            //[searchItems addObject:[NSMutableDictionary dictionaryWithObject:@"true" forKey:@"load_more"]];
        }
        
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    _loading_popular_topic=NO;
    NSError *error = [request error];
    NSLog(@"%@",[error localizedDescription]);
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(void)itemDeleted:(NSMutableDictionary *)item{
    NSLog(@"ENTERED %@",item);
    int item_id=[[item objectForKey:@"id"] intValue];
    NSMutableDictionary *willDeleted = nil;
    for(NSMutableDictionary *_item in searchItems){
        if(![[_item objectForKey:@"result_type"] isEqualToString:@"feed"]){
            return;
        }
        int _item_id = [[_item objectForKey:@"id"] intValue];
        if(item_id == _item_id){
            willDeleted=_item;
            break;
        }
    }
    if(willDeleted !=nil){
        [searchItems removeObject:willDeleted];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}


@end
