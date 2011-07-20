//
//  FeedDetailViewController.m
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 20..
//  Copyright 2011 KAIST. All rights reserved.
//

#import "FeedDetailViewController.h"
#import "UserProfileSmallView.h"

#import "Cloud31_iPhoneAppDelegate.h"

#import "CommentTableViewCell.h"

@implementation FeedDetailViewController

@synthesize item;

-(id)initWithItem:(NSMutableDictionary *)aItem{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 417)];
    if (self) {
        // Custom initialization
        self.item= aItem;
        self.title=[item objectForKey:@"contents_original"];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(more_action)];
        CGRect frame= _tableView.frame;
        frame.size.height-=44;
        _tableView.frame=frame;
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        TTNavigator *navigator = [TTNavigator navigator];
        navigator.persistenceMode = TTNavigatorPersistenceModeNone;
        navigator.delegate = self;
        
        NSString *contents=[[item objectForKey:@"contents"] stringByReplacingOccurrencesOfString:@"target=_blank" withString:@""];
        contents_label = [[TTStyledTextLabel alloc] initWithFrame:CGRectMake(10, 20, 300, 44)];
        TTStyledText* styledText = [TTStyledText textFromXHTML:contents lineBreaks:YES URLs:YES];
        contents_label.text=styledText;
        contents_label.userInteractionEnabled=YES;
        [contents_label sizeToFit];
        
        
        
        
        UserProfileSmallView *profileView = [[UserProfileSmallView alloc] init];
        
        [profileView.picture setImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ServiceURL, [item objectForKey:@"author_picture"]]]];
        profileView.name.text=[item objectForKey:@"author_name"];
        profileView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        profileView.userID.text=[NSString stringWithFormat:@"@%@",[item objectForKey:@"author"]];
        
        profileView.userDept.text=[NSString stringWithFormat:@"%@ %@",[item objectForKey:@"author_dept"], [item objectForKey:@"author_position"]];
        
        TTView *contents_bg = [[TTView alloc] initWithFrame:CGRectMake(0, 69, 320, contents_label.frame.size.height+60)];
        [contents_bg addSubview:contents_label];
        contents_bg.backgroundColor=[UIColor groupTableViewBackgroundColor];
        contents_bg.style=[TTShapeStyle styleWithShape:[TTSpeechBubbleShape shapeWithRadius:0 pointLocation:56
                                                                                 pointAngle:90
                                                                                  pointSize:CGSizeMake(15,6)] next:
                           [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:nil]];

        UILabel *date_label = [[UILabel alloc] initWithFrame:CGRectMake(10, contents_label.frame.size.height+35, 280, 15)];
        date_label.text=[NSString stringWithFormat:@"%@ | %@",[item objectForKey:@"pretty_date"],[item objectForKey:@"reg_date"]];
        date_label.textColor=[UIColor grayColor];
        date_label.backgroundColor=[UIColor clearColor];
        date_label.font=[UIFont systemFontOfSize:12.0f];
        [contents_bg addSubview:date_label];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, contents_bg.frame.origin.y+contents_bg.frame.size.height)];
        headerView.userInteractionEnabled=YES;
        headerView.backgroundColor=[UIColor groupTableViewBackgroundColor];

        [headerView addSubview:profileView];
        [headerView addSubview:contents_bg];

        [_tableView setTableHeaderView:headerView];
        
        [super loadData];
        
        NSArray *_comments = [item objectForKey:@"comments"];
        comments=[[NSMutableArray alloc] init];
        for(NSDictionary *_item in _comments){
            [comments addObject:[NSMutableDictionary dictionaryWithDictionary:_item]];
        }
        
        
        UIButton *commentPostView = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"comment_off.png"] forState:UIControlStateNormal];
        [commentPostView setBackgroundImage:[UIImage imageNamed:@"comment_on.png"] forState:UIControlStateHighlighted];
        [commentPostView addTarget:self action:@selector(comment_post) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:commentPostView];
    }
    return self;
}

-(void)comment_post{
    TTPostController *postController=[[TTPostController alloc] init];
    [postController showInView:self.view animated:YES];
    postController.delegate=self;
}

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result{
    NSLog(@"%@",text);
}

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 417)];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)more_action{
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Comments";
    
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSMutableDictionary *_comment_item = [comments objectAtIndex:indexPath.row];
    [cell prepareData:_comment_item];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *_comment_item = [comments objectAtIndex:indexPath.row];
    return [CommentTableViewCell calculateHeight:_comment_item];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelected:NO animated:NO];

}

- (NSURL*)navigator:(TTBaseNavigator*)navigator URLToOpen:(NSURL*)URL{
    NSLog(@"%@",[URL absoluteURL]);
    if([[URL absoluteString] rangeOfString:@"http:///"].location == NSNotFound){
        TTWebController *webController=[[TTWebController alloc]init];
        [webController openURL:URL];
        
        Cloud31_iPhoneAppDelegate *app_delegate = (Cloud31_iPhoneAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app_delegate.navigationController pushViewController:webController animated:YES];
    }else{
        NSString *path = [URL relativePath];
        NSArray *array = [path componentsSeparatedByString:@"/"];
        
        NSString *gate=[array objectAtIndex:1];
        NSString *query=[array objectAtIndex:2];
        
        NSLog(@"%@ : %@",gate, query);
    }
    return NULL;
}

@end
