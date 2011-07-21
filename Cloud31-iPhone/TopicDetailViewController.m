//
//  TopicDetailViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "FeedDetailViewController.h"
#import "UserProfileSmallView.h"

#import "Cloud31_iPhoneAppDelegate.h"

#import "CommentTableViewCell.h"

#import "CommentPostController.h"

#import "ASIHTTPRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "CommentInfoView.h"
#import "UserInfoContainer.h"

#import "FeedTableViewCell.h"

@implementation TopicDetailViewController

@synthesize topic_id, topic_info;

-(id)initWithTopicID:(NSString *)a_id{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 417)];
    if (self) {
        // Custom initialization
        self.topic_id = a_id;
        
        
        
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



-(void)loadData{
    if(topic_info == nil){
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",TOPIC_DETAIL_URL,topic_id]]];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            NSError *theError = NULL;
            NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
            if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                self.topic_info =[NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"topic"]];
                self.title=[NSString stringWithFormat:@"#%@",[topic_info objectForKey:@"topic_name"]];
            }else{
                Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
                [app_delegate.navigationController popViewControllerAnimated:YES];
            }
        }else{
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController popViewControllerAnimated:YES];
        }
    }
    NSLog(@"Request Start");
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",TOPIC_FEED_URL,topic_id]]];
    _data_loading=YES;
    [request setDelegate:self];
    [request startAsynchronous];
}
-(void)loadMoreData:(int)base_id{
    [super loadMoreData:base_id];
    NSString *url = [NSString stringWithFormat:@"%@%@/?base_id=%d",TOPIC_FEED_URL,topic_id, base_id];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if(_data_loading){
        NSString *response = [request responseString];
        //NSLog(@"%@",response);
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            NSArray *array = [json objectForKey:@"feeds"];
            items = [[NSMutableArray alloc] init];
            for(NSDictionary *item in array){
                NSMutableDictionary *_item = [NSMutableDictionary dictionaryWithDictionary:item];
                [_item setObject:@"false" forKey:@"load_more"];
                [items addObject:_item];
            }
            if([items count] != 0){
                [items addObject:[NSMutableDictionary dictionaryWithObject:@"true" forKey:@"load_more"]];
            }
        }
        _data_loading=NO;
        [super loadData];
    }else{
        NSString *response = [request responseString];
        //NSLog(@"%@",response);
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            NSArray *array = [json objectForKey:@"feeds"];
            [items removeLastObject];
            for(NSDictionary *item in array){
                NSMutableDictionary *_item = [NSMutableDictionary dictionaryWithDictionary:item];
                [_item setObject:@"false" forKey:@"load_more"];
                [items addObject:_item];
            }
            if([array count] != 0){
                [items addObject:[NSMutableDictionary dictionaryWithObject:@"true" forKey:@"load_more"]];
            }
        }
        [super loadMoreDataFinished:0];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",[error localizedDescription]);
    //Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[app_delegate.navigationController popViewControllerAnimated:YES];
}



#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

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


- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	[self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.5];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    FeedTableViewCell *cell = (FeedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[FeedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSMutableDictionary *item = [items objectAtIndex:indexPath.row];
    if([[item objectForKey:@"load_more"] isEqualToString:@"true"]){
        UITableViewCell *load_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"load_more"];
        UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame=CGRectMake(150,12, 20, 20);
        [activity startAnimating];
        [load_cell addSubview:activity];
        
        NSMutableDictionary *last_item = [items objectAtIndex:([items count] - 2)];
        int base_id = [[last_item objectForKey:@"base_id"] intValue];
        [self loadMoreData:base_id];
        return load_cell;
    }
    [cell prepareData:item];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(items == nil){
        return 44.0f;
    }
    if([items count] > 0){
        NSMutableDictionary *item = [items objectAtIndex:indexPath.row];
        if([[item objectForKey:@"load_more"] isEqualToString:@"true"]){
            return 44.0f;
        }
        if([item valueForKey:@"height"]){
            return [[item valueForKey:@"height"] floatValue];
        }else{
            CGFloat height = [FeedTableViewCell calculateHeight:item];
            [item setValue:[NSNumber numberWithFloat:height] forKey:@"height"];
            return height;
        }        
    }
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *item = [items objectAtIndex:indexPath.row];
    FeedDetailViewController *feedDetailViewController = [[FeedDetailViewController alloc] initWithItem:item];
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app_delegate.navigationController pushViewController:feedDetailViewController animated:YES];
}

@end
