//
//  NotificationTableViewCell.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 30..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "UserPictureContainer.h"

@implementation NotificationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        
        [self addSubview:bgView];
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        border.backgroundColor=[UIColor whiteColor];
        [self addSubview:border];
        
        
        
        
        
        profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]];
        profileView.contentMode = UIViewContentModeScaleToFill;
        profileView.frame = CGRectMake(5, 5, 45, 45);
        [self addSubview:profileView];
        
        contents_label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(57, 5, 245, 0)];
        contents_label.font=[UIFont systemFontOfSize:15.0f];
        contents_label.backgroundColor=[UIColor clearColor];
        [self addSubview:contents_label];
        
        date_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 100, 15)];
        date_label.text=@"date";
        date_label.textAlignment=UITextAlignmentLeft;
        date_label.textColor=[UIColor grayColor];
        date_label.backgroundColor=[UIColor clearColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];
        
        
        [self addSubview:date_label];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        UIImageView *profile_frame =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_frame.png"]];
        profile_frame.frame = CGRectMake(4, 4, 48, 46);
        profile_frame.backgroundColor=[UIColor clearColor];
        [self addSubview:profile_frame];
        
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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

    NSString *url=[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"sender_picture"]];
    UIImage *cached=[[UserPictureContainer sharedContainer] getUserImage:url];
    if(cached == nil){
        [profileView setImageURL:[NSURL URLWithString:url]];
    }else{
        [profileView setImage:cached];
    }
    
    date_label.text=[NSString stringWithFormat:@"%@",[item objectForKey:@"pretty_date"]];
    
    TTStyledText* styledText = [TTStyledText textFromXHTML:[item objectForKey:@"contents"] lineBreaks:YES URLs:NO];
    contents_label.text=styledText;
    contents_label.font=[UIFont systemFontOfSize:14.0f];
    contents_label.userInteractionEnabled=NO;
    [contents_label sizeToFit];
    
    
    
    CGRect frame = date_label.frame;
    frame.origin.y = contents_label.frame.origin.y + contents_label.frame.size.height+10;
    CGSize suggestedSize= [date_label.text sizeWithFont:date_label.font constrainedToSize:CGSizeMake(100, 15) lineBreakMode:UILineBreakModeWordWrap];
    frame.size.width=suggestedSize.width;
    date_label.frame= frame;
   
    if([[item objectForKey:@"is_read"] isEqualToNumber:[NSNumber numberWithInt:0]]){
        bgView.hidden=NO;
        bgView.frame=CGRectMake(0, 0, 320,contents_label.frame.size.height+35);
        bgView.backgroundColor=RGB2(250,245,215);
    }else{
        bgView.hidden=YES;
    }
}

+(CGFloat)calculateHeight:(NSMutableDictionary *)item{
    TTStyledTextLabel *temp = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(57, 5, 245, 0)];
    temp.font=[UIFont systemFontOfSize:14.0f];
    temp.backgroundColor=[UIColor clearColor];
    TTStyledText* styledText = [TTStyledText textFromXHTML:[item objectForKey:@"contents"] lineBreaks:YES URLs:YES];
    temp.text=styledText;
    temp.font=[UIFont systemFontOfSize:14.0f];
    temp.userInteractionEnabled=YES;
    [temp sizeToFit];
    
    return temp.frame.size.height+35;
}

@end
