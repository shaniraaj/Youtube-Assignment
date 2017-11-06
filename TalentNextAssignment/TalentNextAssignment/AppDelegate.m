//
//  AppDelegate.m
//  TalentNextAssignment
//
//  Created by Undecimo on 01/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import "AppDelegate.h"
#import "YoutubePlayerController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GIDSignIn sharedInstance].clientID = @"100462326697-epmu3kd2kajcrh0ftia2buvsqsoqrr4a.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
    NSArray * currentScopes = GIDSignIn.sharedInstance.scopes;
    GIDSignIn.sharedInstance.scopes = [currentScopes arrayByAddingObjectsFromArray:@[@"https://www.googleapis.com/auth/youtube.upload",
                                                                                     @"https://www.googleapis.com/auth/youtube",
                                                                                     @"https://www.googleapis.com/auth/youtubepartner",
                                                                                     @"https://www.googleapis.com/auth/youtube.force-ssl",
                                                                                     @"https://www.googleapis.com/auth/youtube.readonly"]];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"GoogleUserObject"]!=nil)
    {
        UIStoryboard * mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController * tabBar = [mainStoryBoard instantiateViewControllerWithIdentifier:@"tabbar"];
        self.window.rootViewController = tabBar;
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options
{
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

// [START signin_handler]
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    _idToken = user.authentication.idToken; // Safe to send to the server
   
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    
    [[NSUserDefaults standardUserDefaults] setValue:user.authentication.accessToken forKey:@"GoogleUserObject"];
    [[NSUserDefaults standardUserDefaults] setValue:givenName forKey:@"userGivenName"];
    
    self.customGoogleUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"GoogleUserObject"];
    
    // [START_EXCLUDE]
    NSDictionary *statusText = @{@"statusText":
                                     [NSString stringWithFormat:@"Signed in user: %@",
                                      fullName]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToggleAuthUINotification" object:nil userInfo:statusText];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigateToYoutube" object:nil];
    
}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    
    NSDictionary *statusText = @{@"statusText": @"Disconnected user" };
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ToggleAuthUINotification"
     object:nil
     userInfo:statusText];
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
   
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
   
}

@end
