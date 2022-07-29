//
//  DHBrowser.h
//  Dash iOS
//
//  Created by chenhaoyu.1999 on 2021/3/29.
//  Copyright © 2021 Kapeli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DHWebViewController.h"
#import "DHBrowserTableViewCell.h"
#import "DHBrowserTableView.h"

NS_ASSUME_NONNULL_BEGIN
@class DHDBSearchController;

@interface DHBrowser : UITableViewController
@property (strong) DHDBSearchController *dbSearchController;
@property (strong) UISearchController *searchController;
@property (strong) UITableView *searchResultTableView;
@end

NS_ASSUME_NONNULL_END
