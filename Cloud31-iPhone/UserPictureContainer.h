//
//  UserPictureContainer.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserPictureContainer : NSObject {
    NSMutableDictionary *container;
}

@property (nonatomic, retain) NSMutableDictionary *container;

+ (UserPictureContainer *)sharedContainer;

-(UIImage *)getUserImage:(NSString *)url;
-(void)addUserImage:(UIImage *)image withURL:(NSString *)url;
@end
