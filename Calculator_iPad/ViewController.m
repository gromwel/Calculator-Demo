//
//  ViewController.m
//  Calculator_iPad
//
//  Created by Clyde Barrow on 13.06.17.
//  Copyright © 2017 Pavel Podgornov. All rights reserved.
//

#import "ViewController.h"

NSString* const ButtonACDidChangeNotification = @"ButtonACDidChangeNotification";


@interface ViewController ()

@property (nonatomic, assign) BOOL isNewValue;
@property (nonatomic, assign) BOOL isButtonAC;

@property (nonatomic, assign) double firstValue;
@property (nonatomic, assign) double secondValue;
@property (nonatomic, assign) double resultValue;

@property (nonatomic,assign) NSUInteger operation;
@property (nonatomic, assign) NSUInteger button;





@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    
    //обнулили свойства
    self.isNewValue = YES;
    self.isButtonAC = YES;
    
    self.firstValue = 0.f;
    self.secondValue = 0.f;
    self.resultValue = 0.f;
    
    self.operation = 0;
    self.button = 0;
    
    
    
    //округлили кнопки, анимацию пришили
    NSArray * views = [self.view subviews];
    
    for (id  view in views) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton * button = (UIButton *)view;
            button.layer.cornerRadius = CGRectGetHeight(button.frame)/2;
            
            [button addTarget:self
                       action:@selector(animatedBackgroundColorDown:)
             forControlEvents:UIControlEventTouchDown];
            
            [button addTarget:self
                       action:@selector(animatedBackgroundColorUp:)
             forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
    //добавили свайп
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(operationC)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeLeft];
    
    
    //опция уменьшающая текст при заполнении
    self.labelCalculator.adjustsFontSizeToFitWidth = YES;
    
    
    
    
    //создаем подпись на рассылку
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setValueButtonAC:)
                                                 name:ButtonACDidChangeNotification
                                               object:nil];
    
}








#pragma mark - Basic Function

//отработка нажатий
- (void) buttonCalculator:(UIButton *)sender {
    
    
    //если цифры
    if (sender.tag < 100) {
        [self checkQuantityNumbers: [NSString stringWithFormat:@"%d", (int)sender.tag]];
        
        //если математические операции
    } else if (sender.tag > 200) {
        [self operationsProcessing:sender.tag];
        
        //если другие операции
    } else if (sender.tag == 100) {
        [self operationDot];
    } else if (sender.tag == 101) {
        [self operationAC];
    } else if (sender.tag == 102) {
        [self operationShift];
    } else if (sender.tag == 103) {
        [self operationPercent];
    } else if (sender.tag == 200) {
        [self operationEqual];
    }
}


//расчет цвета RGB
- (UIColor *) colorWithR : (NSInteger) red G : (NSInteger) green B : (NSInteger) blue {
    
    CGFloat r = (float) (1.f / 255 * red);
    CGFloat g = (float) (1.f / 255 * green);
    CGFloat b = (float) (1.f / 255 * blue);
    
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

//изменение состояния кнопки
- (void) setValueButtonAC : (NSNotification *) notification {
    
    if (!self.isButtonAC) {
        [self.buttonAC setTitle:@"C" forState:UIControlStateNormal];
        
    } else {
        [self.buttonAC setTitle:@"AC" forState:UIControlStateNormal];
        
    }
    
    
}


//анимация текста
- (void) animationLabelText : (NSString *) stringShanges {
    
    CATransition * transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.1f;
    [self.labelCalculator.layer addAnimation:transition forKey:nil];
    self.labelCalculator.text = stringShanges;
    
}


#pragma mark - Numbers Button

//запятая
- (void) operationDot {
    
    //если строка не содержит запятые или число новое, то можно добавть запятую
    if (![self.labelCalculator.text containsString:@","] | self.isNewValue) {
        [self checkQuantityNumbers:@","];
    }
}


//проверка на количество цифр в строке
- (void) checkQuantityNumbers : (NSString *) symbol {
    
    NSString * value =
    [self parsingStringForLength: self.labelCalculator.text];
    
    //если символов меньше 9 или пишем новое число
    if ((value.length < 9) | self.isNewValue) {
        
        //добавляем символ
        [self addSymbol:symbol];
    }
}


//добавление знака
- (void) addSymbol : (NSString *) symbol {
    
    //если флаг новое значение то обнуляем лейбл и меняем флаг
    if (self.isNewValue) {
        [self animationLabelText:@"0"];
        self.isNewValue = NO;
    }
    
    //если добавляем запятую и значение в поле равно нулю
    if ([symbol isEqualToString:@","] & [self.labelCalculator.text isEqualToString:@"0"]) {
        [self animationLabelText:
         [NSString stringWithFormat:@"%@%@",self.labelCalculator.text, symbol]];
        
        
        //если значение в поле равно нулю удаляем ноль и ставим цифру
    } else if ([self.labelCalculator.text isEqualToString:@"0"]) {
        [self animationLabelText:
         [self.labelCalculator.text substringToIndex:self.labelCalculator.text.length-1]];
        
        [self animationLabelText:
         [NSString stringWithFormat:@"%@%@",self.labelCalculator.text, symbol]];
        
        
        //если добавляем любую цифру когда уже значене не 0 просто добовляем символ
    } else {
        
        [self animationLabelText:
         [self parsingValueToString: [self parsingStringToValue:
                                      [NSString stringWithFormat:@"%@%@",self.labelCalculator.text, symbol]]]];
    }
    
    
    
    
    //отправили сообщение если AC
    if (self.isButtonAC) {
        //изменили кнопку с АС на С
        self.isButtonAC = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ButtonACDidChangeNotification
                                                            object:nil];
    }
    
    
}



#pragma mark - Operation Button

//отработка операций
- (void) operationsProcessing : (NSUInteger) operation {
    
    //если операции не было раньше установлено или флаг новое число
    if ((self.operation == 0.f) | self.isNewValue) {
        
        //записываем первое число
        self.firstValue = [[self parsingStringToValue:self.labelCalculator.text] doubleValue];
        
        //остальные случаи
    } else {
        
        //записываем второе число
        self.secondValue = [[self parsingStringToValue:self.labelCalculator.text] doubleValue];
        
        //считаем
        [self calculation];
        
        //когда посчитали
        self.firstValue = self.resultValue;
        
    }
    
    //записываем операцию если это не равно
    if (operation != 200) {
        self.operation = operation;
    }
    
    //разрешаем писать новое число
    self.isNewValue = YES;
    
    
    
    //запишем кнопку что была нажата
    self.button = operation;
    
}



#pragma mark - Reset

//сбрасываем операцию
- (void) resetOperation {
    self.operation = 0.f;
}

//сбрасываем операцию
- (void) resetButton {
    self.button = 0.f;
}

//сбрасываем покаания на экране
- (void) resetLabel {
    [self animationLabelText:@"0"];
    self.isNewValue = YES;
}

//сбрасываем первое значение
- (void) resetFirstValue {
    self.firstValue = 0.f;
}

//сбрасываем второе значение
- (void) resetSecondValue {
    self.secondValue = 0.f;
}

//сбрасываем все
- (void) resetAll {
    [self animationLabelText:@"0"];
    self.firstValue = 0.f;
    self.secondValue = 0.f;
    self.resultValue = 0.f;
    self.operation = 0;
    
    self.button = 0;
    
    self.isNewValue = YES;
}




#pragma mark - Calculation

//считываем число и оператор
- (void) calculation {
    
    //считаем и записываем результат
    self.resultValue = [self calculationResult];
    
    //выводим результат
    NSMutableString * string = [NSMutableString stringWithFormat:@"%f", self.resultValue];
    [self deleteZero: string];
    [self animationLabelText:[self parsingValueToString:string]];
    
}


//просчитываем результат
- (double) calculationResult {
    
    double result;
    
    //проверяем какая операция будет выполнена и выполняем
    if (self.operation == 202) {
        result = [self operationDivide];
    } else if (self.operation == 203) {
        result = [self operationMultiply];
    } else if (self.operation == 204) {
        result = [self operationMinus];
    } else if (self.operation == 205) {
        result = [self operationPlus];
    }
    
    return result;
}



#pragma mark - Operation


//стереть один символ
- (void) operationC {
    if (self.labelCalculator.text.length > 1) {
        
        if (self.secondValue != 0.f) {
            
        } else {
        
        NSMutableString * string = [NSMutableString stringWithString: [self parsingStringToValue:self.labelCalculator.text]];
        [string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
        [string setString:[self parsingValueToString:string]];
        [self animationLabelText:string];
        
        }
            
            
        if (self.isNewValue) {
            [self resetOperation];
            [self resetFirstValue];
        }
        
        self.isNewValue = NO;
        
    } else if (self.labelCalculator.text.length == 1){
        
        [self resetLabel];
    }
}


//стереть все
- (void) operationAC {
    
    if (self.isButtonAC) {
        //удаляем все
        [self resetAll];

    
        
        
    } else if (!self.isNewValue) {
        //удаляем только последний ввод числа
        [self resetLabel];

        //устанавливаем АС
        self.isButtonAC = YES;
        //отправили сообщение если AC
        if (self.isButtonAC) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ButtonACDidChangeNotification
                                                                object:nil];
        }
        
        
    } else {
        //удаляем только последний ввод знака
        [self resetOperation];
        [self resetFirstValue];

        //устанавливаем АС
        self.isButtonAC = YES;
        //отправили сообщение если AC
        if (self.isButtonAC) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ButtonACDidChangeNotification
                                                                object:nil];
        }
    
    }
    
}


//смена знака
- (void) operationShift {
    
    double value = [[self parsingStringToValue:self.labelCalculator.text] doubleValue];
    double resultValue = 0;
    
    if (value < 0) {
        
        resultValue = value - (value * 2);
        
    } else {
        
        resultValue = value - (value * 2);
        
    }
    
    NSMutableString * string = [NSMutableString stringWithFormat:@"%f", resultValue];
    [self deleteZero: string];
    [self animationLabelText:[self parsingValueToString: string]];
    
    
    
}


//проценты
- (void) operationPercent {
    
    double value = [[self parsingStringToValue:self.labelCalculator.text] doubleValue];
    double percent;
    
    if (self.firstValue == 0) {
        percent = value * 0.01;
    } else {
        percent = value * 0.01 * self.firstValue;
    }
    
    NSMutableString * string = [NSMutableString stringWithFormat:@"%f", percent];
    [self deleteZero : string];
    [self animationLabelText:[self parsingValueToString: string]];
}



//деление
- (double) operationDivide{
    double result;
    result = self.firstValue / self.secondValue;
    
    return result;
}



//умножение
- (double) operationMultiply {
    double result;
    result = self.firstValue * self.secondValue;
    
    return result;
}


//минус
- (double) operationMinus {
    double result;
    result = self.firstValue - self.secondValue;
    
    return result;
}



//плюс
- (double) operationPlus {
    double result;
    result = self.firstValue + self.secondValue;
    
    return result;
}




- (void) operationEqual {
    
    if (!self.isNewValue & (self.button == 200) & (self.resultValue != 0.f)) {
        
        self.firstValue = [[self parsingStringToValue:self.labelCalculator.text] doubleValue];
        [self calculation];
        self.firstValue = self.resultValue;
        self.button = 200;
    
    
    } else if ((self.operation != 0) & (self.firstValue != 0.f) & !self.isNewValue) {
        //арифметическое применение равно
        [self operationsProcessing:200];
        self.button = 200;
        
        
    } else if ((self.operation != 0) & !self.isNewValue) {
        [self operationsProcessing:200];
        self.button = 200;
        

        
        
        
    } else if (self.secondValue != 0.f) {
        [self calculation];
        self.firstValue = self.resultValue;
        self.button = 200;
        
        
    } else if (self.firstValue != 0.f) {
        self.secondValue = self.firstValue;
        [self calculation];
        self.firstValue = self.resultValue;
        self.button = 200;
        
        
        
    } else if ([self.labelCalculator.text isEqualToString:@"0"]) {
        [self resetOperation];
        [self resetButton];
        
    } else if (![self.labelCalculator.text isEqualToString:@"0"]) {
        NSMutableString * string = [NSMutableString stringWithString: [self parsingStringToValue: self.labelCalculator.text]];
        [self deleteZero:string];
        [self animationLabelText:[self parsingValueToString: string]];
        
    }
    
    //разрешаем писать новое число
    self.isNewValue = YES;
    
}




#pragma mark - Parsing

//убираем нули float
- (void) deleteZero : (NSMutableString *) string {
    
    //если последняя цифра числа 0
    if ([string hasSuffix:@"0"]) {
        
        //убираем последний ноль и рекурсия
        [string deleteCharactersInRange: NSMakeRange(string.length - 1, 1)];
        [self deleteZero:string];
    }
    
    //если последний символ точка
    if ([string hasSuffix:@"."]) {
        
        //убираем последний символ
        [string deleteCharactersInRange: NSMakeRange(string.length - 1, 1)];
    }
}



//парсим число
- (NSString *) parsingStringToValue : (NSString *) string {
    
    NSString * value = [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
    NSString * resultValue = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return resultValue;
}


//замена точки запятой
- (NSString *) parsingValueToString : (NSString *) string {
    
    //создаем изменяемую строку
    NSMutableString * resultString = [[NSMutableString alloc] init];
    [resultString setString:string];
    
    //если есть точка заменим ее на запятую
    if ([resultString containsString:@"."]) {
        [resultString setString: [resultString stringByReplacingOccurrencesOfString:@"." withString:@","]];
        
        //если запятая имеет перед собой больше трех знаков, ставим пробелы
        if ([resultString rangeOfString:@","].location > 3) {
            [self calculateSpaceInString:resultString];
        }
        
        //если нет точки и длина больше трех символов
    } else if (resultString.length > 3) {
        [self calculateSpaceInString:resultString];
    }
    
    return resultString;
}



//рассчитываем пробелы во всей строке
- (void) calculateSpaceInString : (NSMutableString *) string {
    
    NSInteger length = 0;
    
    //если строка имеет запятую, узнаем ее положение
    if ([string containsString:@","]) {
        length = [string rangeOfString:@","].location;
        
        //иначе мы узнаем длину строки
    } else  {
        length = string.length;
    }
    
    //если дина числа больше трех знаков, или цифр перед запятой больше трех
    if (length > 3) {
        
        //поставим пробел в том месте
        [self addSpaceInLocation: string location:length];
    }
    
    //отправляем на поиски других пробелов
    [self addSpace:string];
}


//добавление пробелов в большие числа рекурсия
- (void) addSpace : (NSMutableString *) resultString {
    
    NSInteger position;
    //если содержит пробел то посчитаем его положение
    if ([resultString containsString:@" "]) {
        position = [resultString rangeOfString:@" "].location;
        
        //если нет то прсто длину строки
    } else {
        position = resultString.length;
    }
    
    //если поожение пробела или длина строки больше трех добавляем пробел
    if (position > 3) {
        [self addSpaceInLocation:resultString location:position];
    }
    
    //если строка содержит пробел точка входа которого больше 3 рекурсия
    if ([resultString containsString:@" "] & ([resultString rangeOfString:@" "].location  > 3)) {
        [self addSpace:resultString];
    }
}


//добавляем пробел в конкретное место
- (void) addSpaceInLocation : (NSMutableString *) string location : (NSUInteger) location {
    
    [string setString:[NSString stringWithFormat:@"%@ %@",
                       [string substringToIndex:location - 3],
                       [string substringFromIndex:location - 3]
                       ]];
}


//парсим все нули, запятые, минус
- (NSString *) parsingStringForLength : (NSString *) string {
    
    NSMutableString * value = [[NSMutableString alloc] init];
    [value setString:string];
    [value setString:[value stringByReplacingOccurrencesOfString:@"," withString:@"."]];
    [value setString:[value stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [value setString:[value stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    
    return value;
    
}





#pragma mark - Animation

//анимация когда нажимаем
- (void) animatedBackgroundColorDown : (UIButton *)sender {
    
    UIColor * backgroundColor = [[UIColor alloc] init];
    UIViewAnimationOptions option = UIViewAnimationOptionAllowUserInteraction;
    
    //цифры
    if (sender.tag <= 100) {
        backgroundColor = [self colorWithR:116 G:113 B:116];
        
        //операции
    } else if (sender.tag >= 200) {
        backgroundColor = [self colorWithR:234 G:232 B:235];
        //option = UIViewAnimationOptionCurveEaseInOut;
        
        //остальные
    } else {
        backgroundColor = [self colorWithR:219 G:217 B:220];
        
    }
    
    [UIView animateWithDuration:1.f
                          delay:0.f
                        options:option
                     animations:^{
                         sender.backgroundColor = backgroundColor;
                     }
                     completion:^(BOOL finished) {
                     }];
    
    
    
}


//анимация когда отпускаем
- (void) animatedBackgroundColorUp : (UIButton *)sender {
    
    UIColor * backgroundColor = [[UIColor alloc] init];
    UIViewAnimationOptions option = UIViewAnimationOptionAllowUserInteraction;
    
    //цифры
    if (sender.tag <= 100) {
        backgroundColor = [self colorWithR:51 G:51 B:51];
        
        //операции
    } else if (sender.tag >= 200) {
        backgroundColor = [self colorWithR:246 G:145 B:4];
        //option = UIViewAnimationOptionCurveEaseInOut ;
        
        //остальные
    } else {
        backgroundColor = [self colorWithR:166 G:166 B:166];
        
    }
    
    [UIView animateWithDuration:1.f
                          delay:0.f
                        options:option
                     animations:^{
                         sender.backgroundColor = backgroundColor;
                     }
                     completion:^(BOOL finished) {
                     }];
}











@end
