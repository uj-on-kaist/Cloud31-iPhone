//
//  UserDetailViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "UserDetailViewController.h"

#import "FeedDetailViewController.h"

#import "Cloud31_iPhoneAppDelegate.h"

#import "ASIHTTPRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "UserInfoContainer.h"
#import "TopicDetailViewController.h"


@implementation UserDetailViewController

@synthesize _tabBar,_userID,_userInfoView, userInfo;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUserID:(NSString*)query{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        self._userID=[NSString stringWithString:query];
        
        CGRect frame = CGRectMake(0.0f, 0.0f, 320, 378);
        feedController = [[FeedListViewController alloc] initWithFrame:frame withQueryURL:[NSString stringWithFormat:@"%@%@",USER_FEED_URL,self._userID]];
        atController = [[FeedListViewController alloc] initWithFrame:frame withQueryURL:[NSString stringWithFormat:@"%@%@",USER_AT_URL,self._userID]];
        favoriteController = [[FeedListViewController alloc] initWithFrame:frame withQueryURL:[NSString stringWithFormat:@"%@%@",USER_FAVORITE_URL,self._userID]];
        
    }
    return self;
}

- (void)dealloc
{
    [userInfo release];
    [_tabBar release];
    [_userID release];
    [_userInfoView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=self._userID;
    
    [_tabBar setItems];
    [self.view bringSubviewToFront:_tabBar];
    
    if(userInfo == nil){
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",USER_DETAIL_URL,self._userID]]];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSString *response = [request responseString];
            NSError *theError = NULL;
            NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
            if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                self.userInfo =[NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"user"]];
                profileView = [[UserProfileSmallView alloc] init];
                [profileView.picture setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, [self.userInfo objectForKey:@"picture"]]]];
                profileView.name.text=[self.userInfo objectForKey:@"name"];
                profileView.backgroundColor=[UIColor groupTableViewBackgroundColor];
                profileView.userID.text=[NSString stringWithFormat:@"@%@",[self.userInfo objectForKey:@"userID"]];
                
                profileView.userDept.text=[NSString stringWithFormat:@"최근 로그인 %@",[self.userInfo objectForKey:@"last_login"]];
                [profileView disableLink];
                [self._userInfoView setTableHeaderView:profileView];
                
            }else{
                Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
                [app_delegate.navigationController popViewControllerAnimated:YES];
            }
        }else{
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
    
    [_userInfoView reloadData];
}

-(void)getUserInfo{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }
    
    return [[userInfo objectForKey:@"related_topics"] count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 1){
        return @"Related Topics";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    if(indexPath.section == 0){
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        }
        NSString *title=@"";
        NSString *contents=@"";
        if(userInfo == nil){
            return cell;
        }
        switch (indexPath.row) {
            case 0:
                title=@"이메일";
                contents=[userInfo objectForKey:@"email"];
                break;
            case 1:
                title=@"소속";
                contents=[userInfo objectForKey:@"dept"];
                break;
            case 2:
                title=@"직급";
                contents=[userInfo objectForKey:@"position"];
                break;
            default:
                break;
        }
        cell.textLabel.text=title;
        cell.detailTextLabel.text=contents;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
        }
        NSMutableDictionary *dictionary = [[userInfo objectForKey:@"related_topics"] objectAtIndex:indexPath.row];
        cell.textLabel.text=[NSString stringWithFormat:@"#%@",[dictionary objectForKey:@"topic_name"]];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:13.0f];
        cell.textLabel.textColor=RGB2(50, 90, 180);
        cell.detailTextLabel.text=@"";
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 34.0f;
    }
    return 44.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1){
        int topic_id =[[[[userInfo objectForKey:@"related_topics"] objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        NSString *query = [NSString stringWithFormat:@"%d",topic_id];
        TopicDetailViewController *topicDetailViewController =  [[TopicDetailViewController alloc] initWithTopicID:query];
        Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app_delegate.navigationController pushViewController:topicDetailViewController animated:YES];
    }
}


#define PROFILE_INDEX 0
#define FEED_INDEX 1
#define AT_INDEX 2
#define FAVORITE_INDEX 3

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger selectedIndex = [item tag];
    
    if(currentViewController != nil){
        [currentViewController.view removeFromSuperview];
    }
    
    if(selectedIndex == PROFILE_INDEX){
        currentViewController = nil;
    }else if(selectedIndex == FEED_INDEX){
        currentViewController=feedController;
    }else if(selectedIndex == AT_INDEX){
        currentViewController=atController;
    }else if(selectedIndex == FAVORITE_INDEX){
        currentViewController=favoriteController;
    }else{
        return;
    }
    
    if(currentViewController != nil){
        [self.view addSubview:currentViewController.view];
        [self.view bringSubviewToFront:_tabBar];
        
        [currentViewController viewWillAppear:YES];
    }
    [_tabBar tabbarSelected:selectedIndex];
}



-(void)selectTab:(int)index{
    if(index > [_tabBar.items count] - 1){
        return;
    }
    [_tabBar selectItem:index];
    
    UITabBarItem * item=(UITabBarItem *)[_tabBar.items objectAtIndex:index];
    [self tabBar:_tabBar didSelectItem:item];
}


@end
