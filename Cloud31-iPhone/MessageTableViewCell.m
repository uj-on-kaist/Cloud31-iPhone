//
//  MessageTableViewCell.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 19..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageTableViewCell.h"


@implementation MessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        border.backgroundColor=[UIColor whiteColor];
        [self addSubview:border];
        
        profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]];
        profileView.frame= CGRectMake(10, 10, 60, 60);
        profileView.contentMode = UIViewContentModeScaleToFill;
        profileView.frame = CGRectMake(5, 5, 45, 45);
        [self addSubview:profileView];
        
        member_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 160, 15)];
        member_label.text=@"author";
        member_label.font=[UIFont boldSystemFontOfSize:14.0f];
        member_label.textColor=[UIColor darkTextColor];
        member_label.backgroundColor=[UIColor clearColor];
        [self addSubview:member_label];
        
        contents_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 20, 250, 0)];
        contents_label.numberOfLines=0;
        contents_label.text=@"author";
        contents_label.font=[UIFont systemFontOfSize:13.0f];
        contents_label.lineBreakMode=UILineBreakModeWordWrap;
        contents_label.backgroundColor=[UIColor clearColor];
        contents_label.textColor=[UIColor darkGrayColor];
        [self addSubview:contents_label];
        
        date_label = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 100, 15)];
        date_label.text=@"date";
        date_label.textAlignment=UITextAlignmentRight;
        date_label.textColor=[UIColor darkGrayColor];
        date_label.backgroundColor=[UIColor clearColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];

        [self addSubview:date_label];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
    member_label.text=[NSString stringWithFormat:@"%@ → %@",[item objectForKey:@"author"],[item objectForKey:@"receivers"]];
    //self.selectionStyle=UITableViewCellSelectionStyleNone;
    date_label.text=[item objectForKey:@"pretty_date"];
    contents_label.text=[item objectForKey:@"latest_reply"];
    CGRect frame = contents_label.frame;
    frame.size.height = [[item objectForKey:@"latest_reply"] sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:CGSizeMake(250, 50) lineBreakMode:UILineBreakModeCharacterWrap].height;
    contents_label.clipsToBounds=YES;
    contents_label.frame=frame;
    
    NSString *url=[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"author_picture"]];
    [profileView setImageURL:[NSURL URLWithString:url]];
    
    
    
}

+(CGFloat)calculateHeight:(NSMutableDictionary *)item{
    return 80.0f;
}

@end
