//
//  DVYCampaignDetailView.h
//  JACrowdPurchasingApp
//
//  Created by Anish Kumar on 3/25/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DVYUser;
@interface DVYCampaignDetailView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *campaignTitle;
@property (weak, nonatomic) IBOutlet UITextView *campaignDetails;
@property (weak, nonatomic) IBOutlet UILabel *hostName;
@property (weak, nonatomic) IBOutlet UILabel *peopleCommited;
@property (weak, nonatomic) IBOutlet UILabel *peopleNeeded;
@property (weak, nonatomic) IBOutlet UILabel *deadline;

- (void) createACampaignPageWithTitle: (NSString *)title Details: (NSString *)details Host: (DVYUser *)host PeopleCommited: (NSNumber *)peopleCommited PeopleNeeded: (NSNumber *)peopleNeeded Deadline: (NSDate *)deadline ProfilePicture: (UIImage *)profilePicture;

@end