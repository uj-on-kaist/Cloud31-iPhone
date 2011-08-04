//
//  CommentPostController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 21..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "CommentPostController.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Extensions/NSDictionary_JSONExtensions.h"

@implementation CommentPostController

@synthesize feed_id;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.title=@"New Comment";
}

- (void)post{
    if([[_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]){
        return;
    }
    NSLog(@"Comment Update for feed_%@",self.feed_id);
    if([self.feed_id intValue] == 0){
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
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:COMMENT_UPDATE_URL]];
    [request setPostValue:_textView.text forKey:@"message"];
    [request setPostValue:self.feed_id forKey:@"feed_id"];
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
