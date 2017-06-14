//
//  ViewController.h
//  Calculator_iPad
//
//  Created by Clyde Barrow on 13.06.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const ButtonACDidChangeNotification;


@interface ViewController : UIViewController

- (IBAction)buttonCalculator:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *buttonZero;
@property (weak, nonatomic) IBOutlet UIButton *buttonOne;
@property (weak, nonatomic) IBOutlet UIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet UIButton *buttonThree;
@property (weak, nonatomic) IBOutlet UIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UIButton *buttonFive;
@property (weak, nonatomic) IBOutlet UIButton *buttonSix;
@property (weak, nonatomic) IBOutlet UIButton *buttonSeven;
@property (weak, nonatomic) IBOutlet UIButton *buttonEight;
@property (weak, nonatomic) IBOutlet UIButton *buttonNine;
@property (weak, nonatomic) IBOutlet UIButton *buttonAC;
@property (weak, nonatomic) IBOutlet UIButton *buttonShift;
@property (weak, nonatomic) IBOutlet UIButton *buttonPercent;
@property (weak, nonatomic) IBOutlet UIButton *buttonDivide;
@property (weak, nonatomic) IBOutlet UIButton *buttonMultiply;
@property (weak, nonatomic) IBOutlet UIButton *buttonMinus;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlus;
@property (weak, nonatomic) IBOutlet UIButton *buttonEqual;
@property (weak, nonatomic) IBOutlet UIButton *buttonDot;


@property (weak, nonatomic) IBOutlet UILabel *labelCalculator;


@end

