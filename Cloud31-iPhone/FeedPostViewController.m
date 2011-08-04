//
//  FeedPostViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "FeedPostViewController.h"
#import "UserInfoContainer.h"
#import <QuartzCore/QuartzCore.h>
#import "AutoTableViewCell.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

#import "CustomMapView.h"
#import "CustomUIControl.h"

@implementation FeedPostViewController

@synthesize userLabel, inputView;
@synthesize delegate;
@synthesize atButton, topicButton, attachButton, gpsButton;
@synthesize attachView,gpsView, attach_list, location_info;
@synthesize imageScrollView, gpsMapView, locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [atButton release];
    [topicButton release];
    [attachButton release];
    [gpsButton release];
    
    [userLabel release];
    [inputView release];
    [delegate release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageScrollView.layer.cornerRadius=10.0f;

    [self.view addSubview:attachView];
    [self.view addSubview:gpsView];
    
    attach_list=@"";
    
    attachView.frame=CGRectMake(0, self.view.frame.size.height-214, 320, 214);
    gpsView.frame=CGRectMake(0, self.view.frame.size.height-214, 320, 214);
    
    attachView.hidden=YES;
    gpsView.hidden=YES;
    userLabel.text = [NSString stringWithFormat:@"@%@",[UserInfoContainer sharedInfo].userID];
    
    autoTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, inputView.frame.origin.y+40, 320, 160)];
    autoTableView.backgroundColor= RGB2(245, 245, 245);
    autoTableView.delegate=self;
    autoTableView.dataSource=self;
    [self.view addSubview:autoTableView];
    autoTableView.hidden=YES;
    
    inputBGView =[[UIControl alloc] initWithFrame:inputView.frame];
    // Do any additional setup after loading the view from its nib.
    inputBGView.layer.masksToBounds = NO;
    inputBGView.layer.shadowOffset = CGSizeMake(0, 5);
    inputBGView.layer.shadowRadius = 5;
    inputBGView.layer.shadowOpacity = 0.25;
    inputBGView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:inputBGView];
    inputView.backgroundColor=[UIColor clearColor];
    inputView.delegate=self;
    inputView.clipsToBounds=YES;
    [inputView becomeFirstResponder];
    
    [self.view bringSubviewToFront:inputView];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if(locationManager == nil){
        self.locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    
    locationFirst=NO;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = newLocation.coordinate.latitude;
    newRegion.center.longitude = newLocation.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.006878;
    newRegion.span.longitudeDelta = 0.013335;
    [gpsMapView setRegion:newRegion animated:YES];
    
    [manager stopUpdatingLocation];
    
    [self setMarker:newRegion inMapView:gpsMapView];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    MKCoordinateRegion newRegion;//37.528068,126.967691
    newRegion.center.latitude = 37.528068;
    newRegion.center.longitude = 126.967691;
    newRegion.span.latitudeDelta = 0.006878;
    newRegion.span.longitudeDelta = 0.013335;
    [gpsMapView setRegion:newRegion animated:YES];
    
    [self setMarker:newRegion inMapView:gpsMapView];
}


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

-(IBAction)cancel{
    UIActionSheet *menu = [[UIActionSheet alloc] 
                           initWithTitle: @"현재 작성하신 내용이 모두 사라집니다." 
                           delegate:self
                           cancelButtonTitle:@"취소"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"확인", nil];
	[menu showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0){
        [self dismissModalViewControllerAnimated:YES];
    }
	[actionSheet release];
}


-(IBAction)write{
    NSString *text = [[inputView text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([text isEqualToString:@""]){
        return;
    }
    if([inputView isFirstResponder]){
        [inputView resignFirstResponder];
    }
    
    if(HUD == nil){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }
    HUD.labelText = @"Updating...";
    [HUD show:YES];
    [self performSelector:@selector(updatePost) withObject:nil afterDelay:0.25f];
}

-(void)updatePost{
    NSString *attach = @"";
    for(id object in [imageScrollView subviews]){
        if([object isKindOfClass:[CustomUIControl class]]){
            if([(CustomUIControl *)object isHidden]){
                continue;
            }
            attach = [attach stringByAppendingFormat:@"%@.",[(CustomUIControl *)object attach_id]];
        }
    }
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:FEED_UPDATE_URL]];
    [request setPostValue:[inputView text] forKey:@"message"];
    [request setPostValue:attach forKey:@"attach_list"];
    [request setPostValue:self.location_info forKey:@"location_info"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        NSLog(@"%@",json);
        if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [self.navigationItem setPrompt:nil];
            [HUD hide:NO];
            [self dismissModalViewControllerAnimated:YES];
            if([delegate respondsToSelector:@selector(feedUploaded:)]){
                [delegate feedUploaded:nil];
            }
            
        }else{
            [self showErrorHUD:nil];
        }
        
    }else{
        [self showErrorHUD:error];
        NSLog(@"%@",[error localizedDescription]);
    }
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSLog(@"hi %@",text);
//    if ([text isEqualToString:@"@"]){
//        [self performSelector:@selector(atBtnAction)];
//    }
//    [[inputView text] stringByReplacingCharactersInRange:range withString:text];
//    return YES;
//}

-(void)textViewDidChange:(UITextView *)textView{
    //NSLog(@"%@",[textView text]);
    if([inputView.text length] < 1){
        return;
    }
    
    int index=[inputView.text length]-1;
    NSString *lastWord =[[NSMutableString alloc]initWithString:@""];
    NSString *character = [[inputView text] substringWithRange:NSMakeRange(index, 1)];
    while (![character isEqualToString:@""] && ![character isEqualToString:@" "]) {
        lastWord = [NSString stringWithFormat:@"%@%@",character,lastWord];
        if(index <= 0){
            break;
        }
        character = [[inputView text] substringWithRange:NSMakeRange(--index, 1)];
    }
    if([lastWord length] < 1){
        return;
    }
    NSString *prefix = [lastWord substringToIndex:1];
    NSRange range = [prefix rangeOfString :@"@"];
    if(range.location != NSNotFound){
        NSLog(@"Detect User %@",[lastWord substringFromIndex:1]);
        [self performSelector:@selector(atBtnAction)];
        [self detectUser:[lastWord substringFromIndex:1]];
    }
    range = [prefix rangeOfString :@"#"];
    if(range.location != NSNotFound){
        NSLog(@"Detect Topic %@",[lastWord substringFromIndex:1]);
        [self performSelector:@selector(atBtnAction)];
        [self detectTopic:[lastWord substringFromIndex:1]];
    }
    
}

-(void)detectUser:(NSString *)query{
    autoArray = [[NSMutableArray alloc] init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?q=%@",SEARCH_USER_URL, query]]];
    [request setDelegate:self];
    [request startAsynchronous];
    
}

-(void)detectTopic:(NSString *)query{
    autoArray = [[NSMutableArray alloc] init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?q=%@",SEARCH_TOPIC_URL, query]]];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *response = [request responseString];
    //NSLog(@"%@",response);
    NSError *theError = NULL;
    NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
    if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        NSArray *array = [json objectForKey:@"items"];
        for(NSDictionary *item in array){
            NSMutableDictionary *_item = [NSMutableDictionary dictionaryWithDictionary:item];
            [autoArray addObject:_item];
        }
    }
    [autoTableView reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    return;
}


-(IBAction)atBtnClilcked{
    if([inputView.text length] >= 1){
        int index=[inputView.text length]-1;
        NSString *lastCharacter = [[inputView text] substringWithRange:NSMakeRange(index, 1)];
        if([lastCharacter isEqualToString:@" "]){
            inputView.text=[NSString stringWithFormat:@"%@@",inputView.text];
        }else{
            inputView.text=[NSString stringWithFormat:@"%@ @",inputView.text];
        }
    }else{
        inputView.text=[NSString stringWithFormat:@"@"];
    }
    
    
    [self performSelector:@selector(atBtnAction)];
}
-(void)atBtnAction{
    if(![inputView isFirstResponder]){
        [inputView becomeFirstResponder];
    }
    [self makeSmallInputView];
}

-(IBAction)shopBtnClilcked{
    if([inputView.text length] >= 1){
        int index=[inputView.text length]-1;
        NSString *lastCharacter = [[inputView text] substringWithRange:NSMakeRange(index, 1)];
        if([lastCharacter isEqualToString:@" "]){
            inputView.text=[NSString stringWithFormat:@"%@#",inputView.text];
        }else{
            inputView.text=[NSString stringWithFormat:@"%@ #",inputView.text];
        }
    }else{
        inputView.text=[NSString stringWithFormat:@"#"];
    }
    
    [self performSelector:@selector(shopBtnAction)];
}
-(void)shopBtnAction{
    if(![inputView isFirstResponder]){
        [inputView becomeFirstResponder];
    }
    [self makeSmallInputView];
}

-(void)makeSmallInputView{
    CGRect frame = inputView.frame;
    frame.size.height = 60;
    inputView.frame=frame;
    frame.size.height = 40;
    inputBGView.frame=frame;
    
    autoTableView.hidden=NO;
    [self.view bringSubviewToFront:autoTableView];
    [self.view bringSubviewToFront:inputBGView];
    [self.view bringSubviewToFront:inputView];
    
    [inputView setUserInteractionEnabled:NO];
    [inputView becomeFirstResponder];
    
    [inputBGView addTarget:self action:@selector(makeOriginalInputView) forControlEvents:UIControlEventTouchUpInside];
}
-(void)makeOriginalInputView{
    CGRect frame = inputView.frame;
    frame.size.height = 160;
    inputView.frame=frame;
    inputBGView.frame=frame;
    [inputView setUserInteractionEnabled:YES];
    [inputView becomeFirstResponder];
    autoTableView.hidden=YES;
    autoArray = [[NSMutableArray alloc] init];
    [autoTableView reloadData];
}

-(IBAction)fileBtnClilcked{
    if([inputView isFirstResponder]){
        [inputView resignFirstResponder];
    }
    attachView.hidden=NO;
    gpsView.hidden=YES;
}

-(IBAction)gpsBtnClilcked{
    if([inputView isFirstResponder]){
        [inputView resignFirstResponder];
    }
    
    if(!locationFirst){
        [locationManager startUpdatingLocation];
        locationFirst=YES;
    }
    
    attachView.hidden=YES;
    gpsView.hidden=NO;
}

-(IBAction)removeGPS{
    [gpsMapView removeAnnotations:[gpsMapView annotations]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [autoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"User";
    static NSString *CellIdentifier2 = @"Topic";
    
    NSMutableDictionary *item = [autoArray objectAtIndex:indexPath.row];
    if([[item objectForKey:@"type"] isEqualToString:@"user"]){
        AutoTableViewCell *cell = (AutoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[AutoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier1] autorelease];
        }
        [cell prepareData:item];
        return cell;
    }else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2] autorelease];
        }
        cell.textLabel.text=[NSString stringWithFormat:@"#%@",[item objectForKey:@"topic_name"]];
        cell.textLabel.font=[UIFont boldSystemFontOfSize:12.0f];
        cell.textLabel.textColor=RGB2(50, 90, 180);
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int index=[inputView.text length]-1;
    NSString *lastWord =[[NSMutableString alloc]initWithString:@""];
    NSString *character = [[inputView text] substringWithRange:NSMakeRange(index, 1)];
    while (![character isEqualToString:@""] && ![character isEqualToString:@" "]) {
        lastWord = [NSString stringWithFormat:@"%@%@",character,lastWord];
        if(--index < 0){
            break;
        }
        character = [[inputView text] substringWithRange:NSMakeRange(index, 1)];
    }

    NSString *remainStr=[inputView.text substringToIndex:(index+1)];
    
    NSString *replaceStr=@"";
    NSMutableDictionary *item = [autoArray objectAtIndex:indexPath.row];
    if([[item objectForKey:@"type"] isEqualToString:@"user"]){
        replaceStr=[NSString stringWithFormat:@"@%@",[item objectForKey:@"username"]];
    }else{
        replaceStr=[NSString stringWithFormat:@"#%@",[item objectForKey:@"topic_name"]];
    }
    inputView.text=[NSString stringWithFormat:@"%@%@ ",remainStr,replaceStr];
    
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    [self performSelector:@selector(makeOriginalInputView)];
}



-(IBAction)pictureLibraryUpload{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //imagePickerController.allowsEditing=YES;
    [self presentModalViewController:imagePickerController animated:YES];
}

-(IBAction)pictureCameraUpload{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing=YES;
        [self presentModalViewController:imagePickerController animated:YES];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
	UIImage * img = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if(img == nil){
        img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    if(HUD == nil){
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
    }

    HUD.labelText = @"Uploading...";
    HUD.detailsLabelText = @"";
    [HUD show:YES];
    [self performSelector:@selector(updateImage:) withObject:img afterDelay:0.25f];

}
-(void)updateImage:(UIImage *)img{
    if(img != nil){
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:FILE_UPLOAD_URL]];
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
            if(!theError && [[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
                NSString *file_id=[[json objectForKey:@"file_id"] stringValue];
                self.attach_list=[NSString stringWithFormat:@"%@%@.",self.attach_list,file_id];
                [HUD hide:YES];
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
                
                CGFloat scaleFactor = 140.0f/img.size.height;
                CGFloat offsetX = imageScrollView.contentSize.width;
                if(offsetX == 0){
                    offsetX = 0;
                }
                imageView.layer.cornerRadius=5.0f;
                imageView.frame=CGRectMake(offsetX+10, 10, img.size.width * scaleFactor, img.size.height * scaleFactor);
                [imageScrollView addSubview:imageView];
                CGSize size = imageScrollView.contentSize;
                [imageScrollView setContentSize:CGSizeMake(size.width+imageView.frame.size.width+20, imageScrollView.frame.size.height)];
                
                CustomUIControl *control = [[CustomUIControl alloc] initWithFrame:imageView.frame];
                control.parentScrollView=imageScrollView;
                control.imageView=imageView;
                control.attach_id=[[json objectForKey:@"file_id"] stringValue];
                NSLog(@"%@",control.attach_id);
                [control addTarget:control action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
                [imageScrollView addSubview:control];
                
                size = imageScrollView.contentSize;
                [imageScrollView scrollRectToVisible:CGRectMake(size.width-10, 0, 10, 10) animated:YES];
            }else if(theError){
                [self showErrorHUD:theError];
            }else{
                [self showErrorHUD:nil];
            }
        }else{
            NSLog(@"Error : %@", [error localizedDescription]);
            [self showErrorHUD:error];
        }
    }else{
        NSLog(@"NULL %@", img);
    }
    
}

-(void)showErrorHUD:(NSError *)error{
    [HUD hide:NO];
    if(errorHUD == nil){
        errorHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:errorHUD];
        errorHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errorHUD.png"]] autorelease];
        errorHUD.mode = MBProgressHUDModeCustomView;
        errorHUD.labelText = @"Error Occurred";
    }
    [errorHUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask {
    sleep(1);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self dismissModalViewControllerAnimated:YES];
    
}

-(NSString*) stringWithUUID {
    CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return [uuidString autorelease];
}




-(void)setMarker:(MKCoordinateRegion)newRegion inMapView:(MKMapView *)mapView{
    MapMarker *mapMarker=[[MapMarker alloc] init];
    mapMarker.coordinate = newRegion.center;
    mapMarker.title=@"Here!";
    self.location_info=[NSString stringWithFormat:@"%f|%f",mapMarker.coordinate.latitude, mapMarker.coordinate.longitude];
    [mapView addAnnotation:mapMarker];
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
	NSString *reuseIdentifier = @"abcdefg";
	MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
	
	if(annotationView == nil) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
		annotationView.draggable = YES;
		annotationView.canShowCallout = YES;
        annotationView.animatesDrop= YES;
        
	}
	
	[annotationView setAnnotation:annotation];
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    if (oldState == MKAnnotationViewDragStateDragging) {
        MapMarker *pin = (MapMarker *) annotationView.annotation;        
        self.location_info=[NSString stringWithFormat:@"%f|%f",pin.coordinate.latitude, pin.coordinate.longitude];
    }
}
@end
