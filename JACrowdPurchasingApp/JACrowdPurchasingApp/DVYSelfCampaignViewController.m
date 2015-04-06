//
//  DVYSelfCampaignViewController.m
//  JACrowdPurchasingApp
//
//  Created by Anish Kumar on 3/25/15.
//  Copyright (c) 2015 Anish Kumar. All rights reserved.
//

#import "DVYSelfCampaignViewController.h"
#import "DVYCampaignDetailView.h"
#import "DVYCampaign.h"
#import "DVYCreateCampaignViewController.h"
#import "DVYInviteFriendsTableViewController.h"
#import "UIImage+animatedGIF.h"

#import <JNWSpringAnimation/JNWSpringAnimation.h>
#import <NSValue+JNWAdditions.h>
#import <Parse/Parse.h>


@interface DVYSelfCampaignViewController ()

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *backgroundBlurView;

- (IBAction)editButtinTapped:(id)sender;
@property (nonatomic) DVYCampaignDetailView *detailCampaignViewSelf;

@end

@implementation DVYSelfCampaignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"DVYCampaignDetailView" owner:self options:nil];
    
    self.detailCampaignViewSelf = [nibViews firstObject];
    
    DVYUser *host = self.campaign.host;
    self.detailCampaignViewSelf.hostName.text = [NSString stringWithFormat:@"Made by: %@", host[@"fullName"]];
    
    Item *campaignItem = self.campaign.item;
    PFFile *image = [campaignItem objectForKey:@"itemImage"];
    
    if (image) {
        [image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.detailCampaignViewSelf.profilePicture.image = [UIImage imageWithData:data];
                // Add a nice corner radius to the image
//                self.detailCampaignViewSelf.profilePicture.layer.cornerRadius = 8.0f;
                self.detailCampaignViewSelf.profilePicture.layer.masksToBounds = YES;                }
        }];
    } else {
        NSURL *pusheenDance = [NSURL URLWithString:@"http://33.media.tumblr.com/tumblr_m9hbpdSJIX1qhy6c9o1_400.gif"];
        self.detailCampaignViewSelf.profilePicture.image = [UIImage animatedImageWithAnimatedGIFURL:pusheenDance];
        self.detailCampaignViewSelf.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
        
    }

    self.detailCampaignViewSelf.backgroundColor = [UIColor whiteColor];
    
//    [self blurTheView];
    
    [self.contentView addSubview:self.detailCampaignViewSelf];
    self.detailCampaignViewSelf.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    
    self.detailCampaignViewSelf.neededCountView.layer.cornerRadius = 8.0f;
    self.detailCampaignViewSelf.commitCountView.layer.cornerRadius = 8.0f;
    
    self.view.opaque = NO;
    
}

- (void)blurTheView {
    self.view.backgroundColor = [UIColor clearColor];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurredEffectView.frame = self.view.frame;
    [self.backgroundBlurView addSubview:blurredEffectView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // Do any additional setup after loading the view.
    self.detailCampaignViewSelf.campaignTitle.text = [self.campaign.title capitalizedString];
    self.detailCampaignViewSelf.campaignDetails.text = self.campaign.detail;
    self.detailCampaignViewSelf.peopleNeeded.text = [NSString stringWithFormat:@"%@", self.campaign.minimumNeededCommits];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *stringDate = [dateFormatter stringFromDate:self.campaign.deadline];
    
    self.detailCampaignViewSelf.deadline.text = stringDate;
    

    PFQuery *query = [self.campaign.committed query];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        NSInteger count = (NSInteger) number;
        self.detailCampaignViewSelf.peopleCommited.text = [NSString stringWithFormat:@"%ld", count];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editButtinTapped:(id)sender {
    
    DVYCreateCampaignViewController *edit = [[DVYCreateCampaignViewController alloc] init];
    edit.buttonName = @"Update";
    edit.titlePlaceholder = self.campaign.title;
    edit.descriptionPlaceholder = self.campaign.detail;
    edit.numberOfPeoplePlaceHolder = [NSString stringWithFormat:@"%@", self.campaign.minimumNeededCommits];
    edit.campaignToUpdate = self.campaign;
    edit.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:edit animated:YES completion:nil];
    
}

- (IBAction)addFriendsButtinTapped:(id)sender {
    
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"CreateFlow" bundle:nil];
    
    DVYInviteFriendsTableViewController *friendsToBeAdded = [myStoryboard instantiateInitialViewController];
    friendsToBeAdded.campaign = self.campaign;
    
    [self presentViewController:friendsToBeAdded animated:YES completion:nil];
    
}

- (IBAction)doneButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteButtonTapped:(id)sender {
    
    [self.campaign deleteInBackground];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)removeConstraints
{
    [self.view removeConstraints:self.view.constraints];
    
    self.detailCampaignViewSelf.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.buttonView removeConstraints:self.buttonView.constraints];
    self.buttonView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setConstraints
{
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.presentingViewController attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-16];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.presentingViewController attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.presentingViewController attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.presentingViewController attribute:NSLayoutAttributeTop multiplier:0 constant:100];
    
    [self.view addConstraints:@[width, centerX, centerY, height]];
    
}

@end
