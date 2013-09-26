//
//  ViewControllerTest.h
//  ImagePicker
//
//  Created by NinhNB on 17/9/13.
//  Copyright (c) 2013 NinhNB. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@interface ImageViewControllerTest : SenTestCase
@property (strong) UIImagePickerController *picker;
@property (strong) id <UIImagePickerControllerDelegate> pickerDelegate;
@end
