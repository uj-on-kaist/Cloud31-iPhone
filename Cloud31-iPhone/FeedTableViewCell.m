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
        
        bubbleView = [[TTView alloc] initWithFrame:CGRectMake(57, 0, 180, 26)];
        bubbleView.backgroundColor=[UIColor whiteColor];
        /*
        bubbleView.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:3 pointLocation:55
                                                                                pointAngle:90
                                                                                 pointSize:CGSizeMake(12,5)] next:
                          [TTSolidFillStyle styleWithColor:RGB2(255, 250,225) next:[TTSolidBorderStyle styleWithColor:RGB2(255,243 ,182 ) width:1 next:nil]]];
        */
        bubbleView.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:3 pointLocation:55
                                                                                pointAngle:90
                                                                                 pointSize:CGSizeMake(12,5)] next:
                          [TTSolidFillStyle styleWithColor:RGB2(230, 240,250) next:nil]];
        [self addSubview:bubbleView];
        
        
        profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]];
        profileView.contentMode = UIViewContentModeScaleToFill;
        profileView.frame = CGRectMake(5, 5, 45, 45);
        [self addSubview:profileView];
        
        
        author_label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(57, 3, 160, 20)];
        //author_label.text=@"author";
        author_label.userInteractionEnabled=NO;
        author_label.font=[UIFont systemFontOfSize:14.0f];
        author_label.textColor=RGB2(52,52,52);
        author_label.backgroundColor=[UIColor clearColor];
        author_label.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:author_label];
        
        contents_label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(57, 23, 250, 0)];
        //contents_label.numberOfLines=0;
        //contents_label.text=@"author";
        contents_label.font=[UIFont systemFontOfSize:14.0f];
        //contents_label.lineBreakMode=UILineBreakModeWordWrap;
        contents_label.backgroundColor=[UIColor clearColor];
        contents_label.userInteractionEnabled=NO;
        contents_label.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:contents_label];
        
        date_label = [[UILabel alloc] initWithFrame:CGRectMake(62, 5, 100, 15)];
        date_label.text=@"date";
        date_label.textAlignment=UITextAlignmentLeft;
        date_label.textColor=[UIColor grayColor];
        date_label.backgroundColor=[UIColor clearColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];

        
        [self addSubview:date_label];
        
        comment_label = [[UILabel alloc] initWithFrame:CGRectMake(62, 5, 100, 15)];
        comment_label.text=@"";
        comment_label.textAlignment=UITextAlignmentLeft;
        comment_label.textColor=date_label.textColor;
        comment_label.backgroundColor=[UIColor clearColor];
        comment_label.font=[UIFont systemFontOfSize:12.0f];
        [self addSubview:comment_label];
        
        favorite_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Favorite.png"]];
        favorite_image.frame=CGRectMake(62, 5, 22, 22);
        favorite_image.backgroundColor=[UIColor clearColor];
        [self addSubview:favorite_image];
        
        favorite_off_image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Favorite-Off.png"]];
        favorite_off_image.frame=CGRectMake(62, 5, 22, 22);
        favorite_off_image.backgroundColor=[UIColor clearColor];
        [self addSubview:favorite_off_image];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UIImageView *profile_frame =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_frame.png"]];
        profile_frame.frame = CGRectMake(4, 4, 48, 46);
        profile_frame.backgroundColor=[UIColor clearColor];
        [self addSubview:profile_frame];
        
        UIView *smallFix = [[UIView alloc] initWithFrame:CGRectMake(5, 49, 1, 1)];
        smallFix.backgroundColor=[UIColor whiteColor];
        [self addSubview:smallFix];
        

        attachFileView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"attach.png"]];
        attachFileView.frame=CGRectMake(self.frame.size.width-57, 3, 18, 18);
        attachFileView.hidden=YES;
        attachFileView.autoresizingMask=UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:attachFileView];
        
        attachImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"File_icon_img.png"]];
        attachImageView.frame=CGRectMake(self.frame.size.width-38, 2, 20, 20);
        attachImageView.hidden=YES;
        attachImageView.autoresizingMask=UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:attachImageView];
        
        attachGPSView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"File_icon_gps.png"]];
        attachGPSView.frame=CGRectMake(self.frame.size.width-20, 2, 20, 20);
        attachGPSView.hidden=YES;
        attachGPSView.autoresizingMask=UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:attachGPSView];
        
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
    
    
    NSString *url=[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"author_picture"]];
    UIImage *cached=[[UserPictureContainer sharedContainer] getUserImage:url];
    if(cached == nil){
        [profileView setImageURL:[NSURL URLWithString:url]];
    }else{
        [profileView setImage:cached];
    }
    
    
    
    //author_label.text=[item objectForKey:@"author"];
    NSString *author_html =[NSString stringWithFormat:@"<a>%@</a> %@",[item objectForKey:@"author"],[item objectForKey:@"author_name"]];
    TTStyledText *text = [TTStyledText textFromXHTML:author_html lineBreaks:NO URLs:NO];
    author_label.text=text;
    
    
    date_label.text=[NSString stringWithFormat:@"%@  |",[item objectForKey:@"pretty_date"]];
//    contents_label.text=[item objectForKey:@"contents_original"];
//    CGRect frame = contents_label.frame;
//    frame.size.height = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
//    contents_label.frame=frame;
    
    CGRect contents_label_frame=CGRectMake(57, 23, 250, 0);
    UIDeviceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight ){
        contents_label_frame.size.width=410;
    }
    contents_label.frame= contents_label_frame;
    TTStyledText* styledText = [TTStyledText textFromXHTML:[item objectForKey:@"contents"] lineBreaks:YES URLs:NO];
    contents_label.text=styledText;
    contents_label.font=[UIFont systemFontOfSize:14.0f];
    contents_label.userInteractionEnabled=NO;
    [contents_label sizeToFit];
    
    
    CGRect frame = date_label.frame;
    frame.origin.x = 62;
    frame.origin.y = contents_label.frame.origin.y + contents_label.frame.size.height+12;
    CGSize suggestedSize= [date_label.text sizeWithFont:date_label.font constrainedToSize:CGSizeMake(100, 15) lineBreakMode:UILineBreakModeWordWrap];
    frame.size.width=suggestedSize.width;
    date_label.frame= frame;
    
    comment_label.text=[NSString stringWithFormat:@"|  %d comments", [[item objectForKey:@"comments"] count]];
    [comment_label sizeToFit];
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
    
    frame = bubbleView.frame;
    frame.origin.y=date_label.frame.origin.y-8;
    frame.size.width=comment_label.frame.origin.x+comment_label.frame.size.width-50;
    bubbleView.frame=frame;
    
    
    attachGPSView.hidden=YES;
    attachFileView.hidden=YES;
    attachImageView.hidden=YES;
    
    CGFloat gpsOffset = 0;
    if([item objectForKey:@"lat"] != nil && [item objectForKey:@"lng"] != nil){
        attachGPSView.hidden=NO;
        attachGPSView.frame=CGRectMake(self.frame.size.width-20, 2, 20, 20);
        gpsOffset=20;
    }
    
    BOOL has_attach_file = NO;
    BOOL has_attach_img = NO;
    for(NSDictionary *file in [item objectForKey:@"file_list"]){
        if([[file objectForKey:@"type"] isEqualToString:@"img"]){
            has_attach_img=YES;
        }else{
            has_attach_file=YES;
        }
    }
    
    if(has_attach_img && has_attach_file){
        attachFileView.hidden=NO;
        attachFileView.frame=CGRectMake(self.frame.size.width-38-gpsOffset, 3, 18, 18);
        attachImageView.hidden=NO;
        attachImageView.frame=CGRectMake(self.frame.size.width-20-gpsOffset, 2, 20, 20);
    }else if(has_attach_img){
        attachImageView.hidden=NO;
        attachImageView.frame=CGRectMake(self.frame.size.width-20-gpsOffset, 2, 20, 20);
    }else if(has_attach_file){
        attachFileView.hidden=NO;
        attachFileView.frame=CGRectMake(self.frame.size.width-18-gpsOffset, 3, 18, 18);
    }
    
}

+(CGFloat)calculateHeight:(NSMutableDictionary *)item{
    CGRect frame=CGRectMake(57, 23, 250, 0);
    UIDeviceOrientation deviceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if(deviceOrientation == UIDeviceOrientationLandscapeLeft || deviceOrientation == UIDeviceOrientationLandscapeRight ){
        frame.size.width=410;
    }
    TTStyledTextLabel *temp = [[TTStyledTextLabel alloc] initWithFrame:frame];
    temp.font=[UIFont systemFontOfSize:14.0f];
    temp.backgroundColor=[UIColor clearColor];
    TTStyledText* styledText = [TTStyledText textFromXHTML:[item objectForKey:@"contents"] lineBreaks:YES URLs:YES];
    temp.text=styledText;
    temp.font=[UIFont systemFontOfSize:14.0f];
    temp.userInteractionEnabled=YES;
    [temp sizeToFit];
    
    return MAX(temp.frame.size.height+60.0f, 60.0f);
}

@end
