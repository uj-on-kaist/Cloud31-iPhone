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

#import "RootTabBar.h"



@implementation RootViewController

@synthesize _tabBar;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_logo.png"]];
    

    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"My Feed" style:UIBarButtonItemStyleDone target:self action:@selector(changeFeedType)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeFeed)];
    [_tabBar setItems];
    
    CGRect frame = CGRectMake(0.0f, 0.0f, 320, 378);
    
    settingViewController=[[SettingViewController alloc] initWithFrame:frame];
    searchViewController=[[SearchViewController alloc] init];
    messageViewController =[[MessageViewController alloc] initWithFrame:frame];
    companyViewController = [[CompanyViewController alloc] initWithFrame:frame];
    
    homeViewController = [[HomeViewController alloc] initWithFrame:frame];
    
    
    currentViewController = messageViewController;
    
    
    [self.view addSubview:currentViewController.view];
    [currentViewController viewWillAppear:YES];
    
    [self.view bringSubviewToFront:_tabBar];
}

-(void)changeFeedType{

}

-(void)composeFeed{
    FeedPostViewController *postController = [[FeedPostViewController alloc] init];
    postController.delegate=self;
    [self.navigationController presentModalViewController:postController animated:YES];
}

-(void)feedUploaded:(int)result{
    if([currentViewController respondsToSelector:@selector(loadData)]){
        [currentViewController performSelector:@selector(loadData)];
    }
    NSLog(@"result %d",result);
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
    if(currentViewController != nil)
        [currentViewController.view removeFromSuperview];
    
    if(selectedIndex == HOME_INDEX){
        currentViewController=homeViewController;
    }else if(selectedIndex == COMPANY_INDEX){
        currentViewController=companyViewController;
    }else if(selectedIndex == MESSAGE_INDEX){
        currentViewController=messageViewController;
    }else if(selectedIndex == SEARCH_INDEX){
        currentViewController=searchViewController;
    }else if(selectedIndex == SETTING_INDEX){
        currentViewController=settingViewController;
    }
    
    [self.view addSubview:currentViewController.view];
    
    [self.view bringSubviewToFront:_tabBar];
    [_tabBar tabbarSelected:selectedIndex];
    
    [currentViewController viewWillAppear:YES];
}

@end
