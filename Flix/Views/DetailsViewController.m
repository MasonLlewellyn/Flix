//
//  DetailsViewController.m
//  Flix
//
//  Created by Mason Llewellyn on 6/25/20.
//  Copyright © 2020 Facebook University. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;
@property (weak, nonatomic) IBOutlet UIImageView *secondPoster;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.movie[@"original_title"];
    self.movieDescription.text = self.movie[@"overview"];
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = self.movie[@"poster_path"];
    NSString *backgroundURL = self.movie[@"backdrop_path"];
    
    if (posterURL){
        NSString *fullURL = [baseURL stringByAppendingString: posterURL];
    
        NSURL *url = [NSURL URLWithString:fullURL];
        //NSLog(@"Poster path: %@", fullURL);
        [self.secondPoster setImageWithURL:url];
    }
    
    if (backgroundURL){
        NSString *fullURL = [baseURL stringByAppendingString: backgroundURL];
        NSURL *url = [NSURL URLWithString:fullURL];
        [self.backGroundView setImageWithURL:url];
        
    }
    
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
