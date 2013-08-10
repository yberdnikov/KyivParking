//
//  DASettingsViewController.m
//  KyivParking
//
//  Created by Dmytro Anokhin on 7/14/13.
//  Copyright (c) 2013 danokhin. All rights reserved.
//

#import "DASettingsViewController.h"
#import "DAAppDelegate.h"


@interface DASettingsViewController ()

@property (nonatomic, weak) IBOutlet UITextField *textField;

- (IBAction)done:(id)sender;

@end


@implementation DASettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	NSString *carNumber = [[NSUserDefaults standardUserDefaults]
		stringForKey:kDACarNumberUserDefaultsKey];
	self.textField.text = nil != carNumber ? carNumber : @"";
}

- (IBAction)done:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setValue:self.textField.text
		forKey:kDACarNumberUserDefaultsKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
