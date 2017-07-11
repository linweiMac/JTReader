//
//  CommentVC.swift
//  JTReader
//
//  Created by jiangT on 2017/6/30.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import EDStarRating
import SAMTextView

class CommentVC: JTBaseViewController {

    @IBOutlet var starRating: EDStarRating!
    @IBOutlet var topView: UIView!
    
    @IBOutlet var downView: UIView!
    
    @IBOutlet var bookShowView: UIView!
    @IBOutlet var bookImg: UIImageView!
    @IBOutlet var bookNameLbl: UILabel!
    @IBOutlet var bookCategoryLbl: UILabel!
    
    @IBOutlet var textView: SAMTextView!
    
    public var showBook : Book? {
        
        didSet {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.bookShowView.clipsToBounds = true
        self.bookShowView.layer.borderWidth = 1
        self.bookShowView.layer.borderColor = UIColor(r: 200, g: 200, b: 200).cgColor
        self.bookShowView.layer.cornerRadius = 5
        
        self.topView.clipsToBounds = true
        self.topView.layer.borderWidth = 1
        self.topView.layer.borderColor = UIColor(r: 200, g: 200, b: 200).cgColor

        self.topView.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.topView.layer.shadowColor = UIColor(r: 210, g: 210, b: 210).cgColor
        //初始化一些动画
        setAnimations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.starRating.backgroundColor = UIColor.clear
        self.starRating.starImage = UIImage.init(named: "comment_star")
        self.starRating.starHighlightedImage = UIImage.init(named: "comment_starL")
        self.starRating.maxRating = Int(5.0)
        self.starRating.horizontalMargin = 0
        self.starRating.editable = true
        self.starRating.displayMode = UInt(EDStarRatingDisplayAccurate)
        
        self.textView.placeholder = "点评这本书..."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backClick(_ sender: UIButton) {
        
        self.textView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.topView.transform = CGAffineTransform.init(translationX: 0, y: -70)
            self.downView.transform = CGAffineTransform.init(translationX: 0, y: kScreenH-64)
        }) { (Bool) in
            
            self.dismiss(animated: false) {
                
            }
            
        }
    }
    

}

extension CommentVC {
    
    func setAnimations () {
        
        self.topView.transform = CGAffineTransform.init(translationX: 0, y: -70)
        self.downView.transform = CGAffineTransform.init(translationX: 0, y: kScreenH-64)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.downView.transform = CGAffineTransform.identity
            self.topView.transform = CGAffineTransform.identity
        }) { (Bool) in
            self.textView.becomeFirstResponder()
        }

    }
    
    
}


/*
 //实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
 - (void)keyboardWasShown:(NSNotification*)aNotification
 {
 NSDictionary* info = [aNotification userInfo];
 //kbSize即為鍵盤尺寸 (有width, height)
 //获取高度
 NSValue *value = [info objectForKey:@"UIKeyboardBoundsUserInfoKey"];//关键的一句，网上关于获取键盘高度的解决办法，多到这句就over了。系统宏定义的UIKeyboardBoundsUserInfoKey等测试都不能获取正确的值。不知道为什么。。。
 
 CGSize kbSize = [value CGRectValue].size;
 NSLog(@"横屏%f",kbSize.height);
 
 // 获取键盘弹出的时间
 NSValue *animationDurationValue = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
 NSTimeInterval animationDuration;
 [animationDurationValue getValue:&animationDuration];
 
 [UIView animateWithDuration:animationDuration animations:^{
 self.contentView.transform = CGAffineTransformMakeTranslation(0, -kbSize.height/2);
 } completion:^(BOOL finished) {
 
 }];
 }
 
 //当键盘隐藏的时候
 - (void)keyboardWillBeHidden:(NSNotification*)aNotification
 {
 //do something
 [_textView resignFirstResponder];
 
 // 获取键盘弹出的时间
 NSValue *animationDurationValue = [[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
 NSTimeInterval animationDuration;
 [animationDurationValue getValue:&animationDuration];
 
 [UIView animateWithDuration:animationDuration animations:^{
 self.contentView.transform = CGAffineTransformIdentity;
 } completion:^(BOOL finished) {
 
 }];
 }
 
 //使用NSNotificationCenter 鍵盤出現時
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
 //使用NSNotificationCenter 鍵盤隐藏時
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
 
 */
