//
//  AutoTableViewCell.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "AutoTableViewCell.h"


@implementation AutoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        border.backgroundColor=[UIColor whiteColor];
        [self addSubview:border];
        //        bgView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellGradientBackground.png"]];
        //        bgView.backgroundColor=[UIColor whiteColor];
        //        bgView.frame=CGRectMake(0, 0, 320, 43);
        //        [self addSubview:bgView];
        
        profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]];
        profileView.frame= CGRectMake(0, 0, 39, 39);
        profileView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:profileView];
        
        userID = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 15)];
        userID.font=[UIFont boldSystemFontOfSize:12.0f];
        userID.textColor=[UIColor darkTextColor];
        userID.text=@"@test";
        userID.backgroundColor=[UIColor clearColor];
        [self addSubview:userID];
        
        username = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 200, 15)];
        username.font=[UIFont systemFontOfSize:12.0f];
        username.textColor=[UIColor darkGrayColor];
        username.text=@"정의준 test";
        username.backgroundColor=[UIColor clearColor];
        [self addSubview:username];
        
        self.selectionStyle=UITableViewCellSelectionStyleGray;
    }
    return self;
}

-(void)prepareData:(NSMutableDictionary *)item{
    if(item == nil){
        profileView.hidden=YES;
        userID.text=@"";
        username.text=@"";
    }
    profileView.hidden=NO;
    [profileView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, [item objectForKey:@"picture"]]]];
    
    userID.text=[NSString stringWithFormat:@"@%@",[item objectForKey:@"username"]];
    username.text=[NSString stringWithFormat:@"@%@",[item objectForKey:@"name"]];
}

- (void)dealloc
{
    [super dealloc];
}

@end
