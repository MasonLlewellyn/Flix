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
#import "DetailsViewController.h"

@interface MovieGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation MovieGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.title = @"Popular";
    
    [self fetchMovies];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = self.collectionView.frame.size.width / postersPerLine;
    CGFloat itemHeight = itemWidth * 1.5;
    
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    
}

- (void)fetchMovies{
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/popular?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US&page=1"];

    
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
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //In this case, cancel means do nothing
            }];
            
            [alert addAction: tryAgainAction];
            [alert addAction: cancelAction];
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
        [self.refreshControl endRefreshing];
    }];
    [task resume];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSLog(@"Prepare for Segue");
    
    UICollectionViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detView = [segue destinationViewController];
    
    detView.movie = movie;
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = movie[@"poster_path"];
    if (posterURL){
        NSString *fullURL = [baseURL stringByAppendingString: posterURL];
    
        NSURL *url = [NSURL URLWithString:fullURL];
        //NSLog(@"Poster path: %@", fullURL);
        /*[cell.posterView setImage:nil];
        [cell.posterView setImageWithURL:url];*/
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];

        [cell.posterView setImageWithURLRequest:request placeholderImage:nil
                                            success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                                
                                                // imageResponse will be nil if the image is cached
                                                if (imageResponse) {
                                                    cell.posterView.alpha = 0.0;
                                                    cell.posterView.image = image;
                                                    
                                                    //Animate UIImageView back to alpha 1 over 0.3sec
                                                    [UIView animateWithDuration:0.3 animations:^{
                                                        cell.posterView.alpha = 1.0;
                                                    }];
                                                }
                                                else {
                                                    cell.posterView.image = image;
                                                }
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                                // do something for the failure condition
                                            }];
        
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.movies.count;
}

@end
