//
//  OnlinePhotosViewController.m
//  RemindersApp
//
//  Created by Chris Jones on 2017-02-07.
//  Copyright © 2017 Jonescr. All rights reserved.
//

#import "OnlinePhotosViewController.h"
#import "NewReminderViewController.h"
#import "CollectionViewCell.h"

@interface OnlinePhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *photos;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CollectionViewCell *cell;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation OnlinePhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [NSMutableArray new];
    
    NSURLComponents *comps = [NSURLComponents componentsWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=274d899f647849f684a98a2c86588897&tags=landscape&safe_search=1&extras=url_m&per_page=50&format=json&nojsoncallback=1"];
    
    [self configureURL:comps.URL];
    
}

-(void)configureURL:(NSURL *)url {
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"error : %@", error.localizedDescription);
            return;
        }
        NSError *jsonError = nil;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"JSON error : %@", jsonError.localizedDescription);
            return;
        }
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        for (NSDictionary *photo in jsonDict[@"photos"][@"photo"]) {
            if (photos.count <= 100) {
                NSString *title = photo[@"title"];
                NSString *photoURLString = photo[@"url_m"];
                NSURL *photoURL = [NSURL URLWithString:photoURLString];
                
                Photo *photo = [[Photo alloc]initWithURL:photoURL andTitle:title];
                [photos addObject:photo];
            } else {
                break;
            }
        }
        self.photos = photos;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
    }];
    [dataTask resume];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionviewcell" forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.row];
    cell.photo = photo;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Photo *photo = self.photos[indexPath.item];
    [self.delegate onlinePhotosViewController:self didAddPhoto:photo];
    
}

// Do any additional setup after loading the view.


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)searchOnline:(UIButton *)sender {
    
    NSString *textFieldString = self.searchTextField.text;
    NSString *searchString = [textFieldString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=274d899f647849f684a98a2c86588897&tags=%@&safe_search=1&extras=url_m&per_page=50&format=json&nojsoncallback=1",searchString];
    
    NSURL *comps = [NSURL URLWithString:urlString];
    
    [self configureURL:comps];
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
