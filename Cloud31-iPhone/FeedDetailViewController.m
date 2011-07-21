//
//  FeedDetailViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "UserProfileSmallView.h"

#import "Cloud31_iPhoneAppDelegate.h"

#import "CommentTableViewCell.h"

#import "CommentPostController.h"

#import "ASIHTTPRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "CommentInfoView.h"
#import "UserInfoContainer.h"

#import "TopicDetailViewController.h"
#import "UserDetailViewController.h"

@implementation FeedDetailViewController

@synthesize item;

-(id)initWithItem:(NSMutableDictionary *)aItem{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 417)];
    if (self) {
        // Custom initialization
        self.item= aItem;
        //self.title=[self.item objectForKey:@"contents_original"];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(more_action)];
        CGRect frame= _tableView.frame;
        frame.size.height-=44;
        _tableView.frame=frame;
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        TTNavigator *navigator = [TTNavigator navigator];
        navigator.persistenceMode = TTNavigatorPersistenceModeNone;
        navigator.delegate = self;
        
        NSString *contents=[[self.item objectForKey:@"contents"] stringByReplacingOccurrencesOfString:@"target=_blank" withString:@""];
        contents_label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(10, 20, 300, 44)];
        TTStyledText* styledText = [TTStyledText textFromXHTML:contents lineBreaks:YES URLs:YES];
        contents_label.text=styledText;
        contents_label.userInteractionEnabled=YES;
        [contents_label sizeToFit];
        
        
        
        
        UserProfileSmallView *profileView = [[UserProfileSmallView alloc] init];
        
        [profileView.picture setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, [self.item objectForKey:@"author_picture"]]]];
        profileView.name.text=[self.item objectForKey:@"author_name"];
        profileView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        profileView.userID.text=[NSString stringWithFormat:@"@%@",[self.item objectForKey:@"author"]];
        
        profileView.userDept.text=[NSString stringWithFormat:@"%@ %@",[self.item objectForKey:@"author_dept"], [self.item objectForKey:@"author_position"]];
        
        TTView *contents_bg = [[TTView alloc] initWithFrame:CGRectMake(0, 69, 320, contents_label.frame.size.height+84)];
        [contents_bg addSubview:contents_label];
        contents_bg.backgroundColor=[UIColor groupTableViewBackgroundColor];
        contents_bg.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:0 pointLocation:55
                                                                                 pointAngle:90
                                                                                  pointSize:CGSizeMake(15,8)] next:
                           [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:nil]];

        UILabel *date_label = [[UILabel alloc] initWithFrame:CGRectMake(10, contents_label.frame.size.height+35, 280, 15)];
        date_label.text=[NSString stringWithFormat:@"%@ | %@",[self.item objectForKey:@"pretty_date"],[self.item objectForKey:@"reg_date"]];
        date_label.textColor=[UIColor grayColor];
        date_label.backgroundColor=[UIColor clearColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];
        [contents_bg addSubview:date_label];
        
        comment_info = [[CommentInfoView alloc] initWithFrame:CGRectMake(8, contents_label.frame.size.height+55, 312, 20)];
        comment_info.backgroundColor=[UIColor clearColor];
        [contents_bg addSubview:comment_info];
        
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, contents_bg.frame.origin.y+contents_bg.frame.size.height)];
        headerView.userInteractionEnabled=YES;
        headerView.backgroundColor=[UIColor groupTableViewBackgroundColor];

        [headerView addSubview:profileView];
        [headerView addSubview:contents_bg];

        [_tableView setTableHeaderView:headerView];
        
        
        NSArray *_comments = [self.item objectForKey:@"comments"];
        comments=[[NSMutableArray alloc] init];
        for(NSDictionary *_item in _comments){
            [comments addObject:[NSMutableDictionary dictionaryWithDictionary:_item]];
        }
        
        
        UIButton *commentPostView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"comment_off.png"] forState:UIControlStateNormal];
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"comment_on.png"] forState:UIControlStateHighlighted];
        [commentPostView addTarget:self action:@selector(comment_post) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:commentPostView];
        
        //[super loadData];
        
        from_comment_update=NO;
    }
    return self;
}

-(void)comment_post{
    CommentPostController *postController=[[CommentPostController alloc] init];
    postController.delegate=self;
    postController.feed_id=[self.item objectForKey:@"id"];
    [postController showInView:self.view animated:YES];
}

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result{
    from_comment_update=YES;
    [self loadData];
}
-(void)postControllerDidCancel:(TTPostController *)postController{
    [self loadData];
}

-(void)reloadData{
    // Custom initialization
    NSLog(@"RELOAD DATA");
    //self.title=[self.item objectForKey:@"contents_original"];

    NSArray *_comments = [self.item objectForKey:@"comments"];
    comments=[[NSMutableArray alloc] init];
    for(NSDictionary *_item in _comments){
        [comments addObject:[NSMutableDictionary dictionaryWithDictionary:_item]];
    }
    [_tableView reloadData];
    
    if(from_comment_update){
        from_comment_update=NO;
        NSIndexPath* ipath = [NSIndexPath indexPathForRow:([_tableView numberOfRowsInSection:0]-1) inSection:0];
        [_tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionTop animated: YES];
    }
    
    if([[self.item objectForKey:@"favorite"] boolValue]){
        [comment_info setStarOn];
    }else{
        [comment_info setStarOff];
    }
    BOOL has_location=NO;
    if([self.item objectForKey:@"lat"] != nil && [self.item objectForKey:@"lng"] != nil){
        has_location=YES;
    }
    [comment_info setAttachInfo:[self.item objectForKey:@"file_list"] withLocation:has_location];
    
    int comment_count = [[self.item objectForKey:@"comments"] count];
    [comment_info setCommentCount:comment_count];
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 417)];
    if (self) {
        // Custom initialization
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)more_action{
    if([[[UserInfoContainer sharedInfo] userID] isEqualToString:[self.item objectForKey:@"author"]]){
        NSString *fav_text=@"";
        if([[self.item objectForKey:@"favorite"] boolValue]){
            fav_text=@"Unfavorite";
        }else{
            fav_text=@"Favorite";
        }
        UIActionSheet *menu = [[UIActionSheet alloc] 
                               initWithTitle: @"" 
                               delegate:self
                               cancelButtonTitle:@"취소"
                               destructiveButtonTitle:nil
                               otherButtonTitles:fav_text,@"Delete",nil];
        menu.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    	[menu showInView:self.view];
        return;
    }else{
        NSString *fav_text=@"";
        if([[self.item objectForKey:@"favorite"] boolValue]){
            fav_text=@"Unfavorite";
        }else{
            fav_text=@"Favorite";
        }
        UIActionSheet *menu = [[UIActionSheet alloc] 
                               initWithTitle: @"" 
                               delegate:self
                               cancelButtonTitle:@"취소"
                               destructiveButtonTitle:nil
                               otherButtonTitles:fav_text,nil];
        menu.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    	[menu showInView:self.view];
        return;
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Favorite"]){
        [self performSelector:@selector(favorite_action)];
    }else if([title isEqualToString:@"Unfavorite"]){
        [self performSelector:@selector(favorite_action)];
    }else if([title isEqualToString:@"Delete"]){
        [self performSelector:@selector(delete_action)];
    }
	[actionSheet release];
}

-(void)favorite_action{
    NSURL *url=nil;
    if([[self.item objectForKey:@"favorite"] boolValue]){
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",UNFAVOR_URL,[self.item objectForKey:@"id"]]];
    }else{
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FAVOR_URL,[self.item objectForKey:@"id"]]];
    }
    if(HUD == nil){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    HUD.labelText = @"Updating...";
    
    [HUD show:YES];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [HUD hide:YES];
            [self loadData];
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
-(void)myTask {
    sleep(1);
}


-(void)delete_action{
    if(HUD == nil){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    HUD.labelText = @"Updating...";
    
    [HUD show:YES];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FEED_DELETE_URL, [self.item objectForKey:@"id"]]]];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Comments";
    
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSMutableDictionary *_comment_item = [comments objectAtIndex:indexPath.row];
    [cell prepareData:_comment_item];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *_comment_item = [comments objectAtIndex:indexPath.row];
    return [CommentTableViewCell calculateHeight:_comment_item];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSURL*)navigator:(TTBaseNavigator*)navigator URLToOpen:(NSURL*)URL{
    NSLog(@"%@",[URL absoluteURL]);
    if([[URL absoluteString] rangeOfString:@"http:///"].location == NSNotFound){
        TTWebController *webController=[[TTWebController alloc]init];
        [webController openURL:URL];
        
        Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app_delegate.navigationController pushViewController:webController animated:YES];
    }else{
        NSString *path = [URL relativePath];
        NSArray *array = [path componentsSeparatedByString:@"/"];
        
        NSString *gate=[array objectAtIndex:1];
        NSString *query=[array objectAtIndex:2];
        
        NSLog(@"%@ : %@",gate, query);
        if([gate isEqualToString:@"topic"]){
            [self showTopicDetailController:query];
        }else if([gate isEqualToString:@"user"]){
            [self showUserDetailController:query];
        }
        
    }
    return NULL;
}
-(void)showUserDetailController:(NSString *)query{
    UserDetailViewController *userDetailViewController =  [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil withUserID:query];
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app_delegate.navigationController pushViewController:userDetailViewController animated:YES];
}
-(void)showTopicDetailController:(NSString *)query{
    
    TopicDetailViewController *topicDetailViewController =  [[TopicDetailViewController alloc] initWithTopicID:query];
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app_delegate.navigationController pushViewController:topicDetailViewController animated:YES];
}

-(void)loadData{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",FEED_DETAIL_URL,[self.item objectForKey:@"id"]]]];
    
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *response = [request responseString];
    NSError *theError = NULL;
    NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
    if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        NSArray *array = [json objectForKey:@"feed"];
        if([array count] == 1){
            item = [[NSMutableDictionary alloc]initWithDictionary:[array objectAtIndex:0]];
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

@end
