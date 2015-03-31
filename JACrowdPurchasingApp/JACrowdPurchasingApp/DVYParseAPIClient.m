//
//  DVYParseAPIClient.m
//  JACrowdPurchasingApp
//
//  Created by Anish Kumar on 3/23/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

#import "DVYParseAPIClient.h"
#import "DVYUser.h"
#import "DVYCampaign.h"

@implementation DVYParseAPIClient

+(void)logInWithFacebookWithCompletionBlock:(void (^)(void))completionBlock AndSignUpComletionBlock:(void (^)(void))signUpCompletionBlock
{

    NSArray *permissionsArray = @[ @"email", @"user_friends"];

    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user)
        {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        }
        else if (user.isNew)
        {
            NSLog(@"User with facebook signed up and logged in!");
            NSLog(@"USER: %@", user);
            signUpCompletionBlock();
            
        }
        else
        {
            NSLog(@"User with facebook logged in!");
            completionBlock();
        }
        
    }];

}


+ (void) getSelfCampaignsWithCompletionBlock:(void (^)(NSArray *))completionBlock
{
    //NSMutableArray *selfCampaignlist = [[NSMutableArray alloc] init];
    DVYUser *currentUser = [PFUser currentUser];
    PFQuery *selfCampaignQuery = [DVYCampaign query];
    [selfCampaignQuery whereKey:@"host" equalTo:currentUser];
    
    NSArray *campaigns = [selfCampaignQuery findObjects];
    completionBlock(campaigns);
}


@end
