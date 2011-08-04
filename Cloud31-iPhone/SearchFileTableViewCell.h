//
//  SearchFileTableViewCell.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 22..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchFileTableViewCell : UITableViewCell {
    UIImageView *file_type;
    
    UILabel *file_name;
    UILabel *file_format;
    
}

-(void)prepareData:(NSMutableDictionary *)item;

@end
