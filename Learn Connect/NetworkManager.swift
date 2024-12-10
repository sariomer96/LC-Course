import UIKit

class ToastManager {
    static let shared = ToastManager()

    private init() {}

    func showToast(message: String, buttonTitle: String, on controller: UIViewController, transitionTo viewController: UIViewController) {
        let toastContainer = UIView()
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 12
        toastContainer.clipsToBounds = true

        let toastStack = UIStackView()
        toastStack.axis = .vertical
        toastStack.alignment = .center
        toastStack.spacing = 8
        toastStack.translatesAutoresizingMaskIntoConstraints = false

        let toastLabel = UILabel()
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        toastLabel.text = message
        toastLabel.numberOfLines = 0

        let toastButton = UIButton(type: .system)
        toastButton.setTitle(buttonTitle, for: .normal)
        toastButton.setTitleColor(.white, for: .normal)
        toastButton.backgroundColor = UIColor.darkGray
        toastButton.layer.cornerRadius = 6
        toastButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)

        // Buton eylemi
        toastButton.addAction(UIAction { _ in
            if let navigationController = controller as? UINavigationController {
                navigationController.pushViewController(viewController, animated: true)
            } else {
                controller.present(viewController, animated: true, completion: nil)
            }
        }, for: .touchUpInside)

        toastStack.addArrangedSubview(toastLabel)
        toastStack.addArrangedSubview(toastButton)

        toastContainer.addSubview(toastStack)
        controller.view.addSubview(toastContainer)

        // Layout constraints
        toastStack.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Toast Container Constraints
            toastContainer.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor),
            toastContainer.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            toastContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 300),

            // Toast Stack Constraints
            toastStack.topAnchor.constraint(equalTo: toastContainer.topAnchor, constant: 16),
            toastStack.leadingAnchor.constraint(equalTo: toastContainer.leadingAnchor, constant: 16),
            toastStack.trailingAnchor.constraint(equalTo: toastContainer.trailingAnchor, constant: -16),
            toastStack.bottomAnchor.constraint(equalTo: toastContainer.bottomAnchor, constant: -16)
        ])

        // Animate Toast
        UIView.animate(withDuration: 0.5, animations: {
            toastContainer.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }) { _ in
                toastContainer.removeFromSuperview()
            }
        }
    }
}
