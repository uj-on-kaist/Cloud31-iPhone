//
//  ImageListView.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "ImageListView.h"
#import "Cloud31_iPhoneAppDelegate.h"

#import "Three20/Three20.h"
#import "MockPhotoSource.h"
@implementation ImageListView

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

-(void)prepareView:(NSArray *)item{
    //NSLog(@"%@",item);
    self._item = [NSMutableArray arrayWithArray:item];
    
    NSString *HTML=@"";
    HTML=[HTML stringByAppendingFormat:@"<link rel='stylesheet' href='/static/css/mobile.css' type='text/css' /> "];
    HTML=[HTML stringByAppendingFormat:@"<ul class='image_list'>"];
    
//    HTML=[HTML stringByAppendingFormat:@"<li><img src='/static/image/Introduction_logo.png'/></li>"];
//    HTML=[HTML stringByAppendingFormat:@"<li><img src='/static/image/Introduction_logo.png'/></li>"];
//    HTML=[HTML stringByAppendingFormat:@"<li><img src='/static/image/Introduction_logo.png'/></li>"];
//    HTML=[HTML stringByAppendingFormat:@"<li><img src='/static/image/Introduction_logo.png'/></li>"];
    
    for(NSDictionary *file in item){
        if([[file objectForKey:@"type"] isEqualToString:@"img"]){
            HTML=[HTML stringByAppendingFormat:@"<li><a href='%@'><img src='%@'/></a></li>",[file objectForKey:@"url"],[file objectForKey:@"url"]];
        }else{
            continue;
        }
    }
    
    
    HTML=[HTML stringByAppendingFormat:@"</ul>"];
    [self loadHTMLString:HTML baseURL:[NSURL URLWithString:ServiceURL]];
    
    [(UIScrollView*)[self.subviews objectAtIndex:0] setShowsHorizontalScrollIndicator:NO];
    [(UIScrollView*)[self.subviews objectAtIndex:0] setShowsVerticalScrollIndicator:NO];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        //TTWebController *webController=[[TTWebController alloc]init];
        //[webController openURL:[request URL]];
        //webController.navigationBarTintColor=NAVIGATION_TINT_COLOR;
        //Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        //[app_delegate.navigationController pushViewController:webController animated:YES];
        
        
        TTPhotoViewController *photoViewController=[[TTPhotoViewController alloc] init];
        //photoViewController.photoSource = [[]];
        
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        
        for(NSDictionary *file in _item){
            if([[file objectForKey:@"type"] isEqualToString:@"img"]){
                NSString *url = [NSString stringWithFormat:@"%@%@",ServiceURL, [file objectForKey:@"url"]];
                MockPhoto *photo = [[MockPhoto alloc] initWithURL:url smallURL:url size:CGSizeMake(320, 480)];
                [photos addObject:photo];
            }else{
                continue;
            }
        }
        
        photoViewController.photoSource = [[[MockPhotoSource alloc] initWithType:MockPhotoSourceNormal title:@"Photos"
                             photos:photos photos2:nil] autorelease];
        Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app_delegate.navigationController pushViewController:photoViewController animated:YES];
        
        return NO;
    }
    return YES;
}


@end
