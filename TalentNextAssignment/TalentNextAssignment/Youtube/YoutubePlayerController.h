//
//  YoutubePlayerController.h
//  TalentNextAssignment
//
//  Created by Undecimo on 02/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/ALAssetsLibrary.h>


@interface YoutubePlayerController : UIViewController<UITableViewDelegate,UITableViewDataSource,YTPlayerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *ChannelTableView;
@property NSDictionary * VideoInfoDict;
- (IBAction)signOutButtonAction:(UIBarButtonItem *)sender;


@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *uploadButton;
- (IBAction)upLoadButtonAction:(UIBarButtonItem *)sender;


@property (strong, nonatomic) IBOutlet UIBarButtonItem *signOut;
@end
