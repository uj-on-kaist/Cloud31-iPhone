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
        //self.contentView.backgroundColor=RGB2(245, 245, 245);

        
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
        
        contents_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 25, 250, 0)];
        contents_label.numberOfLines=0;
        contents_label.text=@"author";
        contents_label.font=[UIFont systemFontOfSize:14.0f];
        contents_label.lineBreakMode=UILineBreakModeWordWrap;
        contents_label.backgroundColor=[UIColor clearColor];
        [self addSubview:contents_label];
        
        date_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 100, 15)];
        date_label.text=@"date";
        date_label.textAlignment=UITextAlignmentLeft;
        date_label.textColor=[UIColor darkGrayColor];
        date_label.backgroundColor=[UIColor clearColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];

        
        [self addSubview:date_label];
        
        comment_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 100, 15)];
        comment_label.text=@"";
        comment_label.textAlignment=UITextAlignmentLeft;
        comment_label.textColor=[UIColor darkGrayColor];
        comment_label.backgroundColor=[UIColor clearColor];
        comment_label.font=[UIFont systemFontOfSize:12.0f];
        [self addSubview:comment_label];
        
        favorite_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Favorite.png"]];
        favorite_image.frame=CGRectMake(57, 5, 22, 22);
        favorite_image.backgroundColor=[UIColor clearColor];
        [self addSubview:favorite_image];
        
        favorite_off_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Favorite-Off.png"]];
        favorite_off_image.frame=CGRectMake(57, 5, 22, 22);
        favorite_off_image.backgroundColor=[UIColor clearColor];
        [self addSubview:favorite_off_image];
        
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
    author_label.text=[item objectForKey:@"author"];
    NSString *url=[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"author_picture"]];
    [profileView setImageURL:[NSURL URLWithString:url]];
    
    date_label.text=[NSString stringWithFormat:@"%@  |",[item objectForKey:@"pretty_date"]];
    contents_label.text=[item objectForKey:@"contents_original"];
    CGRect frame = contents_label.frame;
    frame.size.height = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
    contents_label.frame=frame;

    
    frame = date_label.frame;
    frame.origin.x = 57;
    frame.origin.y = contents_label.frame.origin.y + contents_label.frame.size.height+10;
    CGSize suggestedSize= [date_label.text sizeWithFont:date_label.font constrainedToSize:CGSizeMake(100, 15) lineBreakMode:UILineBreakModeWordWrap];
    frame.size.width=suggestedSize.width;
    date_label.frame= frame;
    
    comment_label.text=[NSString stringWithFormat:@"|  %d comments", [[item objectForKey:@"comments"] count]];
    frame = comment_label.frame;
    frame.origin.y = date_label.frame.origin.y;
    frame.origin.x = date_label.frame.origin.x + date_label.frame.size.width+25;
    comment_label.frame= frame;
    
    frame = favorite_image.frame;
    frame.origin.y = date_label.frame.origin.y-3;
    frame.origin.x = date_label.frame.origin.x + date_label.frame.size.width+1;
    favorite_image.frame = frame;
    favorite_off_image.frame = frame;
    if([[item objectForKey:@"favorite"] boolValue]){
        favorite_image.hidden=NO; favorite_off_image.hidden=YES;
    }else{
        favorite_off_image.hidden=NO; favorite_image.hidden=YES;
    }
//    if([[item objectForKey:@"favorite"] boolValue]){
//        [comment_info setStarOn];
//    }else{
//        [comment_info setStarOff];
//    }
//    BOOL has_location=NO;
//    if([item objectForKey:@"lat"] != nil && [item objectForKey:@"lng"] != nil){
//        has_location=YES;
//    }
//    [comment_info setAttachInfo:[item objectForKey:@"file_list"] withLocation:has_location];
//    
//    int comment_count = [[item objectForKey:@"comments"] count];
//    [comment_info setCommentCount:comment_count];
//    bgView.frame=CGRectMake(0, 0, 320, contents_label.frame.size.height+50);
    
}

+(CGFloat)calculateHeight:(NSMutableDictionary *)item{
    CGSize suggestedSize = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    [item setValue:[NSNumber numberWithFloat:suggestedSize.height+50] forKey:@"height"];
    return MAX(suggestedSize.height+55, 60.0f);
}

@end
