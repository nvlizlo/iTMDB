//
//  DetailViewController.m
//  iTMDB
//
//  Created by Nazariy Vlizlo on 23.02.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import "DetailViewController.h"
#import "MoviesViewController.h"
#import "MovieStore.h"

NSString *apIkey = @"84d1fc29ee4c082d407b59ba9c7ccc3e";

@interface DetailViewController ()



@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[MovieStore sharedStore] requestForTypeOfMovies:nil viewController:self];
}

@end
