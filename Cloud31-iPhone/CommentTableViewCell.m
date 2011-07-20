//
//  CommentTableViewCell.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "CommentTableViewCell.h"


@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        border.backgroundColor=RGBA2(240,240,240,0.75f);
        [self addSubview:border];
        //        bgView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellGradientBackground.png"]];
        //        bgView.backgroundColor=[UIColor whiteColor];
        //        bgView.frame=CGRectMake(0, 0, 320, 43);
        //        [self addSubview:bgView];
        
        profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]];
        profileView.contentMode = UIViewContentModeScaleToFill;
        profileView.frame = CGRectMake(10, 5, 35, 35);
        [self addSubview:profileView];
        
        
        author_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 160, 15)];
        author_label.text=@"author";
        author_label.font=[UIFont boldSystemFontOfSize:13.0f];
        author_label.textColor=[UIColor darkTextColor];
        author_label.backgroundColor=[UIColor clearColor];
        [self addSubview:author_label];
        
        contents_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 20, 250, 0)];
        contents_label.numberOfLines=0;
        contents_label.text=@"author";
        contents_label.font=[UIFont systemFontOfSize:13.0f];
        contents_label.textColor=[UIColor darkGrayColor];
        contents_label.lineBreakMode=UILineBreakModeWordWrap;
        contents_label.backgroundColor=[UIColor clearColor];
        [self addSubview:contents_label];
        
        date_label = [[UILabel alloc] initWithFrame:CGRectMake(190, 5, 120, 15)];
        date_label.text=@"date";
        date_label.textAlignment=UITextAlignmentRight;
        date_label.textColor=[UIColor grayColor];
        date_label.backgroundColor=[UIColor clearColor];
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

-(void)prepareData:(NSMutableDictionary *)item{
    author_label.text=[item objectForKey:@"author"];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    date_label.text=[item objectForKey:@"reg_date"];
    contents_label.text=[item objectForKey:@"contents_original"];
    CGRect frame = contents_label.frame;
    frame.size.height = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
    contents_label.frame=frame;
    
    NSString *url=[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"author_picture"]];
    [profileView setImageURL:[NSURL URLWithString:url]];
    //    bgView.frame=CGRectMake(0, 0, 320, contents_label.frame.size.height+50);
    
}

+(CGFloat)calculateHeight:(NSMutableDictionary *)item{
    CGSize suggestedSize = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
    [item setValue:[NSNumber numberWithFloat:suggestedSize.height+50] forKey:@"height"];
    return MAX(suggestedSize.height+20, 60.0f);
}
@end
