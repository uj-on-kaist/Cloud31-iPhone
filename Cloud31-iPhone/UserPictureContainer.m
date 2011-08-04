//
//  UserPictureContainer.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "UserPictureContainer.h"


@implementation UserPictureContainer

@synthesize container;

static UserPictureContainer *sharedInfo = NULL;

+ (UserPictureContainer *)sharedContainer{
    @synchronized(self) {
        if (sharedInfo == NULL){
            sharedInfo = [[self alloc] init];
            sharedInfo.container= [[NSMutableDictionary alloc] init];
        }
    }   
    return(sharedInfo);
}

-(UIImage *)getUserImage:(NSString *)url{
    return [self.container objectForKey:url];
}

-(void)addUserImage:(UIImage *)image withURL:(NSString *)url{
    [self.container setObject:image forKey:url];
}

@end
