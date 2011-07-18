//
//  FeedTableViewCell.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 18..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "FeedTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#import "EGOImageView.h"

@implementation FeedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        profileView = [[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]] autorelease];
        profileView.frame = CGRectMake(5, 5, 45, 45);
        profileView.clipsToBounds=NO;
        profileView.layer.cornerRadius = 5.0;
        profileView.layer.shadowOpacity = 0.1f;
        profileView.layer.shadowRadius = 2.0;
        [self addSubview:profileView];
        
        
        author_label = [[[UILabel alloc] initWithFrame:CGRectMake(57, 5, 100, 15)] autorelease];
        author_label.text=@"author";
        author_label.font=[UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:author_label];
        
        contents_label = [[[UILabel alloc] initWithFrame:CGRectMake(57, 20, 250, 0)] autorelease];
        contents_label.numberOfLines=0;
        contents_label.text=@"author";
        contents_label.font=[UIFont systemFontOfSize:14.0f];
        contents_label.lineBreakMode=UILineBreakModeWordWrap;
        [self addSubview:contents_label];
        
        date_label = [[[UILabel alloc] initWithFrame:CGRectMake(180, 5, 130, 15)] autorelease];
        date_label.text=@"date";
        date_label.textAlignment=UITextAlignmentRight;
        date_label.textColor=[UIColor darkGrayColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];
        [self addSubview:date_label];
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

-(void)prepareData:(NSDictionary *)item{
    author_label.text=[item objectForKey:@"author"];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    date_label.text=[item objectForKey:@"reg_date"];
    contents_label.text=[item objectForKey:@"contents_original"];
    CGRect frame = contents_label.frame;
    frame.size.height = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
    contents_label.frame=frame;
    
    [profileView setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"author_picture"]]]];
}

+(CGFloat)calculateHeight:(NSDictionary *)item{
    CGSize suggestedSize = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    return MAX(suggestedSize.height+25, 60.0f);
}



@end
