//
//  ViewController.m
//  TalentNextAssignment
//
//  Created by Undecimo on 01/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import "ViewController.h"
#import "YoutubePlayerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [GIDSignIn sharedInstance].uiDelegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateToYotubeConsole) name:@"navigateToYoutube" object:false];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"GoogleUserObject"]!=nil)
    {
        self.loginButtonOutlet.hidden=YES;
        self.loggedUserName.hidden=NO;
        self.signoutButOutlet.hidden=NO;
    }
    else
    {
        self.loginButtonOutlet.hidden=NO;
        self.loggedUserName.hidden=YES;
        self.signoutButOutlet.hidden=YES;
    }
    
}

-(void)navigateToYotubeConsole
{
    [self performSegueWithIdentifier:@"navigateToTabbar" sender:self];
}

#pragma mark - Google sign in delegate methods

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
}


- (IBAction)SignOutFromAccount:(UIButton *)sender
{
    [[GIDSignIn sharedInstance] signOut];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"GoogleUserObject"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userGivenName"];
    self.loginButtonOutlet.hidden=NO;
    self.loggedUserName.hidden=YES;
    self.signoutButOutlet.hidden=YES;
}

- (IBAction)signInToAccountButton:(UIButton *)sender {
    [[GIDSignIn sharedInstance] signIn];
}
@end
