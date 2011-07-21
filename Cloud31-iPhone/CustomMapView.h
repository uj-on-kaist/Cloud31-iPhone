//
//  KaistMapView.h
//  ManDo
//
//  Created by 정의준 on 11. 5. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

#import <MapKit/MapKit.h>


#import <MapKit/MKAnnotation.h>


@interface MapMarker : NSObject <MKAnnotation>{
	//요거 세개는 어노테이션에 필수로 구현해줘야 동작한다.
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;

@end

@interface CustomMapView : TTView <MKMapViewDelegate>{
    MKMapView *_map;
    
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

-(void)prepareView;
@end
