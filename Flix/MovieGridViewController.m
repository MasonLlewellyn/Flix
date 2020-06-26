//
//  MovieGridViewController.m
//  Flix
//
//  Created by Mason Llewellyn on 6/26/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import "MovieGridViewController.h"
#import "MovieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MovieGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self fetchMovies];
    
}

- (void)fetchMovies{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: [NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //[self.activityIndicator startAnimating];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse * response, NSError *error){
        //[self.activityIndicator stopAnimating];
        
        if (error != nil){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error" message: [error localizedDescription] preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //TODO: Replace this recursion with something better because we could quickly have a stack overflow
                [self fetchMovies];
            }];
            
            [alert addAction: tryAgainAction];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
        else{
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:nil];
            
            //Load movies into variable
            self.movies = dataDictionary[@"results"];
            //NSLog(@"%@", dataDictionary);
            
            [self.collectionView reloadData];
        }
        //[self.refreshControl endRefreshing];
    }];
    [task resume];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = movie[@"poster_path"];
    if (posterURL){
        NSString *fullURL = [baseURL stringByAppendingString: posterURL];
    
        NSURL *url = [NSURL URLWithString:fullURL];
        //NSLog(@"Poster path: %@", fullURL);
        [cell.posterView setImage:nil];
        [cell.posterView setImageWithURL:url];
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

@end
