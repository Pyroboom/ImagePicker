//
//  ViewController.h
//  ImagePicker
//
//  Created by NinhNB on 17/9/13.
//  Copyright (c) 2013 NinhNB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
{
    UIImagePickerController *picker;
    IBOutlet UISlider *slider;
    IBOutlet UIImageView *imageView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) CIImage *beginImage ;
@property (nonatomic, retain) UISlider *slider;

-(IBAction)sliderAction :(id)sender;
-(IBAction)buttonClicked;
-(IBAction)buttonClear;

@end
