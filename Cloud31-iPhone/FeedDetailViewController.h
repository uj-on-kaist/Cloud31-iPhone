//
//  FeedDetailViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RLViewController.h"

#import "Three20/Three20.h"
#import "MBProgressHUD.h"
#import "ImageListView.h"
#import <MapKit/MapKit.h>

@class  CommentInfoView;
@interface FeedDetailViewController : RLViewController<TTNavigatorDelegate, TTPostControllerDelegate, UIActionSheetDelegate, MKMapViewDelegate, UIWebViewDelegate> {
    NSMutableDictionary *item;
    UIWebView *contents_label;
    NSMutableArray *comments;
    
    BOOL from_comment_update;
    
    CommentInfoView *comment_info;
    
    MBProgressHUD *HUD;
    
    
    ImageListView *imageListView;
    
    MKMapView *mapView;
    
    
    UIWebView *content_view;
    UIButton *commentPostView;
    
    ASIHTTPRequest *request;
}

@property (nonatomic, retain) NSMutableDictionary *item;

-(id)initWithItem:(NSMutableDictionary *)aItem;
-(void)reloadData;
-(void)showTopicDetailController:(NSString *)query;
-(void)showUserDetailController:(NSString *)query;

-(void)loadRestData;

@end
