//
//  ModernHUD.swift
//  ModernHUD
//
//  Created by Daniil on 10.01.2024.
//

import UIKit

@objc(MHModernHud)
open class ModernHUD: UIView {
    /// Определяет стиль индикатора
    ///
    /// - .spinner показывает спиннер и текст (если есть)
    /// - .textOnly показывает только текст
    @objc(MHModernHudStyle)
    public enum Style: Int {
        case arc = 0
        case arcRotate = 1
        case textOnly = 2
    }

    /// Устанавливает прогресс спиннера
    ///
    /// По умолчанию, установлен на 0.75.
    @objc open var progress: CGFloat {
        get {
            progressView.progress
        }
        set {
            setProgress(newValue, animated: false)
        }
    }

    /// Устанавливает стиль индикатора.
    @objc open var style: Style = .arcRotate {
        didSet {
            updateProgressView()
        }
    }

    /// Устанавливает основной текст в индикатор.
    ///
    /// Для скрытия должен быть установлен в nil.
    @objc open var text: String? {
        didSet {
            setText(text, for: textLabel)
        }
    }

    /// Устанавливает дополнительный текст в индикатор.
    ///
    /// Для скрытия должен быть установлен в nil.
    @objc open var detailedText: String? {
        didSet {
            setText(detailedText, for: detailedTextLabel)
        }
    }

    /// Стиль заднего размытия
    ///
    /// По умолчанию, UIBlurEffectStyleSystemThickMaterial
    @objc open var blurStyle: UIBlurEffect.Style = .systemThickMaterial {
        didSet {
            blurView.effect = UIBlurEffect(style: blurStyle)
        }
    }

    @objc open var cornerRadius: CGFloat = 24.0 {
        didSet {
            blurView.layer.cornerRadius = cornerRadius
        }
    }

    private lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = cornerRadius
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .init(white: 1.0, alpha: 0.3)

        view.contentView.layoutMargins = UIEdgeInsets(top: 24.0, left: 24.0, bottom: 24.0, right: 24.0)

        return view
    }()

    private lazy var progressView: CircularProgressView = {
        CircularProgressView(frame: CGRect(x: 0.0, y: 0.0, width: 66.0, height: 66.0))
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)

        return label
    }()

    private lazy var detailedTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)

        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [progressView, textLabel, detailedTextLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 10.0
        view.setCustomSpacing(24.0, after: progressView)

        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: .zero)

        tintColor = .systemGray

        layer.shadowOpacity = 0.2
        layer.shadowRadius = 10.0
        layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
        layer.shadowColor = UIColor.black.cgColor

        let blurContent = blurView.contentView
        let blurContentMargins = blurContent.layoutMarginsGuide

        blurContent.addSubview(stackView)
        addSubview(blurView)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: blurContentMargins.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: blurContentMargins.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: blurContentMargins.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: blurContentMargins.trailingAnchor)
        ])
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Выполняет показ индикатора на видимом окне UIWindow.
    ///
    /// - Returns: Возвращает экземпляр индикатора для дальнейшей настройки.
    @objc
    public static func show() -> Self? {
        guard
            let scene = UIWindow.focusedScene,
            let keyWindow = scene.windows.first(where: { $0.isKeyWindow })
        else { return nil }

        let hud = Self()
        hud.show(on: keyWindow, animated: true)

        return hud
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        layer.shadowPath = CGPath(
            roundedRect: bounds,
            cornerWidth: cornerRadius,
            cornerHeight: cornerRadius,
            transform: nil
        )
    }

    override open func tintColorDidChange() {
        super.tintColorDidChange()

        progressView.tintColor = tintColor
    }

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()

        if let superview {
            translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])

            updateProgressView()
        }
    }

    // MARK: - Public methods

    /// Выполняет показ индикатора на окне.
    /// - Parameters:
    ///   - view: Представление, на котором необходимо показать индикатор.
    ///   - animated: Если флаг установлен в YES, выполняется с анимацией. В противном случае - без.
    @objc
    open func show(on view: UIView, animated: Bool = true) {
        if animated {
            alpha = 0.0
            view.addSubview(self)

            UIView.animate(withDuration: 0.25) { [self] in
                alpha = 1.0
            }
        } else {
            view.addSubview(self)
        }
    }

    /// Выполняет скрытие индикатора.
    /// - Parameter animated: Если флаг установлен в YES, выполняется с анимацией. В противном случае - без.
    @objc
    open func hide(_ animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5) { [self] in
                alpha = 0.0
            } completion: { [self] _ in
                progressView.stopAnimation()
                removeFromSuperview()
            }
        } else {
            progressView.stopAnimation()
            removeFromSuperview()
        }
    }

    /// Выполняет анимированное скрытие индикатора с задержкой.
    /// - Parameter delay: Время перед скрытием индикатора.
    @objc
    open func hide(delay: CGFloat, animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
            hide(animated)
        }
    }

    /// Устанавливает прогресс спиннера.
    /// - Parameters:
    ///   - progress: Значение прогресса от 0 до 1
    ///   - animated: Если задан YES, то прогресс будет установлен с анимацией. В противном случае - без.
    @objc
    open func setProgress(_ progress: CGFloat, animated: Bool) {
        progressView.setProgress(progress, animated: animated)
    }

    // MARK: - Private methods

    private func updateProgressView() {
        let isAlreadyAnimating = progressView.isAnimating

        switch style {
        case .arc:
            progressView.animationStyle = .arc
            progressView.runAnimation()

        case .arcRotate:
            progressView.animationStyle = .arcRotate
            progressView.runAnimation()

        default:
            progressView.stopAnimation()
        }

        if isAlreadyAnimating != progressView.isAnimating {
            progressView.invalidateIntrinsicContentSize()
        }
    }

    private func setText(_ text: String?, for label: UILabel) {
        let textTransition = CATransition()
        textTransition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        textTransition.type = .fade
        textTransition.duration = 0.5
        label.layer.add(textTransition, forKey: "textChangeAnimation")
        label.text = text
    }
}
