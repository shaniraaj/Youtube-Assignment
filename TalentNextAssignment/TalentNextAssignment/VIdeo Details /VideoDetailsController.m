//
//  VideoDetailsController.m
//  TalentNextAssignment
//
//  Created by Undecimo on 05/11/17.
//  Copyright © 2017 shanaishwar. All rights reserved.
//

#import "VideoDetailsController.h"
#import "AFHTTPSessionManager.h"
#define APIKey "AIzaSyCBu3NZFxZy6wtdsKjRDDiVetS9oNcbJNM"
@interface VideoDetailsController ()

@end

@implementation VideoDetailsController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.doneButtonAction setAction:@selector(setTheTitleAndDescriptionAndUpload)];
}

-(void)setTheTitleAndDescriptionAndUpload
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"GoogleUserObject"]] forHTTPHeaderField:@"Authorization"];
    NSDictionary *parameters = @{@"snippet" : @{@"title" : self.titleTextFIeld.text,
                                                @"description" : self.descriptionTextField.text}};
    
    [manager POST:@"https://www.googleapis.com/upload/youtube/v3/videos?part=snippet,status" parameters:parameters  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject: parameters options:NSJSONWritingPrettyPrinted error:NULL];
        NSMutableDictionary *mutableHeaders = [NSMutableDictionary dictionary];
        [mutableHeaders setValue:[NSString stringWithFormat:@"form-data; name=\"%@\"", @"snippet"] forKey:@"Content-Disposition"];
        [mutableHeaders setValue:@"application/json" forKey:@"Content-Type"];
        [formData appendPartWithHeaders:mutableHeaders body:jsonData];
        
        // [formData appendPartWithFileURL:filePath name:@"video" fileName:@"video.mov" mimeType:@"video/*" error:NULL];
        [formData appendPartWithFileURL:[self.info objectForKey:UIImagePickerControllerMediaURL] name:@"Test Vied" fileName:[[self.info objectForKey:UIImagePickerControllerMediaURL] lastPathComponent] mimeType:@"video/*" error:NULL];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//
//            UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"Video Uploaded Successfully" preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            }]];
//
//            [self presentViewController:alert animated:YES completion:nil];
//
//        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"Video Uploading Failed" preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }]];
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
