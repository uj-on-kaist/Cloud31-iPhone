//
//  ReplyPostViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "ReplyPostViewController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

@implementation ReplyPostViewController

@synthesize message_id;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"New Reply";
}

- (void)post{
    if([[self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
        return;
    }
    NSLog(@"Comment Update for feed_%@",self.message_id);
    if([self.message_id intValue] == 0){
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
	
    HUD.labelText = @"Updating...";
    
    [self.view addSubview:HUD];
    
    [HUD show:YES];
    [self performSelector:@selector(hideKeyboard)];
    [self performSelector:@selector(uploadComment) withObject:nil afterDelay:1.5f];
}

-(void)uploadComment{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REPLY_UPDATE_URL]];
    [request setPostValue:self.textView.text forKey:@"message"];
    [request setPostValue:self.message_id forKey:@"message_id"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        NSError *theError = NULL;
        NSDictionary *json = [NSDictionary dictionaryWithJSONString:response error:&theError];
        if([[json objectForKey:@"success"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            [HUD hide:YES];
            [super post];
        }else{
            [HUD hide:NO];
            HUD.labelText = @"Error Occured";
            [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        }
        
    }else{
        HUD.labelText = @"Error Occured";
        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        NSLog(@"%@",[error localizedDescription]);
    }
}
-(void)myTask {
    sleep(1);
}


@end