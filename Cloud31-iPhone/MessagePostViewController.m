//
//  MessagePostViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessagePostViewController.h"
#import "UserInfoContainer.h"
#import <QuartzCore/QuartzCore.h>
#import "AutoTableViewCell.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

@implementation MessagePostViewController
@synthesize toTextView, contentsTextView, userLabel;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        toControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 44,320, 35)];
        toControl.backgroundColor=[UIColor clearColor];
        [toControl addTarget:self action:@selector(toControlClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:toControl];
        [self.view bringSubviewToFront:toControl];
        toControl.hidden=YES;
        
        autoTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 79, 320, 160)];
        autoTableView.backgroundColor= RGB2(245, 245, 245);
        autoTableView.delegate=self;
        autoTableView.dataSource=self;
        [self.view addSubview:autoTableView];
        autoTableView.hidden=YES;
    }
    return self;
}

-(void)toControlClicked{
    autoTableView.hidden=YES;
    toControl.hidden=YES;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    userLabel.text = [NSString stringWithFormat:@"@%@",[UserInfoContainer sharedInfo].userID];
    [toTextView becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void)textViewDidChange:(UITextView *)textView{
    //NSLog(@"%@",[textView text]);
    if([textView.text length] < 1){
        return;
    }
    
    int index=[textView.text length]-1;
    NSString *lastWord =[[NSMutableString alloc]initWithString:@""];
    NSString *character = [[textView text] substringWithRange:NSMakeRange(index, 1)];
    while (![character isEqualToString:@""] && ![character isEqualToString:@" "]) {
        lastWord = [NSString stringWithFormat:@"%@%@",character,lastWord];
        if(index <= 0){
            break;
        }
        character = [[textView text] substringWithRange:NSMakeRange(--index, 1)];
    }
    if([lastWord length] < 1){
        return;
    }
    NSString *prefix = [lastWord substringToIndex:1];
    NSRange range = [prefix rangeOfString :@"@"];
    autoTableView.hidden=YES;
    toControl.hidden=YES;
    if(range.location != NSNotFound){
        NSLog(@"Detect User %@",[lastWord substringFromIndex:1]);
        [self detectUser:[lastWord substringFromIndex:1]];
        autoTableView.hidden=NO;
        toControl.hidden=NO;
    }
    range = [prefix rangeOfString :@"#"];
    if(range.location != NSNotFound){
        return;
    }
    
}

-(void)detectUser:(NSString *)query{
    autoArray = [[NSMutableArray alloc] init];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?q=%@",SEARCH_USER_URL, query]]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [autoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"User";
    
    NSMutableDictionary *item = [autoArray objectAtIndex:indexPath.row];
    if([[item objectForKey:@"type"] isEqualToString:@"user"]){
        AutoTableViewCell *cell = (AutoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[AutoTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier1] autorelease];
        }
        [cell prepareData:item];
        return cell;
    }else{
        return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"nil"];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int index=[toTextView.text length]-1;
    NSString *lastWord =[[NSMutableString alloc]initWithString:@""];
    NSString *character = [[toTextView text] substringWithRange:NSMakeRange(index, 1)];
    while (![character isEqualToString:@""] && ![character isEqualToString:@" "]) {
        lastWord = [NSString stringWithFormat:@"%@%@",character,lastWord];
        if(--index < 0){
            break;
        }
        character = [[toTextView text] substringWithRange:NSMakeRange(index, 1)];
    }
    
    NSString *remainStr=[toTextView.text substringToIndex:(index+1)];
    
    NSString *replaceStr=@"";
    NSMutableDictionary *item = [autoArray objectAtIndex:indexPath.row];
    if([[item objectForKey:@"type"] isEqualToString:@"user"]){
        replaceStr=[NSString stringWithFormat:@"@%@",[item objectForKey:@"username"]];
    }else{
        replaceStr=[NSString stringWithFormat:@"#%@",[item objectForKey:@"topic_name"]];
    }
    toTextView.text=[NSString stringWithFormat:@"%@%@ ",remainStr,replaceStr];
    
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    
    autoTableView.hidden=YES;
    toControl.hidden=YES;
}



-(IBAction)close{
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
    NSLog(@"TO: %@", toTextView.text);
    NSLog(@"Contents: %@", contentsTextView.text);
    
    NSString *text = [[toTextView text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([text isEqualToString:@""]){
        [self showErrorHUDWithString:@"Empty Receivers"];
        return;
    }
    NSString *text2 = [[contentsTextView text] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([text2 isEqualToString:@""]){
        [self showErrorHUDWithString:@"Empty Message"];
        return;
    }
    
    if([toTextView isFirstResponder]){
        [toTextView resignFirstResponder];
    }else if([contentsTextView isFirstResponder]){
        [contentsTextView resignFirstResponder];
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
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:MESSAGE_UPDATE_URL]];
    [request setPostValue:[contentsTextView text] forKey:@"message"];
    [request setPostValue:[toTextView text] forKey:@"receivers"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [HUD hide:NO];
            
            
            [delegate messageUploaded:nil];
            
            [self dismissModalViewControllerAnimated:YES];
        }else{
            [self showErrorHUD:nil];
        }
        
    }else{
        [self showErrorHUD:error];
        NSLog(@"%@",[error localizedDescription]);
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
-(void)showErrorHUDWithString:(NSString *)error{
    [HUD hide:NO];
    if(errorHUD == nil){
        errorHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:errorHUD];
        errorHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"errorHUD.png"]] autorelease];
        errorHUD.mode = MBProgressHUDModeCustomView;
        
    }
    errorHUD.labelText = error;
    [errorHUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
}
-(void)myTask {
    sleep(1);
}

@end
