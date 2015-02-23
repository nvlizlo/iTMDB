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

NSString *apiKey = @"84d1fc29ee4c082d407b59ba9c7ccc3e";

@interface MoviesViewController ()

@property (nonatomic, copy) NSArray *movies;
@property (nonatomic, copy) NSArray *images;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MoviesViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if ([self.tabBarItem.title isEqualToString:@"Top"]) {
        [self requestForTypeOfMovies:@"top_rated"];
    }
    else if ([self.tabBarItem.title isEqualToString:@"Popular"]) {
        [self requestForTypeOfMovies:@"popular"];
    }
    else if ([self.tabBarItem.title isEqualToString:@"Upcoming"]) {
        [self requestForTypeOfMovies:@"upcoming"];
    }
    
}

- (void)requestForTypeOfMovies:(NSString *)type {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%@?api_key=%@", type, apiKey]];
    
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
    self.images = [[NSArray alloc] initWithArray:mutable];
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
