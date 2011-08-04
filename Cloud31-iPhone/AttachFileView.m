//
//  AttachFileView.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "AttachFileView.h"
#import "Cloud31_iPhoneAppDelegate.h"

#import "Three20/Three20.h"
#import "MockPhotoSource.h"

@implementation AttachFileView

@synthesize _item;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _item = [[NSMutableDictionary alloc]init];
        self.delegate=self;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)dealloc
{
    [super dealloc];
}

-(void)prepareView:(NSMutableDictionary *)item{
    //NSLog(@"%@",item);
    self._item = [NSMutableDictionary dictionaryWithDictionary:item];
    
    NSString *HTML=@"";
    HTML=[HTML stringByAppendingFormat:@"<link rel='stylesheet' href='/static/css/mobile.css' type='text/css' /> "];
    HTML=[HTML stringByAppendingFormat:@"<div class='attach_file_box'><a href='%@'><p>",[item objectForKey:@"url"]];

    //[myWebView loadHTMLString:[NSString stringWithFormat:@"<html><body><img src=\"file://%@\"></body></html>",path] baseURL:nil];
    HTML=[HTML stringByAppendingFormat:@"<img src='/static/image/Mobile_File_icon_%@.jpg' />",[item objectForKey:@"type"]];
    HTML=[HTML stringByAppendingFormat:@"<span>%@</span>",[item objectForKey:@"name"]];
    //    HTML=[HTML stringByAppendingFormat:@"<li><img src='/static/image/Introduction_logo.png'/></li>"];
    //    HTML=[HTML stringByAppendingFormat:@"<li><img src='/static/image/Introduction_logo.png'/></li>"];
    //    HTML=[HTML stringByAppendingFormat:@"<li><img src='/static/image/Introduction_logo.png'/></li>"];
    
    
    HTML=[HTML stringByAppendingFormat:@"</p></a></div>"];
    [self loadHTMLString:HTML baseURL:[NSURL URLWithString:ServiceURL]];
    
    [(UIScrollView*)[self.subviews objectAtIndex:0] setScrollEnabled:NO];
    //[(UIScrollView*)[self.subviews objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        TTWebController *webController=[[TTWebController alloc]init];
        [webController openURL:[request URL]];
        webController.navigationBarTintColor=NAVIGATION_TINT_COLOR;
        Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app_delegate.navigationController pushViewController:webController animated:YES];

        return NO;
    }
    return YES;
}
@end
