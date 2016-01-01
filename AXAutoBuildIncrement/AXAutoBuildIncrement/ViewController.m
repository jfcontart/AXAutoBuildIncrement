//
//  ViewController.m
//  AXAutoBuildIncrement
//
//  Created by Jean-François CONTART on 31/12/2015.
//  Copyright © 2015 idéMobi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


#pragma mark view method

- (void)viewDidLoad {
    [super viewDidLoad];
     // version with simple string
    NSDictionary *tInfoPlist = [[NSBundle mainBundle] infoDictionary];
    [mVersionLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Version__String__Format",@""), [tInfoPlist objectForKey:@"CFBundleShortVersionString"]]];
    
    // build with Attribut string
    NSMutableAttributedString *tBuildText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"Build__String__Format",@""), [tInfoPlist objectForKey:@"CFBundleVersion"]] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    
    NSMutableAttributedString *tGitHashText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"GitHash__String__Format",@""),[tInfoPlist objectForKey:@"GITHash"]] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil]];
    [tBuildText appendAttributedString:tGitHashText];
    [mBuildLabel setAttributedText:tBuildText];
    
    // Do any additional setup after loading the view, typically from a nib.
    
}

#pragma mark - memory managment

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

-(IBAction)openSettingsAction:(id)sSender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

@end
