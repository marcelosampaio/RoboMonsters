//
//  InfoViewController.m
//  RoboMonsters
//
//  Created by Marcelo Sampaio on 9/14/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize placeholder1,placeholder2,placeholder3;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"self.view.frame.size.height=%f",self.view.frame.size.height);
    if (self.view.frame.size.height==480 || self.view.frame.size.height==460) {
        // This is a 3.5" screen size
        self.placeholder1.alpha=0;
        self.placeholder2.alpha=0;
        self.placeholder3.alpha=0;
    }

}


@end
