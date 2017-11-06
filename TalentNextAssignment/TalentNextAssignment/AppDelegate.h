//
//  AppDelegate.h
//  TalentNextAssignment
//
//  Created by Undecimo on 01/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong) NSString *idToken;
@property (strong) NSString * customGoogleUser;
@end

