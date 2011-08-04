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

#import "ASIFormDataRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "NotificationViewController.h"

#import "Three20/Three20.h"
#import "StyleView.h"
@implementation SettingViewController

@synthesize _tableView;
-(void)orientationChanged{
    UIDeviceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight ){
        self.view.frame=CGRectMake(0, 0, 480, 230);
    }else{
        self.view.frame=CGRectMake(0, 0, 320, 378);
    }
    self._tableView.frame=self.view.frame;
    [self._tableView reloadData];
}
- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    self.view.frame = frame;
    if (self) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
        
        profileView = [[UserProfileSmallView alloc] init];
        NSDictionary *userInfo = [[UserInfoContainer sharedInfo] userInfo];
        [profileView.picture setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, [userInfo objectForKey:@"picture"]]]];
        

        profileView.name.text=[userInfo objectForKey:@"username"];

        profileView.userID.text=[NSString stringWithFormat:@"@%@",[[UserInfoContainer sharedInfo] userID]];
        
        profileView.userDept.text=[NSString stringWithFormat:@"%@ %@",[userInfo objectForKey:@"dept"], [userInfo objectForKey:@"position"]];
        
        [_tableView setTableHeaderView:profileView];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setBadgeNumber];
    [_tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 3;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    
    
    if(indexPath.section == 0){
        NSString *title=@"";
        switch (indexPath.row) {
            case 0:
                title=@"내 프로필";
                break;
            case 1:
                title=@"관심글";
                break;
            default:
                title=@"알림";
                break;
        }
        
        cell.textLabel.text=title;
        cell.textLabel.textAlignment=UITextAlignmentLeft;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        if(indexPath.row == 2){
            notiCell=cell;
            [self setBadgeNumber];
        }
        
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
        if(indexPath.row <= 1){
            UserDetailViewController *userDetailViewController =  [[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil withUserID:[[UserInfoContainer sharedInfo] userID]];
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController pushViewController:userDetailViewController animated:YES];
            
            if(indexPath.row == 1){
                [userDetailViewController selectTab:3];
            }
            return;
        }else{
            NotificationViewController *notificationViewController=[[NotificationViewController alloc] init];
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController pushViewController:notificationViewController animated:YES];
        }
    }else if(indexPath.section == 1){
        [self imageUpload];
    }

}

-(void)imageUpload{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing=YES;
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app_delegate.navigationController presentModalViewController:imagePickerController animated:YES];
    /*
    UIActionSheet *menu = [[UIActionSheet alloc] 
                           initWithTitle: @"" 
                           delegate:self
                           cancelButtonTitle:@"취소"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"라이브러리에서 선택", nil];
    [menu showInView:self.view];
    */
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex]){
        [self dismissModalViewControllerAnimated:YES];
    }else if(buttonIndex == 0){
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing=YES;
        Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app_delegate.navigationController presentModalViewController:imagePickerController animated:YES];
    }else if(buttonIndex == 1){
        /*if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing=YES;
            Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
            [app_delegate.navigationController presentModalViewController:imagePickerController animated:YES];
        }*/
    }
    [actionSheet release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
	[app_delegate.navigationController dismissModalViewControllerAnimated:YES];
	UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if(img == nil){
        return;
    }
	UIGraphicsBeginImageContext(CGSizeMake(100.0f, 100.0f));
    [img drawInRect:CGRectMake(0, 0, 100.0f, 100.0f)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    
    if(HUD == nil){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    
    HUD.labelText = @"Uploading...";
    [HUD show:YES];
    [self performSelector:@selector(updateImage:) withObject:newImage afterDelay:0.25f];
    
}
-(void)updateImage:(UIImage *)img{
    if(img != nil){
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:PICTURE_UPLOAD_URL]];
        [request addPostValue:@"png" forKey:@"fileExtension"];
        NSData* imageData=UIImagePNGRepresentation(img);
        
        NSString *fileName=[NSString stringWithFormat:@"%@_%@.png",[[UserInfoContainer sharedInfo] userID],[self stringWithUUID]];
        [request addData:imageData withFileName:fileName andContentType:@"image/png" forKey:@"photo"];
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSError *theError = NULL;
            NSString *response =[request responseString];
            NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
            NSLog(@"%@",json);
            if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                NSString *changed_picture=[json objectForKey:@"changed_picture"];
                [profileView.picture setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, changed_picture]]];
                //self.attach_list=[NSString stringWithFormat:@"%@%@.",self.attach_list,file_id];
            }
        }else{
            NSLog(@"Error : %@", [error localizedDescription]);
        }
    }else{
        NSLog(@"NULL %@", img);
    }
    [HUD hide:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
	[app_delegate.navigationController dismissModalViewControllerAnimated:YES];
    
}
-(NSString*) stringWithUUID{
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}


-(void)badge_changed{
    [_tableView reloadData];
}

-(void)setBadgeNumber{
    NSInteger badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    
    TTStyle *badge_style = [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:TT_ROUNDED] next:
                            [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 1, 1) next:
                             [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.15) blur:3 offset:CGSizeMake(0, 4) next:
                              [TTReflectiveFillStyle styleWithColor:RGBCOLOR(221, 17, 27) next:
                               [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, -1, -1) next:
                                [TTSolidBorderStyle styleWithColor:[UIColor whiteColor] width:2 next:
                                 [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(1, 7, 2, 7) next:
                                  [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:12.0f]
                                                       color:[UIColor whiteColor] next:nil]]]]]]]];
    
    if([badge superview] != nil){
        [badge removeFromSuperview];
    }
    badge = [[StyleView alloc]
             initWithFrame:CGRectMake(50, 2, 20, 20)];
    
    //badge.text=@"123";
    if(badgeNumber == 0){
        badge.text = nil;
        badge.hidden=YES;
    }
    else{
        badge.text = nil;
        badge.text=[NSString stringWithFormat:@"%d",badgeNumber];
    }
    
    TTStyleContext* context = [[TTStyleContext alloc] init];
    context.frame = badge.frame;
    context.delegate = badge;
    context.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [badge_style addToSize:CGSizeZero context:context];
    TT_RELEASE_SAFELY(context);
    
    size.width += 20;
    size.height += 20;
    CGRect textFrame=badge.frame;
    textFrame.size = size;
    badge.frame = textFrame;
    
    badge.style = badge_style;
    badge.backgroundColor=[UIColor clearColor];
    badge.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [notiCell addSubview:badge];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
@end
