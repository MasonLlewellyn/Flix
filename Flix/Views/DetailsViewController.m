//
//  DetailsViewController.m
//  Flix
//
//  Created by Mason Llewellyn on 6/25/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;
@property (weak, nonatomic) IBOutlet UIImageView *secondPoster;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *releaseDateLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.delegate = self;
    //self.scrollView.contentSize = self.backgroundView.frame.size;
    self.title = self.movie[@"title"];
    
    float sizeOfContent = 0;
    UIView *lLast = [self.scrollView.subviews lastObject];
    NSInteger wd = lLast.frame.origin.y;
    NSInteger ht = lLast.frame.size.height;

    sizeOfContent = wd+ht;

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, sizeOfContent);
    
    self.titleLabel.text = self.movie[@"title"];
    self.movieDescription.text = self.movie[@"overview"];
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = self.movie[@"poster_path"];
    NSString *backgroundURL = self.movie[@"backdrop_path"];
    
    if (posterURL){
        NSString *fullURL = [baseURL stringByAppendingString: posterURL];
        
            NSURL *url = [NSURL URLWithString:fullURL];
            //NSLog(@"Poster path: %@", fullURL);
            /*[cell.posterView setImage:nil];
            [cell.posterView setImageWithURL:url];*/

            NSURLRequest *request = [NSURLRequest requestWithURL:url];

        [self.secondPoster setImageWithURLRequest:request placeholderImage:nil
                                            success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                                
                                                // imageResponse will be nil if the image is cached
                                                if (imageResponse) {
                                                    self.secondPoster.alpha = 0.0;
                                                    self.secondPoster.image = image;
                                                    
                                                    //Animate UIImageView back to alpha 1 over 0.3sec
                                                    [UIView animateWithDuration:0.3 animations:^{
                                                        self.secondPoster.alpha = 1.0;
                                                    }];
                                                }
                                                else {
                                                    self.secondPoster.image = image;
                                                }
                                            }
                                            failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                                // do something for the failure condition
                                            }];
    }
    
    if (backgroundURL){
        NSString *fullURL = [baseURL stringByAppendingString: backgroundURL];
        NSURL *url = [NSURL URLWithString:fullURL];
        [self.backGroundView setImageWithURL:url];
        
    }
    
    NSString *datePre_Text = @"Release Date: ";
    NSString *date = self.movie[@"release_date"];
    date = [datePre_Text stringByAppendingString:date];
    
    self.releaseDateLabel.text = date;
    [self.titleLabel sizeToFit];
    [self.movieDescription sizeToFit];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
