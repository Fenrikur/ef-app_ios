import UIKit

class MapDetailViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate, MapDetailScene {

    // MARK: Nested Types

    private struct Segues {
        static let ShowContextualPopup = "ShowContextualPopup"
    }

    // MARK: Properties

    @IBOutlet private weak var scrollView: UIScrollView!
    private var imageView: UIImageView?

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        delegate?.mapDetailSceneDidLoad()
    }

    // MARK: Actions

    @IBAction private func scrollViewTapped(_ sender: UIGestureRecognizer) {
        let tapLocation = sender.location(in: imageView)
        let position = MapCoordinate(x: Float(tapLocation.x), y: Float(tapLocation.y))
        delegate?.mapDetailSceneDidTapMap(at: position)
    }

    // MARK: UIScrollViewDelegate

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        presentedViewController?.dismiss(animated: false)
    }

    // MARK: UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: MapDetailScene

    private var delegate: MapDetailSceneDelegate?
    func setDelegate(_ delegate: MapDetailSceneDelegate) {
        self.delegate = delegate
    }

    func setMapImagePNGData(_ data: Data) {
        let image = UIImage(data: data)
        let imageView = UIImageView(image: image)
        self.imageView = imageView
        scrollView.addSubview(imageView)

        if let image = image {
            scrollView.contentSize = image.size
            adjustZoomLevelToFit(image)
        }
    }

    func setMapTitle(_ title: String) {
        navigationItem.title = title
    }

    func focusMapPosition(_ position: MapCoordinate) {

    }

    func show(contextualContent: MapInformationContextualContent) {
        guard let viewController = storyboard?.instantiate(MapContextualContentViewController.self) else { return }

        viewController.loadView()
        viewController.setContextualContent(contextualContent.content)
        viewController.modalPresentationStyle = .popover
        viewController.popoverPresentationController.let { (popover) in
            popover.delegate = self
            popover.backgroundColor = .white
            popover.passthroughViews = [view]
            popover.sourceView = imageView
            popover.sourceRect = CGRect(x: CGFloat(contextualContent.coordinate.x),
                                        y: CGFloat(contextualContent.coordinate.y),
                                        width: 0,
                                        height: 0)
        }
        
        present(viewController, animated: true)
    }

    func showMapOptions(heading: String,
                        options: [String],
                        atX x: Float,
                        y: Float,
                        selectionHandler: @escaping (Int) -> Void) {
        let alertController = UIAlertController(title: heading, message: nil, preferredStyle: .actionSheet)
        for (idx, option) in options.enumerated() {
            alertController.addAction(UIAlertAction(title: option, style: .default, handler: { (_) in selectionHandler(idx) }))
        }

        alertController.addAction(UIAlertAction(title: .cancel, style: .cancel))

        let sourceRect = CGRect(x: CGFloat(x), y: CGFloat(y), width: 0, height: 0)
        alertController.popoverPresentationController?.sourceView = imageView
        alertController.popoverPresentationController?.sourceRect = sourceRect

        present(alertController, animated: true)
    }

    // MARK: Private

    private func adjustZoomLevelToFit(_ image: UIImage) {
        let imageSize = image.size
        let scrollViewWidth: CGFloat = scrollView.bounds.width
        let scrollViewHeight: CGFloat = scrollView.bounds.height
        let deltaWidth = abs(imageSize.width - scrollViewWidth)
        let deltaHeight = abs(imageSize.height - scrollViewHeight)

        let factor: CGFloat
        if deltaWidth / scrollViewWidth < deltaHeight / scrollViewHeight {
            factor = scrollViewWidth / imageSize.width
        } else {
            factor = scrollViewHeight / imageSize.height
        }

        scrollView.zoomScale = min(1.0, factor)
    }

}