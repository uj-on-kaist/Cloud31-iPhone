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
        
        UIView *profileView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
        EGOImageView *picture = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"empty.png"]];
        picture.frame= CGRectMake(10, 10, 50, 50);
        picture.layer.cornerRadius=5;
        picture.clipsToBounds=YES;
        
        
        picture.contentMode=UIViewContentModeScaleToFill;
        NSDictionary *userInfo = [[UserInfoContainer sharedInfo] userInfo];
        [picture setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, [userInfo objectForKey:@"picture"]]]];
        [profileView addSubview:picture];
        
        
        UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(70, 10, 200, 16)];
        name.backgroundColor=[UIColor clearColor];
        name.font=[UIFont boldSystemFontOfSize:16.0f];
        name.textColor = [UIColor darkTextColor];
        name.shadowColor = RGBA(255, 255, 255, 0.75);
        name.shadowOffset = CGSizeMake(0.0, 1.0);
        name.text=[userInfo objectForKey:@"username"];
        [profileView addSubview:name];
        
        UILabel *userID=[[UILabel alloc] initWithFrame:CGRectMake(70, 30, 200, 14)];
        userID.backgroundColor=[UIColor clearColor];
        userID.font=[UIFont systemFontOfSize:13.0f];
        userID.textColor = [UIColor darkTextColor];
        userID.shadowColor = RGBA(255, 255, 255, 0.5);
        userID.shadowOffset = CGSizeMake(0.0, 1.0);
        userID.shadowOffset = CGSizeMake(1.0, 1.0);
        userID.text=[NSString stringWithFormat:@"@%@",[[UserInfoContainer sharedInfo] userID]];
        [profileView addSubview:userID];
        
        UILabel *userDept=[[UILabel alloc] initWithFrame:CGRectMake(70, 45, 200, 14)];
        userDept.backgroundColor=[UIColor clearColor];
        userDept.font=[UIFont systemFontOfSize:13.0f];
        userDept.textColor = [UIColor darkTextColor];
        userDept.shadowColor = RGBA(255, 255, 255, 0.5);
        userDept.shadowOffset = CGSizeMake(0.0, 1.0);
        userDept.shadowOffset = CGSizeMake(1.0, 1.0);
        userDept.text=[NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"dept"], [userInfo objectForKey:@"position"]];
        [profileView addSubview:userDept];
        
        
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
        cell.textLabel.textColor=RGB(50, 90, 180);
    }else{
        cell.textLabel.text=@"로그아웃";
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.textLabel.textColor=RGB(50, 90, 180);
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == 2){
        [[UserInfoContainer sharedInfo] logout];
    }
    
    [cell setSelected:NO animated:YES];

}

@end
