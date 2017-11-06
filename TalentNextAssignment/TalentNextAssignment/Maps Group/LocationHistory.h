//
//  LocationHistory.h
//  TalentNextAssignment
//
//  Created by Undecimo on 05/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationHistory : UIViewController<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *locationHistoryTableView;
- (IBAction)signOutButtonAction:(UIBarButtonItem *)sender;
- (IBAction)updatingLocation:(UIBarButtonItem *)sender;

@end
