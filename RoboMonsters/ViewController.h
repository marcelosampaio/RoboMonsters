//
//  ViewController.h
//  RoboMonsters
//
//  Created by Marcelo Sampaio on 9/14/14.
//  Copyright (c) 2014 Marcelo Sampaio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController<UIActionSheetDelegate,MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshOutlet;

@property (weak, nonatomic) IBOutlet UILabel *labelText;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property int flag;

@property (strong,nonatomic)UIBarButtonItem * searchCache;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
