//
//  KaistMapView.m
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "CustomMapView.h"

@implementation MapMarker
@synthesize coordinate, title, subtitle;

-(void) dealloc{
	[title release];
	[subtitle release];
	[super dealloc];
}
@end

@implementation CustomMapView
@synthesize coordinate;
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self prepareView];
    }
    return self;
}


-(void)prepareView{
    _map=[[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //_map.showsUserLocation=YES;
    _map.delegate=self;
    
    _map.layer.cornerRadius=15.0f;
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 36.371638;
    newRegion.center.longitude = 127.360894;
    newRegion.span.latitudeDelta = 0.006878;
    newRegion.span.longitudeDelta = 0.013335;
    [_map setRegion:newRegion animated:YES];
    [self addSubview:_map];
    
    
    MapMarker *mapMarker=[[MapMarker alloc] init];
    mapMarker.coordinate = newRegion.center;
    mapMarker.title=@"Here!";
    coordinate=mapMarker.coordinate;
    [_map addAnnotation:mapMarker];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    //MKCoordinateRegion newRegion=mapView.region;
    //NSLog(@"%f %f %f %f",newRegion.center.latitude, newRegion.center.longitude, newRegion.span.latitudeDelta,newRegion.span.longitudeDelta );
}
//맵의 어노테이션 (마커) 표시.
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
        coordinate=pin.coordinate;
        //NSLog(@"%f %f",coordinate.latitude, coordinate.longitude);
    }
}
@end
