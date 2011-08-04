//
//  SearchFileTableViewCell.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 22..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SearchFileTableViewCell.h"


@implementation SearchFileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        file_type=[[UIImageView alloc] initWithFrame:CGRectMake(5,5, 45, 45)];
        
        [self addSubview:file_type];
        file_name=[[UILabel alloc] initWithFrame:CGRectMake(57, 12, 250, 15)];
        file_name.backgroundColor=[UIColor clearColor];
        file_name.font=[UIFont boldSystemFontOfSize:16.0f];
        file_name.textColor = [UIColor darkTextColor];
        file_name.shadowColor = RGBA2(255, 255, 255, 0.75);
        file_name.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:file_name];
        
        file_format=[[UILabel alloc] initWithFrame:CGRectMake(57, 27, 250, 15)];
        file_format.backgroundColor=[UIColor clearColor];
        file_format.font=[UIFont systemFontOfSize:12.0f];
        file_format.textColor = [UIColor darkTextColor];
        file_format.shadowColor = RGBA2(255, 255, 255, 0.5);
        file_format.shadowOffset = CGSizeMake(1.0, 1.0);
        [self addSubview:file_format];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}


-(void)prepareData:(NSMutableDictionary *)item{
    file_type.image = [UIImage imageNamed:[NSString stringWithFormat:@"search_file_%@.png",[item objectForKey:@"type"]]];
    
    file_name.text=[item objectForKey:@"name"];
    file_format.text=[item objectForKey:@"type_name"];
}

@end
