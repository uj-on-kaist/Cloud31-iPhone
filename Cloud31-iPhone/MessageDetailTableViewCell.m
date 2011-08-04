//
//  MessageDetailTableViewCell.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 31..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "MessageDetailTableViewCell.h"
#import "UserPictureContainer.h"

@implementation MessageDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        profileView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"default.png"]];
        profileView.contentMode = UIViewContentModeScaleToFill;
        profileView.frame = CGRectMake(5, 5, 45, 45);
        [self addSubview:profileView];
        
        
        author_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 3, 150, 20)];
        //author_label.text=@"author";
        author_label.userInteractionEnabled=NO;
        author_label.font=[UIFont systemFontOfSize:14.0f];
        author_label.textColor=[UIColor blackColor];
        author_label.backgroundColor=[UIColor clearColor];
        author_label.shadowColor=RGBA2(250, 250, 250,0.3);
        author_label.shadowOffset=CGSizeMake(0, -1);
        [self addSubview:author_label];
        
        contents_bg = [[TTView alloc] initWithFrame:CGRectMake(57, 20, 150, 0)];
        contents_bg.backgroundColor=[UIColor clearColor];
        
        [self addSubview:contents_bg];
        
        contents_label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(67, 34, 150, 0)];
        //contents_label.numberOfLines=0;
        //contents_label.text=@"author";
        contents_label.font=[UIFont systemFontOfSize:14.0f];
        //contents_label.lineBreakMode=UILineBreakModeWordWrap;
        contents_label.backgroundColor=[UIColor clearColor];
        contents_label.userInteractionEnabled=NO;
        [self addSubview:contents_label];
        
        date_label = [[UILabel alloc] initWithFrame:CGRectMake(57, 5, 100, 15)];
        date_label.text=@"date";
        date_label.textAlignment=UITextAlignmentLeft;
        date_label.textColor=[UIColor whiteColor];
        date_label.backgroundColor=[UIColor clearColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];
    
        
        [self addSubview:date_label];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        profile_frame =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_frame.png"]];
        profile_frame.frame = CGRectMake(4, 4, 48, 46);
        profile_frame.backgroundColor=[UIColor clearColor];
        [self addSubview:profile_frame];
        
        smallFix = [[UIView alloc] initWithFrame:CGRectMake(5, 49, 1, 1)];
        smallFix.backgroundColor=self.superview.backgroundColor;
        [self addSubview:smallFix];
        
    }
    return self;
}

-(void)prepareData:(NSMutableDictionary *)item{
    if([[item objectForKey:@"author_yn"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        profileView.hidden=YES;
        profile_frame.hidden=YES;
        smallFix.hidden=YES;
    }else{
        profileView.hidden=NO;
        profile_frame.hidden=NO;
        smallFix.hidden=NO;
        profileView.frame=CGRectMake(5, 5, 45, 45);
        profile_frame.frame = CGRectMake(4, 4, 48, 46);
        smallFix.frame = CGRectMake(5, 49, 1, 1);
    }
    
    
    NSString *url=[NSString stringWithFormat:@"%@%@",ServiceURL,[item objectForKey:@"author_picture"]];
    UIImage *cached=[[UserPictureContainer sharedContainer] getUserImage:url];
    if(cached == nil){
        [profileView setImageURL:[NSURL URLWithString:url]];
    }else{
        [profileView setImage:cached];
    }
        
    //author_label.text=[item objectForKey:@"author"];
    NSString *author_html =[NSString stringWithFormat:@"%@ (%@)",[item objectForKey:@"author_name"],[item objectForKey:@"author"]];
    author_label.text=author_html;
    [author_label sizeToFit];
    
    date_label.text=[NSString stringWithFormat:@"%@",[item objectForKey:@"reg_date"]];
    
    TTStyledText* styledText = [TTStyledText textFromXHTML:[item objectForKey:@"contents"] lineBreaks:YES URLs:NO];
    contents_label.text=styledText;
    //contents_label.text=[item objectForKey:@"contents"];
    contents_label.font=[UIFont systemFontOfSize:14.0f];
    contents_label.frame=CGRectMake(67, 34, 150, 0);
    [contents_label sizeToFit];
    
    CGFloat maxWidth = 0;
    TTStyledFrame *f = contents_label.text.rootFrame;
    while (f) {
        int w = f.x + f.width;
        if (w > maxWidth) {
            maxWidth = w;
        }
        f = f.nextFrame;
    }
    CGRect frame = contents_label.frame;
    frame.size.width=maxWidth;
    contents_label.frame=frame;
    contents_bg.frame=CGRectMake(57, 22, contents_label.frame.size.width+20, contents_label.frame.size.height+15);
    
    
    
    frame = date_label.frame;
    frame.origin.y = contents_label.frame.origin.y + contents_label.frame.size.height-16;
    date_label.frame= frame;
    [date_label sizeToFit];
    
    
    if([[item objectForKey:@"author_yn"] isEqualToNumber:[NSNumber numberWithInt:1]]){
        frame = author_label.frame;
        frame.origin.x = self.frame.size.width-10-author_label.frame.size.width;
        author_label.frame=frame;
        
        frame = contents_label.frame;
        frame.origin.x = self.frame.size.width-20-contents_label.frame.size.width;
        contents_label.frame=frame;
        contents_bg.frame=CGRectMake(self.frame.size.width-20-contents_label.frame.size.width-10, 22, contents_label.frame.size.width+20, contents_label.frame.size.height+15);
        
        contents_bg.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:5.0f pointLocation:110
                                                                                 pointAngle:90
                                                                                  pointSize:CGSizeMake(15,8)] next:
                           [TTSolidFillStyle styleWithColor:RGB2(249, 243, 96) next:nil]];

        
        frame = date_label.frame;
        frame.origin.x = self.frame.size.width-20-contents_label.frame.size.width - date_label.frame.size.width - 15;
        date_label.frame=frame;
    }else{
        frame = author_label.frame;
        frame.origin.x = 57;
        author_label.frame=frame;
        
        frame = contents_label.frame;
        frame.origin.x = 67;
        contents_label.frame=frame;
        contents_bg.frame=CGRectMake(57, 22, contents_label.frame.size.width+20, contents_label.frame.size.height+15);
        
        contents_bg.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:5.0f pointLocation:65
                                                                                 pointAngle:90
                                                                                  pointSize:CGSizeMake(15,8)] next:
                           [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:nil]];

        
        
        frame = date_label.frame;
        frame.origin.x = contents_label.frame.size.width+80;
        date_label.frame=frame;
    }
}


- (void)dealloc
{
    [super dealloc];
}

+(CGFloat)calculateHeight:(NSMutableDictionary *)item{
    /*
     CGSize suggestedSize = [[item objectForKey:@"contents_original"] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
     [item setValue:[NSNumber numberWithFloat:suggestedSize.height+50] forKey:@"height"];
     return MAX(suggestedSize.height+60.0f, 60.0f);
     */
    TTStyledTextLabel *temp = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(57, 5, 150, 0)];
    temp.font=[UIFont systemFontOfSize:14.0f];
    temp.backgroundColor=[UIColor clearColor];
    TTStyledText* styledText = [TTStyledText textFromXHTML:[item objectForKey:@"contents"] lineBreaks:YES URLs:YES];
    temp.text=styledText;
    temp.font=[UIFont systemFontOfSize:14.0f];
    temp.userInteractionEnabled=YES;
    [temp sizeToFit];
    
    return MAX(temp.frame.size.height+45.0f, 60.0f);
}

@end
