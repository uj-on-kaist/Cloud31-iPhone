//
//  CommentInfoView.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 19..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "CommentInfoView.h"


@implementation CommentInfoView

@synthesize label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        favorite = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Favorite-Off.png"]];
        favorite.frame=CGRectMake(self.frame.size.width-62, 1, 20, 20);
        [self addSubview:favorite];
        
        UIImageView *bubble = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Chat.png"]];
        bubble.frame=CGRectMake(self.frame.size.width-40, 0, 20, 20);
        [self addSubview:bubble];
        
        label= [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-18, 0, 20, 20)];
        label.text=@"";
        label.backgroundColor=[UIColor clearColor];
        label.font=[UIFont boldSystemFontOfSize:12.0f];
        label.textColor=[UIColor darkGrayColor];
        [self addSubview:label];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [super dealloc];
}


-(void)setStarOn{
    favorite.image=[UIImage imageNamed:@"Favorite.png"];
}
-(void)setStarOff{
    favorite.image=[UIImage imageNamed:@"Favorite-Off.png"];
}
-(void)setCommentCount:(int)count{
    label.text=[NSString stringWithFormat:@"%d",count];
}
/*
-(void)setAttachInfo:(NSArray *)file_list withLocation:(BOOL)has_location{
    for(int i=0; i<[attach_view_arr count]; i++){
        UIImageView *view = (UIImageView *)[attach_view_arr objectAtIndex:i];
        view.hidden=YES;
    }
    
    int start_index=0;
    if(has_location){
        UIImageView *view = (UIImageView *)[attach_view_arr objectAtIndex:0];
        [view setImage:[UIImage imageNamed:@"File_icon_gps.png"]];
        view.hidden=NO;
        start_index=1;
    }
    
    NSMutableArray *new_file_list=[[NSMutableArray alloc] init];
    NSMutableArray *types=[[NSMutableArray alloc] init];
    for(int i=0; i<[file_list count]; i++){
        NSDictionary *item =[file_list objectAtIndex:i];
        BOOL already=NO;
        for(int j=0; j<[types count];j++){
            if([[item objectForKey:@"type"] isEqualToString:[types objectAtIndex:j]]){
                already=YES;
            }
        }
        if(!already){
            [new_file_list addObject:item];
            [types addObject:[item objectForKey:@"type"]];
        }else{
        }
        
    }
    
    for(int i=start_index; (i-start_index)<[new_file_list count] && i<[attach_view_arr count]; i++){
        NSDictionary *item =[new_file_list objectAtIndex:(i-start_index)];
        UIImageView *view = (UIImageView *)[attach_view_arr objectAtIndex:i];
        view.hidden=NO;
        [view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"File_icon_%@.png",[item objectForKey:@"type"]]]];
    }

}
 */

@end
