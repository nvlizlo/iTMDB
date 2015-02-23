//
//  DetailViewController.m
//  iTMDB
//
//  Created by Nazariy Vlizlo on 23.02.15.
//  Copyright (c) 2015 Nazariy Vlizlo. All rights reserved.
//

#import "DetailViewController.h"
#import "MoviesViewController.h"

NSString *apIkey = @"84d1fc29ee4c082d407b59ba9c7ccc3e";

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *moviePicture;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *genreAndDate;
@property (weak, nonatomic) IBOutlet UILabel *popularityAndBudget;
@property (weak, nonatomic) IBOutlet UITextView *movieDescription;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation DetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureTopBar];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.themoviedb.org/3/movie/%ld?api_key=%@",
                                       (long)self.movieId, apIkey]];
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
                                      NSData *imageData = [NSData dataWithContentsOfURL:
                                                           [NSURL URLWithString:
                                                            [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w500%@",
                                                             d[@"backdrop_path"]]]];
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          self.movieDescription.text = d[@"overview"];
                                          self.movieName.text = d[@"original_title"];
                                          self.genreAndDate.text = [NSString stringWithFormat:@"Genre: %@\nRelease Date: %@",
                                                                    d[@"genres"][0][@"name"], d[@"release_date"]];
                                          self.popularityAndBudget.text = [NSString stringWithFormat:@"Popularity: %@\nBudget: %@ $",
                                                                      d[@"popularity"], d[@"budget"]];
                                          if (imageData != nil) {
                                              self.moviePicture.image = [UIImage imageWithData:imageData];
                                          } else {
                                              self.moviePicture.image = [UIImage imageNamed:@"question_mark"];
                                          }
                                      });
                                      
                                  }];
    [task resume];

}

- (void)configureTopBar {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = self.view.backgroundColor;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"< back" style: UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
