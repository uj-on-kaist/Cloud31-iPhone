//
//  SearchViewController.h
//  Cloud31-iPhone
//
//  Created by 정의준 on 11. 7. 22..
//  Copyright 2011 KAIST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>{
    NSMutableArray *items;
    NSMutableArray *searchItems;
    NSInteger search_mode;
        
    
    BOOL _loading_popular_topic;
}

@end
