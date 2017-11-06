//
//  VideoDetailsController.h
//  TalentNextAssignment
//
//  Created by Undecimo on 05/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
@interface VideoDetailsController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField * _Nonnull titleTextFIeld;
@property (strong, nonatomic) IBOutlet UITextView * _Nonnull descriptionTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem * _Nonnull doneButtonAction;
@property (strong,nonnull) NSDictionary * info;
@end
