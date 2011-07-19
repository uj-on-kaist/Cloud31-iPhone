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

@implementation FeedPostViewController

@synthesize userLabel, inputView;
@synthesize delegate;
@synthesize atButton, topicButton, attachButton, gpsButton;


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
    
    userLabel.text = [NSString stringWithFormat:@"@%@",[UserInfoContainer sharedInfo].userID];
    
    // Do any additional setup after loading the view from its nib.
    inputView.layer.masksToBounds = NO;
    inputView.layer.shadowOffset = CGSizeMake(0, 5);
    inputView.layer.shadowRadius = 5;
    inputView.layer.shadowOpacity = 0.25;
    inputView.backgroundColor=[UIColor whiteColor];
    
    [inputView becomeFirstResponder];
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
    [self dismissModalViewControllerAnimated:YES];
    if([delegate respondsToSelector:@selector(feedUploaded:)]){
        [delegate feedUploaded:0];
    }
}


@end
