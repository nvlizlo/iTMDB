//
//  TabBarControllerViewController.m
//  iTMDB
//
//  Created by Nazariy Vlizlo on 21.02.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import "TabBarViewController.h"
#import "MoviesViewController.h"

@interface TabBarControllerViewController () <UITabBarControllerDelegate>

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *icons;

@end

@implementation TabBarControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.titles = @[@"Top", @"Popular", @"Upcoming"];
    self.icons = @[[UIImage imageNamed:@"top"], [UIImage imageNamed:@"popular"],[UIImage imageNamed:@"upcoming"]];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    for (int i = 0; i <self.titles.count; i++)
    {
        [self.tabBar.items[i] setTitle:self.titles[i]];
        [self.tabBar.items[i] setImage:self.icons[i]];
    }
    
}

@end
