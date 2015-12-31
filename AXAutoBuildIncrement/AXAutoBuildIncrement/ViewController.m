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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSDictionary *tInfoPlist = [[NSBundle mainBundle] infoDictionary];
    [mVersionLabel setText:[NSString stringWithFormat:@"version : %@", [tInfoPlist objectForKey:@"CFBundleShortVersionString"]]];
    
    // build with basic string
    [mBuildLabel setText:[NSString stringWithFormat:@"build : %@-%@", [tInfoPlist objectForKey:@"CFBundleVersion"], [tInfoPlist objectForKey:@"GITHash"]]];
    
    // build with Attribut string
    NSMutableAttributedString *tBuildText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"build : %@", [tInfoPlist objectForKey:@"CFBundleVersion"]] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
    
    NSMutableAttributedString *tGitHashText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%@)",[tInfoPlist objectForKey:@"GITHash"]] attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName, nil]];
    
    [tBuildText appendAttributedString:tGitHashText];
    [mBuildLabel setAttributedText:tBuildText];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
