//
//  ViewController.m
//  Demo
//
//  Created by Maurizio Cremaschi on 8/15/12.
//  Copyright (c) 2012 Flubber Media Ltd. All rights reserved.
//

#import "ViewController.h"
#import "UIView+FMSpring.h"

@interface ViewController ()

@property (assign) BOOL buttonSpringEnabled;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _buttonSpringEnabled = YES;
    
    [_springView enableSpring:YES];
    [_springImageView enableSpring:YES];
    [_springButton enableSpring:_buttonSpringEnabled];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)didTapButton:(id)sender
{
    _buttonSpringEnabled = !_buttonSpringEnabled;
    [_springButton enableSpring:_buttonSpringEnabled];
}

@end
