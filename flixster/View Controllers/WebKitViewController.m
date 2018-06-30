//
//  WebKitViewController.m
//  flixster
//
//  Created by Bevin Benson on 6/29/18.
//  Copyright © 2018 Bevin Benson. All rights reserved.
//

#import "WebKitViewController.h"
#import <WebKit/WebKit.h>

@interface WebKitViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property(strong, nonatomic) NSArray *videos;

@end

@implementation WebKitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchVideos];
    
    
    
  
}

- (void) fetchVideos {
    
    NSString *stringURL = [NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed", self.id];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSLog(@"%@", stringURL);
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                                   message:@"The internet connection appears to be offline"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request2 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            UIAlertAction *tryAgainAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self fetchVideos];
            }];
            [alert addAction:tryAgainAction];
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"%@", dataDictionary);
            
            self.videos = dataDictionary[@"results"];
            
            for (NSDictionary *video in self.videos) {
                NSLog(@"%@", video[@"key"]);
            }
            
            NSDictionary *video = self.videos[0];
            NSString *key = video[@"key"];
            NSString *videoURL = [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@", key];
            NSLog(@"%@", videoURL);
            NSURL *url2 = [NSURL URLWithString:videoURL];
            NSURLRequest *request = [NSURLRequest requestWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
            [self.webView loadRequest:request];
            
        }
        
    }];
    [task resume];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
