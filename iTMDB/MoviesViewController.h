//
//  MoviesViewController.h
//  iTMDB
//
//  Created by Nazariy Vlizlo on 21.02.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSArray *movies;
@property (nonatomic, copy) NSArray *images;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
