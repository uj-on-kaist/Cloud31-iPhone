//
//  RootViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "RootViewController.h"

#import "UserInfoContainer.h"
#import "SignViewController.h"




@implementation RootViewController

@synthesize _tabBar;


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self updateSubviewsOrientation];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSString *sort_type =[[UserInfoContainer sharedInfo] getSortType];
    NSString *sort_title=@"";
    if([sort_type isEqualToString:@"update_date"]){
        sort_title=@"업데이트 순";
    }else{
        sort_title=@"작성일 순";
    }
    
    leftBtn = [[UIBarButtonItem alloc] initWithTitle:sort_title style:UIBarButtonItemStylePlain target:self action:@selector(changeSortMethod)];
    
    self.navigationItem.titleView=nil;
    self.title=@"My Feed";
    //self.navigationController.navigationBar.tintColor=RGB2(50, 90, 180);

    self.navigationItem.leftBarButtonItem =leftBtn;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeFeed)];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= 82;
    
    settingViewController=[[SettingViewController alloc] initWithFrame:frame];
    searchViewController=[[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    messageViewController =[[MessageViewController alloc] initWithFrame:frame];
    companyViewController = [[CompanyViewController alloc] initWithFrame:frame];
    
    homeViewController = [[HomeViewController alloc] initWithFrame:frame];
    
    
    currentViewController = homeViewController;
    
    
    [self.view addSubview:currentViewController.view];
    
    [currentViewController viewWillAppear:YES];
    
    [_tabBar setItems];
    [self.view bringSubviewToFront:_tabBar];
    
    [self updateSubviewsOrientation];
}


-(void)changeSortMethod{
    UIActionSheet *menu = [[UIActionSheet alloc] 
                           initWithTitle: @"" 
                           delegate:self
                           cancelButtonTitle:@"닫기"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"작성일 순",@"업데이트 순", nil];
    menu.actionSheetStyle=UIActionSheetStyleBlackOpaque;
	[menu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
	if(buttonIndex == 0){
        [[UserInfoContainer sharedInfo] setSortType:@"reg_date"];
        [currentViewController viewWillAppear:NO];
        leftBtn.title=@"작성일 순";
    }else if(buttonIndex == 1){
        [[UserInfoContainer sharedInfo] setSortType:@"update_date"];
        [currentViewController viewWillAppear:NO];
        leftBtn.title=@"업데이트 순";
    }
	[actionSheet release];
}

-(NSString*)getSortType{
    return @"reg_date";
}

-(void)composeFeed{
    if(currentViewController == messageViewController){
        MessagePostViewController *postController = [[MessagePostViewController alloc] init];
        postController.delegate=self;
        [self presentModalViewController:postController animated:YES];
        return;
    }
    FeedPostViewController *postController = [[FeedPostViewController alloc] init];
    postController.delegate=self;
    [self presentModalViewController:postController animated:YES];
}

-(void)feedUploaded:(NSMutableDictionary *)item{
    if([currentViewController respondsToSelector:@selector(loadData)]){
        [currentViewController performSelector:@selector(loadData)];
    }
    NSLog(@"%@",item);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

#define HOME_INDEX 0
#define COMPANY_INDEX 1
#define MESSAGE_INDEX 2
#define SEARCH_INDEX 3
#define SETTING_INDEX 4

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSInteger selectedIndex = [item tag];
    if(currentViewController != nil){
        [currentViewController viewWillDisappear:YES];
        [currentViewController.view removeFromSuperview];
    }
    if(selectedIndex == HOME_INDEX){
        self.navigationItem.titleView=nil;
        self.title=@"My Feed";
        self.navigationItem.leftBarButtonItem=leftBtn;
        currentViewController=homeViewController;
    }else if(selectedIndex == COMPANY_INDEX){
        self.navigationItem.titleView=nil;
        self.title=@"Company Feed";
        self.navigationItem.leftBarButtonItem=leftBtn;
        currentViewController=companyViewController;
    }else if(selectedIndex == MESSAGE_INDEX){
        self.navigationItem.titleView=nil;
        self.title=@"Message";
        self.navigationItem.leftBarButtonItem=nil;
        currentViewController=messageViewController;
    }else if(selectedIndex == SEARCH_INDEX){
        self.title=@"Search";
        self.navigationItem.leftBarButtonItem=nil;
        currentViewController=searchViewController;
    }else if(selectedIndex == SETTING_INDEX){
        self.title=@"Setting";
        self.navigationItem.leftBarButtonItem=nil;
        currentViewController=settingViewController;
    }
    
    [self.view addSubview:currentViewController.view];
    
    [self.view bringSubviewToFront:_tabBar];
    [_tabBar tabbarSelected:selectedIndex];
    
    [currentViewController viewWillAppear:YES];
}


-(void)itemDeleted:(NSMutableDictionary *)item{
    if([currentViewController respondsToSelector:@selector(itemDeleted:)]){
        [currentViewController performSelector:@selector(itemDeleted:) withObject:item];
    }
}

-(void)itemFavoriteChanged:(NSMutableDictionary *)item{
    NSLog(@"favorite changed");
    if([currentViewController respondsToSelector:@selector(itemFavoriteChanged:)]){
        [currentViewController performSelector:@selector(itemFavoriteChanged:) withObject:item];
    }
}

-(void)got_notification{
    [settingViewController setBadgeNumber];
    [_tabBar updateCount];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //[settingViewController setBadgeNumber];
    
    [settingViewController._tableView reloadData];
    
    [_tabBar updateCount];
    
    [self updateSubviewsOrientation];
}

-(void)updateSubviewsOrientation{
    [_tabBar updateTrianglePosition];
    NSArray *viewControllers = [NSArray arrayWithObjects:settingViewController,messageViewController,searchViewController,companyViewController,homeViewController, nil];
    for(UIViewController *viewController in viewControllers){
        if([viewController respondsToSelector:@selector(orientationChanged)]){
            [viewController performSelector:@selector(orientationChanged)];
        }
    }
}
-(void)messageUploaded:(NSMutableDictionary *)item{
    [messageViewController loadData];
}

@end
