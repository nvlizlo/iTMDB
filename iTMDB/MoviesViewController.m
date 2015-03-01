//
//  MoviesViewController.m
//  iTMDB
//
//  Created by Nazariy Vlizlo on 21.02.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "DetailViewController.h"
#import "MovieStore.h"

@interface MoviesViewController ()

@property (nonatomic , copy) NSString *type;
@property (nonatomic, strong) MovieStore *store;

@end

@implementation MoviesViewController

- (MovieStore *)store {
    if (!_store) {
        _store = [[MovieStore alloc] init];
    }
    return _store;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([self.tabBarItem.title isEqualToString:@"Top"]) {
        self.type = @"top_rated";
    } else if ([self.tabBarItem.title isEqualToString:@"Popular"]) {
        self.type = @"popular";
    } else if ([self.tabBarItem.title isEqualToString:@"Upcoming"]) {
        self.type = @"upcoming";
    }
    [[MovieStore sharedStore] requestForTypeOfMovies:self.type viewController:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (MovieTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoviesCell"];
    cell.textLabel.text = self.movies[indexPath.row][@"original_title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Release date: %@", self.movies[indexPath.row][@"release_date"]];
    cell.imageView.image = self.images[indexPath.row];
    cell.movieId = [NSString stringWithFormat:@"%@", self.movies[indexPath.row][@"id"]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FromMovies"]) {
        MovieTableViewCell *cell = sender;
        DetailViewController *detail = (DetailViewController *)segue.destinationViewController;
        detail.movieId = cell.movieId.integerValue;
    }
}

@end
