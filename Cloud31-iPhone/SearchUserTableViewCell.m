//
//  SearchUserTableViewCell.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 22..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "SearchUserTableViewCell.h"


@implementation SearchUserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(5, 5, 45, 45);
        [self addSubview:imageView];
        
        username=[[UILabel alloc] initWithFrame:CGRectMake(57, 5, 250, 15)];
        username.backgroundColor=[UIColor clearColor];
        username.font=[UIFont boldSystemFontOfSize:16.0f];
        username.textColor = [UIColor darkTextColor];
        username.shadowColor = RGBA2(255, 255, 255, 0.75);
        username.shadowOffset = CGSizeMake(0.0, 1.0);
        [self addSubview:username];
        
        userID=[[UILabel alloc] initWithFrame:CGRectMake(57, 20, 250, 15)];
        userID.backgroundColor=[UIColor clearColor];
        userID.font=[UIFont systemFontOfSize:12.0f];
        userID.textColor = [UIColor darkTextColor];
        userID.shadowColor = RGBA2(255, 255, 255, 0.5);
        userID.shadowOffset = CGSizeMake(1.0, 1.0);
        [self addSubview:userID];
        
        userDept=[[UILabel alloc] initWithFrame:CGRectMake(57, 35, 250, 14)];
        userDept.backgroundColor=[UIColor clearColor];
        userDept.font=[UIFont systemFontOfSize:12.0f];
        userDept.textColor = [UIColor darkTextColor];
        userDept.shadowColor = RGBA2(255, 255, 255, 0.5);
        userDept.shadowOffset = CGSizeMake(1.0, 1.0);
        [self addSubview:userDept];
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
    [imageView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, [item objectForKey:@"picture"]]]];
    
    userID.text=[NSString stringWithFormat:@"@%@",[item objectForKey:@"userID"]];
    username.text=[item objectForKey:@"name"];
    
    userDept.text=[NSString stringWithFormat:@"%@ %@",[item objectForKey:@"dept"], [item objectForKey:@"position"]];
}

@end
