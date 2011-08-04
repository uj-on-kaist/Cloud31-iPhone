//
//  AttachFileView.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AttachFileView : UIWebView <UIWebViewDelegate>{
    NSMutableDictionary *_item;
}

@property (nonatomic, retain) NSMutableDictionary *_item;

-(void)prepareView:(NSDictionary *)item;

@end
