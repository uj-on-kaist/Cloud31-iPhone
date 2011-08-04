//
//  MessageDetailViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Cloud31_iPhoneAppDelegate.h"

#import "ASIHTTPRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "MessageDetailTableViewCell.h"

#import "ReplyPostViewController.h"

#import "UserInfoContainer.h"

@implementation MessageDetailViewController

@synthesize item;
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    UIDeviceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight ){
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_long_off.png"] forState:UIControlStateNormal];
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_long_on.png"] forState:UIControlStateHighlighted];
    }else{
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_off.png"] forState:UIControlStateNormal];
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_on.png"] forState:UIControlStateHighlighted];
    }
    
    [self._tableView reloadData];
    commentPostView.frame=CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44);
    [self._tableView reloadData];
}
-(id)initWithItem:(NSMutableDictionary *)aItem{
    CGRect frame;
    UIDeviceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight ){
        frame=CGRectMake(0, 0, 480, 269);
    }else{
        frame=CGRectMake(0, 0, 320, 417);
    }
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        self.item= aItem;
        
        self._tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self._tableView.backgroundColor=RGBA2(69, 110, 160, 1.0);
        
        CGRect frame = self._tableView.frame;
        frame.size.height-=44;
        self._tableView.frame=frame;
        
        commentPostView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width, 44)];
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_off.png"] forState:UIControlStateNormal];
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_on.png"] forState:UIControlStateHighlighted];
        [commentPostView addTarget:self action:@selector(reply_post) forControlEvents:UIControlEventTouchUpInside];
        if(self.view.frame.size.width == 320){
            [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_off.png"] forState:UIControlStateNormal];
            [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_on.png"] forState:UIControlStateHighlighted];
        }else{
            [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_long_off.png"] forState:UIControlStateNormal];
            [commentPostView setBackgroundImage:[UIImage imageNamed:@"reply_long_on.png"] forState:UIControlStateHighlighted];
        }
        
        [self.view addSubview:commentPostView];
        
        if([[[UserInfoContainer sharedInfo] userID] isEqualToString:[self.item objectForKey:@"author"]]){
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(more_action)];
        }
        if([[[UserInfoContainer sharedInfo] userID] isEqualToString:[self.item objectForKey:@"author"]]){
            self.title=[self.item objectForKey:@"receivers_name"];
        }else{
            self.title=[NSString stringWithFormat:@"%@, %@",[self.item objectForKey:@"author_name"], [self.item objectForKey:@"receivers_name"]];
        }
    }
    return self;
}


-(void)more_action{
    if([[[UserInfoContainer sharedInfo] userID] isEqualToString:[self.item objectForKey:@"author"]]){
        UIActionSheet *menu = [[UIActionSheet alloc] 
                               initWithTitle: @"" 
                               delegate:self
                               cancelButtonTitle:@"취소"
                               destructiveButtonTitle:nil
                               otherButtonTitles:@"Delete",nil];
        menu.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    	[menu showInView:self.view];
        return;
    }else{
        return;
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Delete"]){
        [self performSelector:@selector(delete_action)];
    }
	[actionSheet release];
}

-(void)delete_action{
    if(HUD == nil){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    HUD.labelText = @"Updating...";
    
    [HUD show:YES];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MESSAGE_DELETE_URL, [self.item objectForKey:@"id"]]]];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [HUD hide:NO];
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController popViewControllerAnimated:YES];
            UIViewController *nextView = [app_delegate.navigationController visibleViewController];
            if([nextView respondsToSelector:@selector(itemDeleted:)]){
                [nextView performSelector:@selector(itemDeleted:) withObject:self.item];
            }
        }else{
            [HUD hide:NO];
            HUD.labelText = @"Error Occured";
            [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        
    }else{
        HUD.labelText = @"Error Occured";
        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        NSLog(@"%@",[error localizedDescription]);
    }
}

-(void)reply_post{
    ReplyPostViewController *postController=[[ReplyPostViewController alloc] init];
    postController.delegate=self;
    postController.message_id=[self.item objectForKey:@"id"];
    [postController showInView:self.view animated:YES];
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
    return YES;
}

-(void)reloadData{
    // Custom initialization
    //self.title=[self.item objectForKey:@"contents_original"];
    
    [_tableView reloadData];
    NSIndexPath* ipath = [NSIndexPath indexPathForRow:([_tableView numberOfRowsInSection:0]-1) inSection:0];
    [_tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    
}

-(void)loadData{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",MESSAGE_DETAIL_URL,[self.item objectForKey:@"id"]]]];
    
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSError *theError = NULL;
    NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
    if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        if([json objectForKey:@"message"]){
            item = [[NSMutableDictionary alloc]initWithDictionary:[json objectForKey:@"message"]];
            //NSLog(@"item %@",item);
            [self reloadData];
        }else{
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController popViewControllerAnimated:YES];
        }
        
    }
    [super loadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app_delegate.navigationController popViewControllerAnimated:YES];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.item){
        NSArray *replies = [self.item objectForKey:@"replies"];
        return 1+[replies count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"replies";
    
    MessageDetailTableViewCell *cell = (MessageDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MessageDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if(indexPath.row == 0){
        [cell prepareData:self.item];
    }else{
        NSArray *replies = [self.item objectForKey:@"replies"];
        NSMutableDictionary *reply = [replies objectAtIndex:indexPath.row-1];
        [cell prepareData:reply];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.item){
        if(indexPath.row == 0){
            return [MessageDetailTableViewCell calculateHeight:self.item];
        }else{
            NSArray *replies = [self.item objectForKey:@"replies"];
            NSMutableDictionary *reply = [replies objectAtIndex:indexPath.row-1];
            return [MessageDetailTableViewCell calculateHeight:reply];
        }
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result{
    NSLog(@"123123");
    from_comment_update=YES;
    [self loadData];
}
-(void)postControllerDidCancel:(TTPostController *)postController{
    [self loadData];
}

@end
