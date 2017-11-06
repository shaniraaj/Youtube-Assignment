//
//  LocationHistory.m
//  TalentNextAssignment
//
//  Created by Undecimo on 05/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import "LocationHistory.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "ViewController.h"
#import "AppDelegate.h"

@interface LocationHistory ()
{
    NSMutableArray * locationArray;
    NSMutableArray * countryArray;
    CLLocationManager * locationManager;
}
@end

@implementation LocationHistory

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.locationHistoryTableView.tableFooterView = [UIView new];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"locationArray"]!=nil)
    {
        locationArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"locationArray"]];
        countryArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] valueForKey:@"countryArray"]];
    }
    else
    {
        locationArray = [NSMutableArray new];
        countryArray = [NSMutableArray new];
    }
    
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    

    
}

#pragma mark - TableView delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return locationArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel * countryLabel = [cell viewWithTag:1];
    countryLabel.text = [countryArray objectAtIndex:indexPath.row];
    
    UITextView * textView = [cell viewWithTag:2];
    textView.textContainerInset=UIEdgeInsetsMake(0, 0, 0, 0);
    textView.textContainer.lineFragmentPadding=0;
    textView.text = [locationArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocation *currentLocation = [locations lastObject];
    
    if (currentLocation != nil)
        NSLog(@"longitude = %.8f\nlatitude = %.8f", currentLocation.coordinate.longitude,currentLocation.coordinate.latitude);
    
    // stop updating location in order to save battery power
   // [locationManager stopUpdatingLocation];
    
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
         if (error == nil && [placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks lastObject];
             
             // strAdd -> take bydefault value nil
             NSString *strAdd = nil;
             
             
             if ([placemark.thoroughfare length] != 0)
             {
                 // strAdd -> store value of current location
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark thoroughfare]];
                 else
                 {
                     // strAdd -> store only this value,which is not null
                     strAdd = placemark.thoroughfare;
                   
                     
                 }
             }
             
             if ([placemark.postalCode length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark postalCode]];
                 else
                     strAdd = placemark.postalCode;
             }
             
             if ([placemark.locality length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark locality]];
                 else
                     strAdd = placemark.locality;
             }
             
             if ([placemark.administrativeArea length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark administrativeArea]];
                 else
                     strAdd = placemark.administrativeArea;
             }
             
             [locationArray addObject:strAdd];
             
             if ([placemark.country length] != 0)
             {
                 if ([strAdd length] != 0)
                     strAdd = [NSString stringWithFormat:@"%@, %@",strAdd,[placemark country]];
                 else
                     strAdd = placemark.country;
             }
             
             [countryArray addObject:placemark.country];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.locationHistoryTableView reloadData];
             });
         }
     }];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [@"Places you last visited" uppercaseString];
}


- (IBAction)signOutButtonAction:(UIBarButtonItem *)sender
{
    [[GIDSignIn sharedInstance] signOut];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"GoogleUserObject"];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"userGivenName"];
    ViewController * logInView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"locationArray"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"countryArray"];
    ((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = logInView;
}

- (IBAction)updatingLocation:(UIBarButtonItem *)sender
{
    if ([sender.title isEqualToString:@"Start Updating"]) {
        [locationManager startUpdatingLocation];
        [sender setTitle:@"Stop Updating"];
    }
    else
    {
        [locationManager stopUpdatingLocation];
        [sender setTitle:@"Start Updating"];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:locationArray forKey:@"locationArray"];
    [[NSUserDefaults standardUserDefaults] setObject:countryArray forKey:@"countryArray"];
}
@end
