//
//  ViewController.h
//  TalentNextAssignment
//
//  Created by Undecimo on 01/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <GoogleSignIn/GIDSignIn.h>

@interface ViewController : UIViewController <GIDSignInDelegate,UINavigationControllerDelegate>
- (IBAction)SignOutFromAccount:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *loggedUserName;

- (IBAction)signInToAccountButton:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *loginButtonOutlet;
@property (strong, nonatomic) IBOutlet UIButton *signoutButOutlet;


@end

