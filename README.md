# ZPAutoAdjustTextField
可以简单调节位置的textfield

###### 导入文件
<pre><code>
#import "ViewController.h"
#import "ZPAutoAdjustTextField.h"
#import "UIView+Extension.h"
</code></pre>

###### 使用方法

<pre><code>
- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *titleArr = @[@"用户名",@"密码",@"手机",@"邮箱",@"验证码",@"年龄",@"性别",@"省",@"市"];
    for (NSInteger i = 0; i < titleArr.count; i++) {
        ZPAutoAdjustTextField *field = [[ZPAutoAdjustTextField alloc]initWithFrame:CGRectMake(10, 50 * (i + 1), self.view.width - 20,30)];
        [self.view addSubview:field];
        [self.fieldArr addObject:field];
        field.backgroundColor = [UIColor orangeColor];
        field.placeholder   = titleArr[i];
        field.font   = [UIFont systemFontOfSize:14];
        field.delegate = self;
        __weak typeof(self)weakSelf = self;
        field.nextBlock = ^(UIBarButtonItem *item, ZPAutoAdjustTextField *textField){
            [weakSelf textField:textField nextBarButtonItemDidClicked:item];
        };
        field.previousBlock = ^(UIBarButtonItem *item, ZPAutoAdjustTextField *textField){
            [weakSelf textField:textField previousBarButtonItemDidClicked:item];
        };
    }

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)textField:(ZPAutoAdjustTextField *)textField nextBarButtonItemDidClicked:(UIBarButtonItem *)item
{
    NSInteger index = [_fieldArr indexOfObject:textField];
    if(index == _fieldArr.count - 1){
        [_fieldArr.firstObject becomeFirstResponder];
        return;
    }
    [_fieldArr[index + 1] becomeFirstResponder];
}

- (void)textField:(ZPAutoAdjustTextField *)textField previousBarButtonItemDidClicked:(UIBarButtonItem *)item
{
    NSInteger index = [_fieldArr indexOfObject:textField];
    if(index == 0){
        [_fieldArr.lastObject becomeFirstResponder];
        return;
    }
    
    [_fieldArr[index - 1] becomeFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ZPAutoAdjustTextField *field = (ZPAutoAdjustTextField *)textField;
    [field adjustTextFieldFrameWhenBeginEdtingWithView:self.view];
    return YES;
}

- (NSMutableArray *)fieldArr{
    if (_fieldArr == nil) {
        _fieldArr = [NSMutableArray array];
    }
    return _fieldArr;
}
</code></pre>

![](https://github.com/NewUnsigned/ZPAutoAdjustTextField/blob/master/ZPAutoAdjustTextField/2015-11-06%2014_23_43.gif)
