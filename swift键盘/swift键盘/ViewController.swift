//
//  ViewController.swift
//  swift键盘
//
//  Created by mazhongyi on 2025/7/17.
//

import UIKit

class ViewController: UIViewController {
    var customView: UIView!
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    var centerXConstraint: NSLayoutConstraint!
    var topConstraint: NSLayoutConstraint!
    var bottomConstraint: NSLayoutConstraint!
    var textField: UITextField!
    var textFieldBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let label = UILabel()
        label.text = "123456789"
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        print("页面宽度: \(self.view.frame.size.width), 高度: \(self.view.frame.size.height)")
        
        customView = UIView()
        customView.backgroundColor = UIColor.red
        customView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customView)
        
        topConstraint = customView.topAnchor.constraint(equalTo: view.topAnchor, constant: 135)
        bottomConstraint = customView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -135)
        // 修正customView左右约束
        leadingConstraint = customView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 190)
        trailingConstraint = customView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -190)
        widthConstraint = customView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        centerXConstraint = customView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint,
            bottomConstraint,
            leadingConstraint,
            trailingConstraint
        ])
        
        // 添加输入框
        textField = UITextField()
        textField.placeholder = "有什么问题尽管问"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.rightAnchor, constant: -50),
            textField.heightAnchor.constraint(equalToConstant: 52)
        ])
        textFieldBottomConstraint = textField.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -41)
        textFieldBottomConstraint.isActive = true
        // 添加UIScrollView和内容label
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 20),
            scrollView.leftAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.leftAnchor, constant: 10),
            scrollView.rightAnchor.constraint(equalTo: customView.safeAreaLayoutGuide.rightAnchor, constant: -10),
            scrollView.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -10)
        ])
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.text = "这里是可以无限多的内容，这里是可以无限多的内容，这里是可以无限多的内容，这里是可以无限多的内容，这里是可以无限多的内容，这里是可以无限多的内容，这里是可以无限多的内容，这里是可以无限多的内容，这里是可以无限多的内容，这里是可以无限多的内容。"
        contentLabel.font = UIFont.systemFont(ofSize: 18)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentLabel.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        if #available(iOS 11.0, *) {
            contentLabel.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        } else {
            contentLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        
        // 添加底部label
        let bottomLabel = UILabel()
        bottomLabel.text = "大模型"
        bottomLabel.font = UIFont.systemFont(ofSize: 16)
        bottomLabel.textColor = .white
        bottomLabel.textAlignment = .center
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        customView.addSubview(bottomLabel)
        NSLayoutConstraint.activate([
            bottomLabel.leftAnchor.constraint(equalTo: customView.leftAnchor),
            bottomLabel.rightAnchor.constraint(equalTo: customView.rightAnchor),
            bottomLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor),
            bottomLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // 监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let screenWidth = UIScreen.main.bounds.width
        let windowWidth = self.view.bounds.width

        if windowWidth < screenWidth {
            // 分屏：左右贴边
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
        } else {
            // 全屏：左右各190
            leadingConstraint.constant = 190
            trailingConstraint.constant = -190
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        let keyboardHeight = keyboardFrame.height
        // 顶部贴屏幕，底部贴键盘
        topConstraint.constant = 0
        bottomConstraint.constant = -keyboardHeight
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        // 恢复原始上下间距
        topConstraint.constant = 135
        bottomConstraint.constant = -135
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16), animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
