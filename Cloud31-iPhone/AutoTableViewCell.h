//
//  AutoTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface AutoTableViewCell : UITableViewCell {
    EGOImageView *profileView;
    
    UILabel *userID;
    UILabel *username;
}

-(void)prepareData:(NSMutableDictionary *)item;

@end
