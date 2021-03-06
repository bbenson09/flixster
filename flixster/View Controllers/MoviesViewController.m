//
//  MoviesViewController.m
//  flixster
//
//  Created by Bevin Benson on 6/27/18.
//  Copyright © 2018 Bevin Benson. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "Movie.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *filteredData;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self fetchMovies];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    
}

- (void)fetchMovies {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                            message:@"The internet connection appears to be offline"
                                                     preferredStyle:(UIAlertControllerStyleAlert)];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self fetchMovies];
            }];
            [alert addAction:tryAgainAction];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            /*
            self.movies = dataDictionary[@"results"];
            
            for (NSDictionary *movie in self.movies) {
                NSLog(@"%@", movie[@"title"]);
            }
             */
            
            NSArray *dictionaries = dataDictionary[@"results"];
            self.movies = [Movie moviesWithDictionary:dictionaries];
            
            // self.filteredData = self.movies;
            self.filteredData = self.movies;
            [self.tableView reloadData];
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }
        [self.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    [task resume];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    cell.movie = self.movies[indexPath.row];
    
    // Removed for encapsulation
    /*
    cell.titleLabel.text = movie[@"title"];
    cell.synopsis.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
     */
    
    // [cell.posterView setImageWithURL:posterURL];
    
    // cell.textLabel.text = movie[@"title"];
    
    return cell;
    
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            
            // we don't have the indexPath variable here...
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        
        NSArray *filteredDataArray = [self.movies filteredArrayUsingPredicate:predicate];
        self.filteredData = [NSMutableArray arrayWithArray:filteredDataArray];
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.tableView reloadData];
    // NSLog(@"Table should have reloaded");
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Movie *movie = self.filteredData[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
