//
//  SearchUserTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 22..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface SearchUserTableViewCell : UITableViewCell {
    EGOImageView *imageView;
    
    UILabel *userID;
    UILabel *username;
    UILabel *userDept;
    
}

-(void)prepareData:(NSMutableDictionary *)item;

@end
