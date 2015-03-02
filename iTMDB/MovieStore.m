//
//  MovieStore.m
//  iTMDB
//
//  Created by Nazariy Vlizlo on 01.03.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import "MovieStore.h"
#import "MoviesViewController.h"
#import "SearchForMoviesViewController.h"
#import "DetailViewController.h"

NSString *listOfMoviesURL = @"http://api.themoviedb.org/3/movie/%@?api_key=%@";
NSString *searchURL = @"http://api.themoviedb.org/3/search/movie?api_key=%@&query=%@";
NSString *detailURL = @"http://api.themoviedb.org/3/movie/%ld?api_key=%@";
NSString *APIKEY = @"84d1fc29ee4c082d407b59ba9c7ccc3e";
@interface MovieStore ()

@property (nonatomic, copy) NSArray *movies;
@property (nonatomic, copy) NSURL *url;

@end

@implementation MovieStore

- (NSInteger)moviesCount {
    return self.movies.count;
}

- (id)init {
    self = [super init];
    return self;
}

+ (instancetype)sharedStore
{
    static dispatch_once_t onceToken;
    static id _instance;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    
    return _instance;
}

- (void)requestForTypeOfMovies:(NSString *)type viewController:(id)controller {
    NSURL *URL = [self chooseUrlFromController:controller forType:type];
    
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
                                      if ([controller isKindOfClass:[DetailViewController class]]) {
                                          [self fillDetailInfo:controller withDictionary:d];
                                        
                                      } else {
                                          [controller setMovies: d[@"results"]];
                                      [self cycleForImages:[controller movies] viewController:controller];
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [[controller tableView] reloadData];
                                      });
                                      }
                                  }];
                                  
    [task resume];
}

- (void)cycleForImages:(NSArray *)array viewController:(MoviesViewController *)controller {
    NSMutableArray *mutable = [[NSMutableArray alloc] init];
    for (NSDictionary *d in array) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://image.tmdb.org/t/p/w92%@", d[@"poster_path"]]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image != nil) {
            [mutable addObject:image];
        } else {
            [mutable addObject:[UIImage imageNamed:@"question_mark"]];
        }
    }
    controller.images = [mutable copy];
}

- (void)fillDetailInfo:(id)controller withDictionary:(NSDictionary *)d {
    NSData *imageData = [NSData dataWithContentsOfURL:
                         [NSURL URLWithString:
                          [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@",
                           d[@"backdrop_path"]]]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [controller movieDescription].text = d[@"overview"];
        [controller movieName].text = d[@"original_title"];
        if ([d[@"genres"] count]) {
            [controller genreAndDate].text = [NSString stringWithFormat:@"Genre: %@\nRelease Date: %@",
                                              d[@"genres"][0][@"name"], d[@"release_date"]];
        } else {
            [controller genreAndDate].text = [NSString stringWithFormat:@"Genre: %@\nRelease Date: %@",
                                              @"none", d[@"release_date"]];
        }
        [controller popularityAndBudget].text = [NSString stringWithFormat:@"Popularity: %@\nBudget: %@ $",
                                                 d[@"popularity"], d[@"budget"]];
        if (imageData != nil) {
            [controller moviePicture].image = [UIImage imageWithData:imageData];
        } else {
            [controller moviePicture].image = [UIImage imageNamed:@"question_mark"];
        }
    });

}

- (NSURL *)chooseUrlFromController:(id)controller forType:(NSString *)type {
    if ([controller isKindOfClass:[MoviesViewController class]]) {
        return [NSURL URLWithString:[NSString stringWithFormat:listOfMoviesURL, type, APIKEY]];
    } else if ([controller isKindOfClass:[SearchForMoviesViewController class]]) {
        return [NSURL URLWithString:[NSString stringWithFormat:searchURL, APIKEY, type]];
    } else {
        return [NSURL URLWithString:[NSString stringWithFormat:detailURL, (long)[controller movieId], APIKEY]];
    }
}

@end
