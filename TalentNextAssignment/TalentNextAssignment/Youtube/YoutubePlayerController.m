//
//  YoutubePlayerController.m
//  TalentNextAssignment
//
//  Created by Undecimo on 02/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//


#import "YoutubePlayerController.h"
#import "AppDelegate.h"
#import <GoogleSignIn/GIDSignIn.h>
#import "VideoDetailsController.h"
#import "ActivityIndicator.h"
#import "ViewController.h"
#define APIKey "AIzaSyCBu3NZFxZy6wtdsKjRDDiVetS9oNcbJNM"

@interface YoutubePlayerController ()
{
    NSMutableDictionary * youtubeVideoListDictionary;
    BOOL reloadAfterSelection;
    NSIndexPath * selectedIndexPath;
    ActivityIndicator * activityBlurView;
}
@end

@implementation YoutubePlayerController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    reloadAfterSelection=NO;
    //get all videos from that channel id
    //https://www.googleapis.com/youtube/v3/search?key=AIzaSyDHWlpH8dtmIRX6VcfwlFFXm_rYVxJPDXs&channelId=UCDOSsm4gbho7cHH-i-ft16w%20&part=snippet,id&order=date&maxResults=20
    youtubeVideoListDictionary = [NSMutableDictionary new];
    
    self.ChannelTableView.tableFooterView = [UIView new];
 
    
    AppDelegate * appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDel.customGoogleUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"GoogleUserObject"];
  
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"userGivenName"]]];
    
    NSString * urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/channels?part=id,contentDetails&mine=true&access_token=%@",appDel.customGoogleUser];

    NSMutableURLRequest * channelRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:channelRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if(data)
        {
            [self getChannelVideosFromChannelID:[[[[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] valueForKey:@"items"] firstObject] valueForKey:@"id"]];
        }
    }] resume] ;
}

-(void)getChannelVideosFromChannelID:(NSString *)channelID
{
    NSString * urlString = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?key=%s&channelId=%@&part=snippet,id&order=date",APIKey,channelID];

    NSMutableURLRequest * channelRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:channelRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if(data)
        {
            youtubeVideoListDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.ChannelTableView reloadData];
            });
        }
    }] resume] ;
}



#pragma mark - TableView Delegate and datasource Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * customCell = [tableView dequeueReusableCellWithIdentifier:@"Channel"];
    UIImageView * image = [customCell viewWithTag:1];
    UILabel * titleLabel = [customCell viewWithTag:2];
    UILabel * descriptionLabel = [customCell viewWithTag:3];
    
    [self setPlayerHidden:reloadAfterSelection forImageView:image titleLabel:titleLabel andDescriptionLabel:descriptionLabel];
    
  
        NSURLSession * session = [NSURLSession sharedSession];
        
        [[session dataTaskWithURL:[NSURL URLWithString:[[[[[[youtubeVideoListDictionary valueForKey:@"items"] objectAtIndex:indexPath.row] valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"medium"] valueForKey:@"url"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                image.image = [UIImage imageWithData:data];
            });
        }] resume] ;
        
        titleLabel.text = [[[[youtubeVideoListDictionary valueForKey:@"items"] objectAtIndex:indexPath.row] valueForKey:@"snippet"] valueForKey:@"title"];
        
        descriptionLabel.text = [[[[youtubeVideoListDictionary valueForKey:@"items"] objectAtIndex:indexPath.row] valueForKey:@"snippet"] valueForKey:@"description"];

    customCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return customCell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)[youtubeVideoListDictionary valueForKey:@"items"]).count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * videoID = [[[[youtubeVideoListDictionary valueForKey:@"items"] objectAtIndex:(int)indexPath.row] valueForKey:@"id"] valueForKey:@"videoId"];
    [_playerView loadWithVideoId:videoID];
    _playerView.delegate=self;
    [self startActivityIndicator];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.tableFooterView = [UIView new];
}

#pragma mark - Helper Methods

-(void)setPlayerHidden:(BOOL)hideStatus forImageView:(UIImageView*)imageView titleLabel:(UILabel*)titleLabel andDescriptionLabel:(UILabel*)descriptionLabel
{
    if(hideStatus==NO)
    {
        [self.playerView setHidden:YES];
        [imageView setHidden:NO];
        [titleLabel setHidden:NO];
        [descriptionLabel setHidden:NO];
    }
    else
    {
        [self.playerView setHidden:NO];
        [imageView setHidden:YES];
        [titleLabel setHidden:YES];
        [descriptionLabel setHidden:YES];
    }
}


#pragma mark - YTLPlayer delegate methods
-(void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    
    [playerView playVideo];
}
-(void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state
{
    if (state == kYTPlayerStateEnded || state == kYTPlayerStatePaused)
    {
        [self stopActivityView];
        reloadAfterSelection=NO;
        selectedIndexPath=nil;
        [playerView stopVideo];
        
        [self.ChannelTableView reloadData];
    }
}


#pragma mark - Image Picker view delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.VideoInfoDict = [[NSDictionary alloc]initWithDictionary:info];
    [self performSegueWithIdentifier:@"UploadVideoDetails" sender:self];

    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Activity Indicator

-(void)startActivityIndicator
{
    
    activityBlurView = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityIndicator"];
    activityBlurView.view.center = self.view.center;
    activityBlurView.ActivityLabel.text = @"Playing video ...";
    [activityBlurView.activityIndicator startAnimating];
    [self.view addSubview:activityBlurView.view];
}

-(void)stopActivityView
{
    [activityBlurView.activityIndicator stopAnimating];
    [activityBlurView.view removeFromSuperview];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"UploadVideoDetails"])
    {
        VideoDetailsController * videoControl = segue.destinationViewController;
        videoControl.info = self.VideoInfoDict;
    }
}

- (IBAction)signOutButtonAction:(UIBarButtonItem *)sender
{
    [[GIDSignIn sharedInstance] signOut];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"GoogleUserObject"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userGivenName"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"locationArray"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"countryArray"];
    
    ViewController * logInView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = logInView;
    
    
    
}
- (IBAction)upLoadButtonAction:(UIBarButtonItem *)sender
{
    UIImagePickerController * videoPicker = [[UIImagePickerController alloc]init];
    videoPicker.mediaTypes = @[(NSString*)kUTTypeMovie];//,(NSString*)kUTTypeMPEG,(NSString*)kUTTypeMPEG4,(NSString*)kUTTypeMPEG2Video];
    videoPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    videoPicker.allowsEditing=NO;
    videoPicker.delegate=self;
    [self presentViewController:videoPicker animated:YES completion:^{
        
    }];
}
@end
