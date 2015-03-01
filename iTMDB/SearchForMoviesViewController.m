//
//  SearchForMoviesViewController.m
//  iTMDB
//
//  Created by Nazariy Vlizlo on 22.02.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import "SearchForMoviesViewController.h"
#import "MovieTableViewCell.h"
#import "DetailViewController.h"
#import "MovieStore.h"

NSString *apikey = @"84d1fc29ee4c082d407b59ba9c7ccc3e";

@interface SearchForMoviesViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,
 UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *movies;
@property (copy, nonatomic) NSMutableArray *images;

@end

@implementation SearchForMoviesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (MovieTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
    cell.textLabel.text = self.movies[indexPath.row][@"original_title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Release Date: %@", self.movies[indexPath.row][@"release_date"]];
    cell.imageView.image = self.images[indexPath.row];
    cell.movieId = [NSString stringWithFormat:@"%@", self.movies[indexPath.row][@"id"]];
    return cell;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.movies = nil;
    self.images = nil;
    [[MovieStore sharedStore] requestForTypeOfMovies:searchBar.text viewController:self];
    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FromSearch"]) {
        MovieTableViewCell *cell = sender;
        DetailViewController *detail = (DetailViewController *)segue.destinationViewController;
        detail.movieId = cell.movieId.integerValue;
    }
}

@end
