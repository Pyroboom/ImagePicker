//
//  ViewControllerTest.m
//  ImagePicker
//
//  Created by NinhNB on 17/9/13.
//  Copyright (c) 2013 NinhNB. All rights reserved.
//

#import "ImageViewControllerTest.h"
#import "ImageViewController.h"
#import <objc/runtime.h>

@implementation ImageViewControllerTest{
    ImageViewController *viewController;
    UIImageView *imageView;
    UIScrollView *scrollView;
}

@synthesize picker;
@synthesize pickerDelegate;

-(void) setUp{
    picker = [[UIImagePickerController alloc] init];
    
    viewController = [[ImageViewController alloc] init];
    
    imageView = [[UIImageView alloc] init];
    viewController.imageView = imageView;
    
    scrollView = [[UIScrollView alloc] init];
    viewController.scrollView = scrollView;
}

-(void) tearDown{
    picker = nil;
    viewController = nil;
    imageView = nil;
    scrollView = nil;
}

-(void)testViewControllerHasImageView{
    objc_property_t imageViewProperty = class_getProperty([viewController class], "imageView");
    STAssertTrue(imageViewProperty != NULL, @"needs image view");
}


-(void)testViewControllerHasScrollView{
    objc_property_t scrollViewProperty = class_getProperty([viewController class], "scrollView");
    STAssertTrue(scrollViewProperty != NULL, @"needs scroll view");
}

-(void)testViewControllerHasImagePicker{
    objc_property_t pickerViewProperty = class_getProperty([viewController class], "picker");
    STAssertTrue(pickerViewProperty != NULL, @"need picker property");
}
@end
