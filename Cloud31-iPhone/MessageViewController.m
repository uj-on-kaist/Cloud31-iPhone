//
//  HomeViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 19..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageViewController.h"

#import "ASIHTTPRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "MessageTableViewCell.h"
#import "MessageDetailViewController.h"

#import "Cloud31_iPhoneAppDelegate.h"

@implementation MessageViewController

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
    return YES;
}
- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
	_reloading = YES;
	[self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
}

-(void)loadData{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:MESSAGE_ALL_URL]];
    [request setDelegate:self];
    [request startAsynchronous];
    _data_loading=YES;
}

-(void)loadMoreData:(int)base_id{
    [super loadMoreData:base_id];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?base_id=%d",MESSAGE_ALL_URL, base_id]]];
    [request setDelegate:self];
    _data_loading=NO;
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
            NSArray *array = [json objectForKey:@"messages"];
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
        // Use when fetching text data
        NSString *response = [request responseString];
        //NSLog(@"%@",response);
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            NSArray *array = [json objectForKey:@"feeds"];
            NSMutableDictionary *last = [items lastObject];
            if([[last objectForKey:@"load_more"] isEqualToString:@"true"]){
                [items removeLastObject];
            }
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
    if(_data_loading){
        _data_loading=NO;
        [super loadData];
    }else{
        NSError *error = [request error];
        NSLog(@"%@",[error localizedDescription]);
        [items removeLastObject];
        [super loadMoreDataFinished:0];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    MessageTableViewCell *cell = (MessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSMutableDictionary *item = [items objectAtIndex:indexPath.row];
    if([[item objectForKey:@"load_more"] isEqualToString:@"true"]){
        UITableViewCell *load_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"load_more"];
        UIActivityIndicatorView *activity=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.frame=CGRectMake(150,12, 20, 20);
        [activity startAnimating];
        [load_cell addSubview:activity];
        
        NSMutableDictionary *last_item = [items objectAtIndex:([items count] - 2)];
        [self loadMoreData:[[last_item objectForKey:@"base_id"] intValue]];
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
        if([item valueForKey:@"height"]){
            return [[item valueForKey:@"height"] floatValue];
        }else{
            CGFloat height = [MessageTableViewCell calculateHeight:item];
            [item setValue:[NSNumber numberWithFloat:height] forKey:@"height"];
            return height;
        }        
    }
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *item = [items objectAtIndex:indexPath.row];
    MessageDetailViewController *messageDetailViewController = [[[MessageDetailViewController alloc] initWithItem:item] autorelease];
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app_delegate.navigationController pushViewController:messageDetailViewController animated:YES];
    
    
}



@end