//
//  SignViewController.m
//  Cloud31-iphone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SignViewController.h"

#import "RootViewController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#import "Extensions/NSDictionary_JSONExtensions.h"


#import "UserInfoContainer.h"

@implementation LoginTableViewCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Custom initialization
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 160, 20)];
        self.textField.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1];
        self.textField.autocorrectionType=UITextAutocorrectionTypeNo;
        self.textField.autocapitalizationType=UITextAutocapitalizationTypeNone;
        [self addSubview:self.textField];
    }
    return self;
}
- (void)dealloc
{
    [textField release];
    [super dealloc];
}
-(void)cellClicked{
    [self.textField becomeFirstResponder];
}
@end

@implementation SignViewController

@synthesize _tableView;
@synthesize userPW, userID;

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
    [_tableView release];
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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Sign in";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Enter" style:UIBarButtonItemStyleDone target:self action:@selector(start_login)];
    
    //[self.navigationController setViewControllers:[NSArray arrayWithObject:[[RootViewController alloc] init]]];
}

-(void)start_login{
    [self.navigationItem setPrompt:@"Checking..."];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGIN_URL]];
    [request setPostValue:self.userID forKey:@"userID"];
    [request setPostValue:self.userPW forKey:@"userPW"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        
        if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [self.navigationItem setPrompt:nil];
            [[UserInfoContainer sharedInfo] setUserID:userID];
            [[UserInfoContainer sharedInfo] setUserPW:userPW];
            [[UserInfoContainer sharedInfo] saveUserLoginInfo];
            
            if([[UserInfoContainer sharedInfo] checkLogin]){
                [self performSelector:@selector(goToRoot) withObject:nil afterDelay:0.25];
            }
        }else{
            [self.navigationItem setPrompt:@"Check ID and Password."];
        }
        
    }else{
        [self.navigationItem setPrompt:@"Error Occured. Try again"];
    }
    
}

-(void)goToRoot{
    [self.navigationController setViewControllers:[NSArray arrayWithObject:[[RootViewController alloc] init]]];
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


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LoginTableViewCell *cell = (LoginTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[LoginTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textField.delegate=self;
        [cell.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        cell.textField.keyboardType=UIKeyboardTypeURL;
        NSString *title=@"";
        switch (indexPath.row) {
            case 0:
                title=@"사용자 아이디";
                [cell cellClicked];
                break;
            default:
                title=@"비밀번호";
                cell.textField.secureTextEntry=YES;
                break;
        }
        
        cell.textLabel.text=title;
    }
    
    // Configure the cell.
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LoginTableViewCell *cell = (LoginTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell cellClicked];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if(!textField.secureTextEntry){
        self.userID=[NSString stringWithString:textField.text];
    }else{
        self.userPW=[NSString stringWithString:textField.text];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return NO;
}
@end
