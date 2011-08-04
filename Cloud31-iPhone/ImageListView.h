//
//  ImageListView.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageListView : UIWebView <UIWebViewDelegate>{
    NSMutableArray *_item;
}

@property (nonatomic, retain) NSMutableArray *_item;

-(void)prepareView:(NSArray *)item;

@end
