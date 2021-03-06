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


#pragma mark - Login/Signup Request

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



#pragma mark - Campaigns Fetcher

+ (void) getSelfCampaignsWithCompletionBlock:(void (^)(NSArray *))completionBlock
{

    DVYUser *currentUser = (DVYUser *)[PFUser currentUser];
    PFQuery *selfCampaignQuery = [DVYCampaign query];
    [selfCampaignQuery whereKey:@"host" equalTo:currentUser];
    [selfCampaignQuery includeKey:@"item"];
    [selfCampaignQuery includeKey:@"host"];

    [selfCampaignQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completionBlock(objects);

    }];
    
}



+ (void) getOthersCampaignsWithCompletionBlock:(void (^)(NSArray *))completionBlock
{
    //NSMutableArray *selfCampaignlist = [[NSMutableArray alloc] init];
    DVYUser *currentUser = (DVYUser *)[PFUser currentUser];
    
    PFQuery *othersCampaignQuery = [DVYCampaign query];
    
    [othersCampaignQuery whereKey:@"committed" equalTo:currentUser];
    [othersCampaignQuery includeKey:@"item"];
    [othersCampaignQuery includeKey:@"host"];

    [othersCampaignQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completionBlock(objects);
    }];
}



+ (void) getInvitationCampaignsWithCompletionBlock:(void (^)(NSArray *))completionBlock
{
    //NSMutableArray *selfCampaignlist = [[NSMutableArray alloc] init];
    DVYUser *currentUser = (DVYUser *)[PFUser currentUser];
    
    PFQuery *othersCampaignQuery = [DVYCampaign query];
    
    [othersCampaignQuery whereKey:@"invitees" equalTo:currentUser];
    [othersCampaignQuery includeKey:@"item"];
    [othersCampaignQuery includeKey:@"host"];

    [othersCampaignQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        completionBlock(objects);
    }];
}



#pragma mark - Facebook Friends Fetcher

+ (void) getFacebookFriendsWithCompletionBlock: (void (^)(NSArray *)) completionBlock
{
    FBRequest *requestForFriendsList = [FBRequest requestForMyFriends];
    [requestForFriendsList startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        NSDictionary *userData = (NSDictionary *)result;
        NSArray *friendsArrayFromFacebook = userData[@"data"];
        
        NSMutableArray *arrayOfFriends = [[NSMutableArray alloc] init];

        for (NSDictionary *friendData in friendsArrayFromFacebook) {
            
            NSString *friendFacebookID = friendData[@"id"];
            
            PFQuery *friendsQuery = [PFUser query];
            [friendsQuery whereKey:@"facebookID" equalTo:friendFacebookID];
            [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [arrayOfFriends addObject:objects[0]];
                completionBlock(arrayOfFriends);
            }];
        }
    }];
}


@end
