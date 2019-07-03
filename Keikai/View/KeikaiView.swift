//
//  KeikaiView.swift
//  Keikai
//
//  Created by Aashish Tamsya on 03/07/19.
//  Copyright © 2019 Aashish Tamsya. All rights reserved.
//

import Foundation

public typealias ActionCompletion = (_ snackbar: KeikaiView) -> Void
public typealias DismissCompletion = (_ snackbar: KeikaiView) -> Void
public typealias SwipeCompletion = (_ snackbar: KeikaiView, _ direction: UISwipeGestureRecognizer.Direction) -> Void

open class KeikaiView: UIView {
  fileprivate static let defaultFrame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 44)
  fileprivate static let snackbarMinHeight: CGFloat = 44
  fileprivate static let snackbarIconImageViewWidth: CGFloat = 32
  
  fileprivate var contentView: UIView!
  fileprivate var iconImageView: UIImageView!
  fileprivate var messageLabel: UILabel!
  fileprivate var separateView: UIView!
  fileprivate var actionButton: UIButton!
  fileprivate var secondActionButton: UIButton!
  fileprivate var activityIndicatorView: UIActivityIndicatorView!
  
  fileprivate var dismissTimer: Timer?
  fileprivate var keyboardIsShown: Bool = false
  fileprivate var keyboardHeight: CGFloat = 0
  
  fileprivate var leftMarginConstraint: NSLayoutConstraint?
  fileprivate var rightMarginConstraint: NSLayoutConstraint?
  fileprivate var bottomMarginConstraint: NSLayoutConstraint?
  fileprivate var topMarginConstraint: NSLayoutConstraint? // Only work when top animation type
  fileprivate var centerXConstraint: NSLayoutConstraint?
  
  fileprivate var iconImageViewWidthConstraint: NSLayoutConstraint?
  fileprivate var actionButtonMaxWidthConstraint: NSLayoutConstraint?
  fileprivate var secondActionButtonMaxWidthConstraint: NSLayoutConstraint?
  
  fileprivate var contentViewLeftConstraint: NSLayoutConstraint?
  fileprivate var contentViewRightConstraint: NSLayoutConstraint?
  fileprivate var contentViewTopConstraint: NSLayoutConstraint?
  fileprivate var contentViewBottomConstraint: NSLayoutConstraint?
  
  open var onTapBlock: ActionCompletion?
  open var onSwipeBlock: SwipeCompletion?
  open var actionBlock: ActionCompletion?
  open var secondActionBlock: ActionCompletion?
  open var dismissBlock: DismissCompletion?

  open var shouldDismissOnSwipe: Bool = false
  open var shouldActivateLeftAndRightMarginOnCustomContentView: Bool = false
  open var duration = Duration.short
  open var animationType = AnimationType.slideFromBottomBackToBottom
  open var animationDuration: TimeInterval = 0.3
  
  open var cornerRadius: CGFloat = 2 {
    didSet {
      if cornerRadius < 0 {
        cornerRadius = 0
      }
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = true
    }
  }
  
  open var leftMargin: CGFloat = 16 {
    didSet {
      leftMarginConstraint?.constant = leftMargin
      superview?.layoutIfNeeded()
    }
  }
  
  open var rightMargin: CGFloat = 16 {
    didSet {
      rightMarginConstraint?.constant = -rightMargin
      superview?.layoutIfNeeded()
    }
  }

  open var bottomMargin: CGFloat = 64 {
    didSet {
      bottomMarginConstraint?.constant = -bottomMargin
      superview?.layoutIfNeeded()
    }
  }
  
  open var topMargin: CGFloat = 16 {
    didSet {
      topMarginConstraint?.constant = topMargin
      superview?.layoutIfNeeded()
    }
  }

  open var contentInset: UIEdgeInsets = UIEdgeInsets.init(top: 16, left: 48, bottom: 16, right: 48) {
    didSet {
      contentViewTopConstraint?.constant = contentInset.top
      contentViewBottomConstraint?.constant = -contentInset.bottom
      contentViewLeftConstraint?.constant = contentInset.left
      contentViewRightConstraint?.constant = -contentInset.right
      layoutIfNeeded()
      superview?.layoutIfNeeded()
    }
  }
  
  open var message: String = "" {
    didSet {
      messageLabel.text = message
    }
  }
  
  open var messageTextColor: UIColor = .white {
    didSet {
      messageLabel.textColor = messageTextColor
    }
  }
  
  open var messageTextFont: UIFont = UIFont.systemFont(ofSize: 14) {
    didSet {
      messageLabel.font = messageTextFont
    }
  }
  
  open var messageTextAlign: NSTextAlignment = .center {
    didSet {
      messageLabel.textAlignment = messageTextAlign
    }
  }
  
  open var actionText: String = "" {
    didSet {
      actionButton.setTitle(actionText, for: UIControl.State())
    }
  }
  
  open var actionIcon: UIImage? = nil {
    didSet {
      actionButton.setImage(actionIcon, for: UIControl.State())
    }
  }
  
  open var secondActionText: String = "" {
    didSet {
      secondActionButton.setTitle(secondActionText, for: UIControl.State())
    }
  }
  
  open var actionTextColor: UIColor = .white {
    didSet {
      actionButton.setTitleColor(actionTextColor, for: UIControl.State())
    }
  }
  
  open var secondActionTextColor: UIColor = .white {
    didSet {
      secondActionButton.setTitleColor(secondActionTextColor, for: UIControl.State())
    }
  }
  
  open var actionTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
    didSet {
      actionButton.titleLabel?.font = actionTextFont
    }
  }
  
  open var secondActionTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
    didSet {
      secondActionButton.titleLabel?.font = secondActionTextFont
    }
  }
  
  open var actionMaxWidth: CGFloat = 64 {
    didSet {
      actionMaxWidth = actionMaxWidth < 44 ? 44 : actionMaxWidth
      actionButtonMaxWidthConstraint?.constant = actionButton.isHidden ? 0 : actionMaxWidth
      secondActionButtonMaxWidthConstraint?.constant = secondActionButton.isHidden ? 0 : actionMaxWidth
      layoutIfNeeded()
    }
  }

  open var actionTextNumberOfLines: Int = 1 {
    didSet {
      actionButton.titleLabel?.numberOfLines = actionTextNumberOfLines
      secondActionButton.titleLabel?.numberOfLines = actionTextNumberOfLines
      layoutIfNeeded()
    }
  }
  
  open var icon: UIImage? = nil {
    didSet {
      iconImageView.image = icon
    }
  }
  
  open var iconContentMode: UIView.ContentMode = .center {
    didSet {
      iconImageView.contentMode = iconContentMode
    }
  }
  
  open var containerView: UIView?
  open var customContentView: UIView?
  
  open var separateViewBackgroundColor: UIColor = .gray {
    didSet {
      separateView.backgroundColor = separateViewBackgroundColor
    }
  }
  
  open var activityIndicatorViewStyle: UIActivityIndicatorView.Style {
    get {
      return activityIndicatorView.style
    }
    set {
      activityIndicatorView.style = newValue
    }
  }
  
  open var activityIndicatorViewColor: UIColor {
    get {
      return activityIndicatorView.color ?? .white
    }
    set {
      activityIndicatorView.color = newValue
    }
  }
  
  open var shouldDropShadow: Bool = false {
    didSet {
      dropShadow()
    }
  }
  
  open var animationSpringWithDamping: CGFloat = 0.7
  open var animationInitialSpringVelocity: CGFloat = 5

  open override func layoutSubviews() {
    super.layoutSubviews()
    if messageLabel.preferredMaxLayoutWidth != messageLabel.frame.size.width {
      messageLabel.preferredMaxLayoutWidth = messageLabel.frame.size.width
      setNeedsLayout()
    }
    super.layoutSubviews()
  }
  // MARK: - Initializer Methods
  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override init(frame: CGRect) {
    super.init(frame: KeikaiView.defaultFrame)
    configure()
  }
  
  public init() {
    super.init(frame: KeikaiView.defaultFrame)
    configure()
  }
  
  public init(message: String, duration: Duration) {
    super.init(frame: KeikaiView.defaultFrame)
    self.duration = duration
    self.message = message
    configure()
  }
  
  public init(customContentView: UIView, duration: Duration) {
    super.init(frame: KeikaiView.defaultFrame)
    self.duration = duration
    self.customContentView = customContentView
    configure()
  }
  
  public init(message: String, duration: Duration, actionText: String, actionBlock: @escaping ActionCompletion) {
    super.init(frame: KeikaiView.defaultFrame)
    self.duration = duration
    self.message = message
    self.actionText = actionText
    self.actionBlock = actionBlock
    configure()
  }
  
  public init(message: String, duration: Duration, actionText: String, messageFont: UIFont, actionTextFont: UIFont, actionBlock: @escaping ActionCompletion) {
    super.init(frame: KeikaiView.defaultFrame)
    self.duration = duration
    self.message = message
    self.actionText = actionText
    self.actionBlock = actionBlock
    self.messageTextFont = messageFont
    self.actionTextFont = actionTextFont
    configure()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
}
// MARK: - Show methods.
public extension KeikaiView {
   func show() {
    if superview != nil {  return } // Only show once
    dismissTimer = Timer(timeInterval: (TimeInterval)(duration.rawValue), target: self, selector: #selector(dismiss), userInfo: nil, repeats: false) // Create dismiss timer
    RunLoop.main.add(dismissTimer!, forMode: .common)
    iconImageView.isHidden = icon == nil
    actionButton.isHidden = (actionIcon == nil || actionText.isEmpty) == false || actionBlock == nil
    secondActionButton.isHidden = secondActionText.isEmpty || secondActionBlock == nil
    separateView.isHidden = actionButton.isHidden
    iconImageViewWidthConstraint?.constant = iconImageView.isHidden ? 0 : KeikaiView.snackbarIconImageViewWidth
    actionButtonMaxWidthConstraint?.constant = actionButton.isHidden ? 0 : actionMaxWidth
    secondActionButtonMaxWidthConstraint?.constant = secondActionButton.isHidden ? 0 : actionMaxWidth
    addConstraintsToView()
    getSuperViewToShow()
  }
  
  func addConstraintsToView() {
    let finalContentView = customContentView ?? contentView
    finalContentView?.translatesAutoresizingMaskIntoConstraints = false
    addSubview(finalContentView!)
    contentViewTopConstraint = NSLayoutConstraint(item: finalContentView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: contentInset.top)
    contentViewBottomConstraint = NSLayoutConstraint(item: finalContentView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -contentInset.bottom)
    contentViewLeftConstraint = NSLayoutConstraint(item: finalContentView!, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: contentInset.left)
    contentViewRightConstraint = NSLayoutConstraint(item: finalContentView!, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -contentInset.right)
    addConstraints([contentViewTopConstraint!, contentViewBottomConstraint!, contentViewLeftConstraint!, contentViewRightConstraint!])
  }
  
  fileprivate func getSuperViewToShow() {
    guard let superView = containerView ?? UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow else {
      fatalError("KeiKaiView needs a keyWindows to display.")
    }
    superView.addSubview(self)
    // Left margin constraint
    if #available(iOS 11.0, *) {
      leftMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .left, relatedBy: .equal,
        toItem: superView.safeAreaLayoutGuide, attribute: .left, multiplier: 1, constant: leftMargin)
    } else {
      leftMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .left, relatedBy: .equal,
        toItem: superView, attribute: .left, multiplier: 1, constant: leftMargin)
    }
    
    // Right margin constraint
    if #available(iOS 11.0, *) {
      rightMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .right, relatedBy: .equal,
        toItem: superView.safeAreaLayoutGuide, attribute: .right, multiplier: 1, constant: -rightMargin)
    } else {
      rightMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .right, relatedBy: .equal,
        toItem: superView, attribute: .right, multiplier: 1, constant: -rightMargin)
    }
    
    // Bottom margin constraint
    if #available(iOS 11.0, *) {
      bottomMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .bottom, relatedBy: .equal,
        toItem: superView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -bottomMargin)
    } else {
      bottomMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .bottom, relatedBy: .equal,
        toItem: superView, attribute: .bottom, multiplier: 1, constant: -bottomMargin)
    }
    // Top margin constraint
    if #available(iOS 11.0, *) {
      topMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .top, relatedBy: .equal,
        toItem: superView.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: topMargin)
    } else {
      topMarginConstraint = NSLayoutConstraint.init(
        item: self, attribute: .top, relatedBy: .equal,
        toItem: superView, attribute: .top, multiplier: 1, constant: topMargin)
    }
    
    // Center X constraint
    centerXConstraint = NSLayoutConstraint.init(
      item: self, attribute: .centerX, relatedBy: .equal,
      toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)
    
    // Min height constraint
    let minHeightConstraint = NSLayoutConstraint.init(
      item: self, attribute: .height, relatedBy: .greaterThanOrEqual,
      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: KeikaiView.snackbarMinHeight)
    
    // Avoid the "UIView-Encapsulated-Layout-Height" constraint conflicts
    // http://stackoverflow.com/questions/25059443/what-is-nslayoutconstraint-uiview-encapsulated-layout-height-and-how-should-i
    leftMarginConstraint?.priority = UILayoutPriority(999)
    rightMarginConstraint?.priority = UILayoutPriority(999)
    topMarginConstraint?.priority = UILayoutPriority(999)
    bottomMarginConstraint?.priority = UILayoutPriority(999)
    centerXConstraint?.priority = UILayoutPriority(999)
    
    // Add constraints
    superView.addConstraint(leftMarginConstraint!)
    superView.addConstraint(rightMarginConstraint!)
    superView.addConstraint(bottomMarginConstraint!)
    superView.addConstraint(topMarginConstraint!)
    superView.addConstraint(centerXConstraint!)
    superView.addConstraint(minHeightConstraint)
    
    // Active or deactive
    topMarginConstraint?.isActive = false // For top animation
    leftMarginConstraint?.isActive = self.shouldActivateLeftAndRightMarginOnCustomContentView ? true : customContentView == nil
    rightMarginConstraint?.isActive = self.shouldActivateLeftAndRightMarginOnCustomContentView ? true : customContentView == nil
    centerXConstraint?.isActive = customContentView != nil
    
    // Show
    showWithAnimation()
  }
  
  fileprivate func showWithAnimation() {
    var animationBlock: (() -> Void)?
    let superViewWidth = (superview?.frame)!.width
    let snackbarHeight = systemLayoutSizeFitting(.init(width: superViewWidth - leftMargin - rightMargin, height: KeikaiView.snackbarMinHeight)).height
    
    switch animationType {
      
    case .fadeInFadeOut:
      alpha = 0.0
      // Animation
      animationBlock = {
        self.alpha = 1.0
      }
      
    case .slideFromBottomBackToBottom, .slideFromBottomToTop:
      bottomMarginConstraint?.constant = snackbarHeight
      
    case .slideFromLeftToRight:
      leftMarginConstraint?.constant = leftMargin - superViewWidth
      rightMarginConstraint?.constant = -rightMargin - superViewWidth
      bottomMarginConstraint?.constant = -bottomMargin
      centerXConstraint?.constant = -superViewWidth
      
    case .slideFromRightToLeft:
      leftMarginConstraint?.constant = leftMargin + superViewWidth
      rightMarginConstraint?.constant = -rightMargin + superViewWidth
      bottomMarginConstraint?.constant = -bottomMargin
      centerXConstraint?.constant = superViewWidth
      
    case .slideFromTopBackToTop, .slideFromTopToBottom:
      bottomMarginConstraint?.isActive = false
      topMarginConstraint?.isActive = true
      topMarginConstraint?.constant = -snackbarHeight
    }
    
    // Update init state
    superview?.layoutIfNeeded()
    
    // Final state
    bottomMarginConstraint?.constant = -bottomMargin
    topMarginConstraint?.constant = topMargin
    leftMarginConstraint?.constant = leftMargin
    rightMarginConstraint?.constant = -rightMargin
    centerXConstraint?.constant = 0
    
    UIView.animate(withDuration: animationDuration, delay: 0,
                   usingSpringWithDamping: animationSpringWithDamping,
                   initialSpringVelocity: animationInitialSpringVelocity, options: .allowUserInteraction,
                   animations: {
                    () -> Void in
                    animationBlock?()
                    self.superview?.layoutIfNeeded()
    }, completion: nil)
  }
}
// MARK: - Selectors
private extension KeikaiView {
  @objc func dismiss() {
    DispatchQueue.main.async { [weak self] in
      self?.dismissAnimated(true)
    }
  }
  
  @objc func onScreenRotateNotification() {
    messageLabel.preferredMaxLayoutWidth = messageLabel.frame.size.width
    layoutIfNeeded()
  }
  
  @objc func onKeyboardShow(_ notification: Notification?) {
    if keyboardIsShown { return }
    keyboardIsShown = true
    guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
    if #available(iOS 11.0, *) {
      keyboardHeight = keyboardFrame.cgRectValue.height - self.safeAreaInsets.bottom
    } else {
      keyboardHeight = keyboardFrame.cgRectValue.height
    }
    keyboardHeight += 8
    bottomMargin += keyboardHeight
    UIView.animate(withDuration: 0.3) {
      self.superview?.layoutIfNeeded()
    }
  }
  
  @objc func onKeyboardHide(_ notification: Notification?) {
    if !keyboardIsShown { return }
    keyboardIsShown = false
    bottomMargin -= keyboardHeight
    UIView.animate(withDuration: 0.3) {
      self.superview?.layoutIfNeeded()
    }
  }
  
  @objc func doAction(_ button: UIButton) {
    button == actionButton ? actionBlock?(self) : secondActionBlock?(self) // Call action block first
    if duration == .forever && actionButton.isHidden == false { // Show activity indicator
      actionButton.isHidden = true
      secondActionButton.isHidden = true
      separateView.isHidden = true
      activityIndicatorView.isHidden = false
      activityIndicatorView.startAnimating()
    } else {
      dismissAnimated(true)
    }
  }
  
  @objc func didTapSelf() {
    self.onTapBlock?(self)
  }
  
  @objc func didSwipeSelf(_ gesture: UISwipeGestureRecognizer) {
    self.onSwipeBlock?(self, gesture.direction)
    
    if self.shouldDismissOnSwipe {
      if gesture.direction == .right {
        self.animationType = .slideFromLeftToRight
      } else if gesture.direction == .left {
        self.animationType = .slideFromRightToLeft
      } else if gesture.direction == .up {
        self.animationType = .slideFromTopBackToTop
      } else if gesture.direction == .down {
        self.animationType = .slideFromTopBackToTop
      }
      self.dismiss()
    }
  }
}
// MARK: - Dismiss methods.
private extension KeikaiView {
  func dismissAnimated(_ animated: Bool) { // swiftlint:disable:this cyclomatic_complexity
    if dismissTimer == nil { // If the dismiss timer is nil, snackbar is dismissing or not ready to dismiss.
      return
    }
    invalidDismissTimer()
    activityIndicatorView.stopAnimating()
    let superViewWidth = (superview?.frame)!.width
    let snackbarHeight = frame.size.height
    var safeAreaInsets = UIEdgeInsets.zero
    if #available(iOS 11.0, *) {
      safeAreaInsets = self.superview?.safeAreaInsets ?? UIEdgeInsets.zero
    }
    if !animated {
      dismissBlock?(self)
      removeFromSuperview()
      return
    }
    var animationBlock: (() -> Void)?
    switch animationType {
    case .fadeInFadeOut:
      animationBlock = {
        self.alpha = 0.0
      }
      
    case .slideFromBottomBackToBottom:
      bottomMarginConstraint?.constant = snackbarHeight + safeAreaInsets.bottom
    case .slideFromBottomToTop:
      animationBlock = {
        self.alpha = 0.0
      }
      bottomMarginConstraint?.constant = -snackbarHeight - bottomMargin
    case .slideFromLeftToRight:
      leftMarginConstraint?.constant = leftMargin + superViewWidth + safeAreaInsets.left
      rightMarginConstraint?.constant = -rightMargin + superViewWidth - safeAreaInsets.right
      centerXConstraint?.constant = superViewWidth
    case .slideFromRightToLeft:
      leftMarginConstraint?.constant = leftMargin - superViewWidth + safeAreaInsets.left
      rightMarginConstraint?.constant = -rightMargin - superViewWidth - safeAreaInsets.right
      centerXConstraint?.constant = -superViewWidth
    case .slideFromTopToBottom:
      topMarginConstraint?.isActive = false
      bottomMarginConstraint?.isActive = true
      bottomMarginConstraint?.constant = snackbarHeight + safeAreaInsets.bottom
    case .slideFromTopBackToTop:
      topMarginConstraint?.constant = -snackbarHeight - safeAreaInsets.top
    }
    setNeedsLayout()
    UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: animationSpringWithDamping, initialSpringVelocity: animationInitialSpringVelocity, options: .curveEaseIn, animations: { [weak self] in
      animationBlock?()
      self?.superview?.layoutIfNeeded()
    }, completion: { [weak self] _ in
      guard let strongSelf = self else { return }
      strongSelf.dismissBlock?(strongSelf)
      strongSelf.removeFromSuperview()
    })
  }
  
  func invalidDismissTimer() {
    dismissTimer?.invalidate()
    dismissTimer = nil
  }
}

// MARK: - Private Methods
private extension KeikaiView {
  func configure() {
    subviews.forEach { $0.removeFromSuperview() } // Clear subViews
    registerNotifications()
    setupViews()
    addConstraints()
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapSelf)))
    self.isUserInteractionEnabled = true
    [UISwipeGestureRecognizer.Direction.up, .down, .left, .right].forEach { (direction) in
      let gesture = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeSelf(_:)))
      gesture.direction = direction
      self.addGestureRecognizer(gesture)
    }
  }
  
  func dropShadow() {
    layer.shadowOpacity = 0.4
    layer.shadowRadius  = 2
    layer.shadowColor   = UIColor.black.cgColor
    layer.shadowOffset  = CGSize(width: 0, height: 2)
  }
  
  func registerNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(onScreenRotateNotification), name: UIDevice.orientationDidChangeNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func setupViews() {
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor                           = #colorLiteral(red: 0.337254902, green: 0.7411764706, blue: 0.3568627451, alpha: 1)
    layer.cornerRadius                        = cornerRadius
    layer.shouldRasterize                     = true
    layer.rasterizationScale                  = UIScreen.main.scale
    
    contentView                                           = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.frame                                     = KeikaiView.defaultFrame
    contentView.backgroundColor                           = .clear
    
    iconImageView                                           = UIImageView()
    iconImageView.translatesAutoresizingMaskIntoConstraints = false
    iconImageView.backgroundColor                           = .clear
    iconImageView.contentMode                               = iconContentMode
    contentView.addSubview(iconImageView)
    
    messageLabel = UILabel()
    messageLabel.accessibilityIdentifier                   = "messageLabel"
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.textColor                                 = .white
    messageLabel.font                                      = messageTextFont
    messageLabel.backgroundColor                           = .clear
    messageLabel.lineBreakMode                             = .byTruncatingTail
    messageLabel.numberOfLines                             = 0
    messageLabel.textAlignment                             = .left
    messageLabel.text                                      = message
    contentView.addSubview(messageLabel)
    
    actionButton = UIButton()
    actionButton.accessibilityIdentifier                   = "actionButton"
    actionButton.translatesAutoresizingMaskIntoConstraints = false
    actionButton.backgroundColor                           = .clear
    actionButton.contentEdgeInsets                         = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    actionButton.titleLabel?.font                          = actionTextFont
    actionButton.titleLabel?.adjustsFontSizeToFitWidth     = true
    actionButton.titleLabel?.numberOfLines                 = actionTextNumberOfLines
    actionButton.setTitle(actionText, for: UIControl.State())
    actionButton.setTitleColor(actionTextColor, for: UIControl.State())
    actionButton.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
    contentView.addSubview(actionButton)
    
    secondActionButton = UIButton()
    secondActionButton.accessibilityIdentifier                   = "secondActionButton"
    secondActionButton.translatesAutoresizingMaskIntoConstraints = false
    secondActionButton.backgroundColor                           = .clear
    secondActionButton.contentEdgeInsets                         = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    secondActionButton.titleLabel?.font                          = secondActionTextFont
    secondActionButton.titleLabel?.adjustsFontSizeToFitWidth     = true
    secondActionButton.titleLabel?.numberOfLines                 = actionTextNumberOfLines
    secondActionButton.setTitle(secondActionText, for: UIControl.State())
    secondActionButton.setTitleColor(secondActionTextColor, for: UIControl.State())
    secondActionButton.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
    contentView.addSubview(secondActionButton)
    
    separateView = UIView()
    separateView.translatesAutoresizingMaskIntoConstraints = false
    separateView.backgroundColor                           = separateViewBackgroundColor
    contentView.addSubview(separateView)
    
    activityIndicatorView = UIActivityIndicatorView(style: .white)
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    activityIndicatorView.stopAnimating()
    contentView.addSubview(activityIndicatorView)
  }
  
  func addConstraints() {
    let hConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[iconImageView]-2-[messageLabel]-2-[seperateView(0.5)]-2-[actionButton(>=44@999)]-0-[secondActionButton(>=44@999)]-0-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: ["iconImageView": iconImageView as Any, "messageLabel": messageLabel as Any, "seperateView": separateView as Any, "actionButton": actionButton as Any, "secondActionButton": secondActionButton as Any])
    
    let vConstraintsForIconImageView = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-2-[iconImageView]-2-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: ["iconImageView": iconImageView as Any])
    
    let vConstraintsForMessageLabel = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[messageLabel]-0-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: ["messageLabel": messageLabel as Any])
    
    let vConstraintsForSeperateView = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-4-[seperateView]-4-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: ["seperateView": separateView as Any])
    
    let vConstraintsForActionButton = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[actionButton]-0-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: ["actionButton": actionButton as Any])
    
    let vConstraintsForSecondActionButton = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[secondActionButton]-0-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: ["secondActionButton": secondActionButton as Any])
    
    iconImageViewWidthConstraint = NSLayoutConstraint.init(
      item: iconImageView as Any, attribute: .width, relatedBy: .equal,
      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: KeikaiView.snackbarIconImageViewWidth)
    
    actionButtonMaxWidthConstraint = NSLayoutConstraint.init(
      item: actionButton as Any, attribute: .width, relatedBy: .lessThanOrEqual,
      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: actionMaxWidth)
    
    secondActionButtonMaxWidthConstraint = NSLayoutConstraint.init(
      item: secondActionButton as Any, attribute: .width, relatedBy: .lessThanOrEqual,
      toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: actionMaxWidth)
    
    let vConstraintForActivityIndicatorView = NSLayoutConstraint.init(
      item: activityIndicatorView as Any, attribute: .centerY, relatedBy: .equal,
      toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)
    
    let hConstraintsForActivityIndicatorView = NSLayoutConstraint.constraints(
      withVisualFormat: "H:[activityIndicatorView]-2-|",
      options: NSLayoutConstraint.FormatOptions(rawValue: 0),
      metrics: nil,
      views: ["activityIndicatorView": activityIndicatorView as Any])
    
    iconImageView.addConstraint(iconImageViewWidthConstraint!)
    actionButton.addConstraint(actionButtonMaxWidthConstraint!)
    secondActionButton.addConstraint(secondActionButtonMaxWidthConstraint!)
    
    contentView.addConstraints(hConstraints)
    contentView.addConstraints(vConstraintsForIconImageView)
    contentView.addConstraints(vConstraintsForMessageLabel)
    contentView.addConstraints(vConstraintsForSeperateView)
    contentView.addConstraints(vConstraintsForActionButton)
    contentView.addConstraints(vConstraintsForSecondActionButton)
    contentView.addConstraint(vConstraintForActivityIndicatorView)
    contentView.addConstraints(hConstraintsForActivityIndicatorView)
    
    messageLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
    messageLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
    
    actionButton.setContentHuggingPriority(UILayoutPriority(998), for: .horizontal)
    actionButton.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
    secondActionButton.setContentHuggingPriority(UILayoutPriority(998), for: .horizontal)
    secondActionButton.setContentCompressionResistancePriority(UILayoutPriority(999), for: .horizontal)
  }
}
