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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    [self requestForNameOfMovies:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

- (void)requestForNameOfMovies:(NSString *)name {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/search/movie?api_key=%@&query=%@", apikey, name]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setHTTPMethod:@"GET"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSDictionary *d = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&error];
                                      if (error) {
                                          NSLog(@"%@", error.description);
                                          return;
                                      }
                                      self.movies = d[@"results"];
                                      [self cycleForImages:self.movies];
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self.tableView reloadData];
                                      });
                                      
                                  }];
    [task resume];
    
}

- (void)cycleForImages:(NSArray *)array {
    NSMutableArray *mutable = [[NSMutableArray alloc] init];
    for (NSDictionary *d in array)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w92%@", d[@"poster_path"]]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image != nil) {
            [mutable addObject:image];
        } else {
            [mutable addObject:[UIImage imageNamed:@"question_mark"]];
        }
    }
    self.images = mutable;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FromSearch"]) {
        MovieTableViewCell *cell = sender;
        DetailViewController *detail = (DetailViewController *)segue.destinationViewController;
        detail.movieId = cell.movieId.integerValue;
    }
}

@end
