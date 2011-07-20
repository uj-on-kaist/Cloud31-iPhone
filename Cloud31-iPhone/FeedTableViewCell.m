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
#import "UserPictureContainer.h"

@implementation FeedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        border.backgroundColor=[UIColor whiteColor];
        [self addSubview:border];
        self.contentView.backgroundColor=RGB2(245, 245, 245);
//        bgView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellGradientBackground.png"]];
//        bgView.backgroundColor=[UIColor whiteColor];
//        bgView.frame=CGRectMake(0, 0, 320, 43);
//        [self addSubview:bgView];
        
        profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]];
        profileView.frame= CGRectMake(10, 10, 60, 60);
        profileView.contentMode = UIViewContentModeScaleToFill;
        profileView.frame = CGRectMake(5, 5, 45, 45);
        [self addSubview:profileView];
        
        
        author_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 160, 15)];
        author_label.text=@"author";
        author_label.font=[UIFont boldSystemFontOfSize:14.0f];
        author_label.textColor=RGB2(50,90,170);
        author_label.backgroundColor=[UIColor clearColor];
        [self addSubview:author_label];
        
        contents_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 20, 250, 0)];
        contents_label.numberOfLines=0;
        contents_label.text=@"author";
        contents_label.font=[UIFont systemFontOfSize:14.0f];
        contents_label.lineBreakMode=UILineBreakModeWordWrap;
        contents_label.backgroundColor=[UIColor clearColor];
        [self addSubview:contents_label];
        
        date_label = [[UILabel alloc] initWithFrame:CGRectMake(210, 5, 100, 15)];
        date_label.text=@"date";
        date_label.textAlignment=UITextAlignmentRight;
        date_label.textColor=[UIColor darkGrayColor];
        date_label.backgroundColor=[UIColor clearColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];
        
        comment_info = [[CommentInfoView alloc] initWithFrame:CGRectMake(57, 5, 260, 20)];
        comment_info.backgroundColor=[UIColor clearColor];
        [self addSubview:comment_info];
        
        [self addSubview:date_label];
        
        //self.selectionStyle=UITableViewCellSelectionStyleGray;
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
    author_label.text=[item objectForKey:@"author"];
    //self.selectionStyle=UITableViewCellSelectionStyleNone;
    date_label.text=[item objectForKey:@"pretty_date"];
    contents_label.text=[item objectForKey:@"contents_original"];
    CGRect frame = contents_label.frame;
    frame.size.height = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
    contents_label.frame=frame;
    
    frame = comment_info.frame;
    frame.origin.y = contents_label.frame.origin.y + contents_label.frame.size.height+5;
    comment_info.frame= frame;
    
    NSString *url=[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"author_picture"]];
    [profileView setImageURL:[NSURL URLWithString:url]];
    if([[item objectForKey:@"favorite"] boolValue]){
        [comment_info setStarOn];
    }else{
        [comment_info setStarOff];
    }
    
    int comment_count = [[item objectForKey:@"comments"] count];
    [comment_info setCommentCount:comment_count];
//    bgView.frame=CGRectMake(0, 0, 320, contents_label.frame.size.height+50);
    
}

+(CGFloat)calculateHeight:(NSMutableDictionary *)item{
    CGSize suggestedSize = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    [item setValue:[NSNumber numberWithFloat:suggestedSize.height+50] forKey:@"height"];
    return MAX(suggestedSize.height+50, 60.0f);
}

@end
