//
//  FeedPostViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

#import "EGOImageView.h"
#import <MapKit/MapKit.h>

@protocol FeedPostDelegate <NSObject>

@required
-(void)feedUploaded:(NSMutableDictionary *)item;
@end


@interface FeedPostViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate> {
    IBOutlet UILabel *userLabel;
    IBOutlet UITextView *inputView;
    id<FeedPostDelegate> delegate;
    
    IBOutlet UIButton *atButton;
    IBOutlet UIButton *topicButton;
    IBOutlet UIButton *attachButton;
    IBOutlet UIButton *gpsButton;
    
    UIControl *inputBGView;
    IBOutlet UIView *attachView;
    IBOutlet UIView *gpsView;
    IBOutlet MKMapView *gpsMapView;
    
    MBProgressHUD *HUD;
    MBProgressHUD *errorHUD;
    UITableView *autoTableView;
    NSMutableArray *autoArray;
    
    BOOL search_user;
    BOOL search_topic;
    
    UIImagePickerController *imagePickerController;
    
    NSString *attach_list;
    
    NSString *location_info;
    
    IBOutlet UIScrollView *imageScrollView;
    
    CLLocationManager *locationManager;
    
    BOOL locationFirst;
}

@property (nonatomic, retain) IBOutlet UIButton *atButton;
@property (nonatomic, retain) IBOutlet UIButton *topicButton;
@property (nonatomic, retain) IBOutlet UIButton *attachButton;
@property (nonatomic, retain) IBOutlet UIButton *gpsButton;

@property (nonatomic, retain) IBOutlet UIView *attachView;
@property (nonatomic, retain) IBOutlet UIView *gpsView;
@property (nonatomic, retain) IBOutlet UILabel *userLabel;
@property (nonatomic, retain) IBOutlet UITextView *inputView;
@property(nonatomic,retain) id<FeedPostDelegate> delegate;

@property (nonatomic, retain) NSString *attach_list;
@property (nonatomic, retain) NSString *location_info;

@property (nonatomic, retain) IBOutlet UIScrollView *imageScrollView;
@property (nonatomic, retain) IBOutlet MKMapView *gpsMapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
-(IBAction)cancel;

-(void)makeSmallInputView;
-(void)makeOriginalInputView;

-(void)detectUser:(NSString *)query;
-(void)detectTopic:(NSString *)query;

-(NSString*) stringWithUUID;

-(void)setMarker:(MKCoordinateRegion)newRegion inMapView:(MKMapView *)mapView;

-(void)showErrorHUD:(NSError *)error;

-(IBAction)removeGPS;
@end
