//
//  SettingViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfoContainer.h"
#import "EGOImageView.h"

#import <QuartzCore/QuartzCore.h>

#import "UserProfileSmallView.h"
#import "Cloud31_iPhoneAppDelegate.h"
#import "UserDetailViewController.h"

@implementation SettingViewController

@synthesize _tableView;

- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    self.view.frame = frame;
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self.view addSubview:_tableView];
        
        UserProfileSmallView *profileView = [[UserProfileSmallView alloc] init];
        NSDictionary *userInfo = [[UserInfoContainer sharedInfo] userInfo];
        [profileView.picture setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, [userInfo objectForKey:@"picture"]]]];
        

        profileView.name.text=[userInfo objectForKey:@"username"];

        profileView.userID.text=[NSString stringWithFormat:@"@%@",[[UserInfoContainer sharedInfo] userID]];
        
        profileView.userDept.text=[NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"dept"], [userInfo objectForKey:@"position"]];
        
        [_tableView setTableHeaderView:profileView];
        
    }
    return self;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    if(indexPath.section == 0){
        NSString *title=@"";
        switch (indexPath.row) {
            case 0:
                title=@"내 프로필";
                break;
            case 1:
                title=@"관심글";
            default:
                break;
        }
        
        cell.textLabel.text=title;
        cell.textLabel.textAlignment=UITextAlignmentLeft;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }else if(indexPath.section == 1){
        cell.textLabel.text=@"프로필 사진 변경";
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.textLabel.textColor=RGB2(50, 90, 180);
    }else{
        cell.textLabel.text=@"로그아웃";
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.textLabel.textColor=RGB2(50, 90, 180);
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 2){
        [[UserInfoContainer sharedInfo] logout];
    }else if(indexPath.section == 0){
        UserDetailViewController *userDetailViewController =  [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil withUserID:[[UserInfoContainer sharedInfo] userID]];
        Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app_delegate.navigationController pushViewController:userDetailViewController animated:YES];
        
        if(indexPath.row == 1){
            [userDetailViewController selectTab:3];
        }
    }

}

@end
