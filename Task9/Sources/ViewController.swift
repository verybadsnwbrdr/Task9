import UIKit

final class ViewController: UIViewController {
	private let collectionView = makeCollectionView()

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		collectionView.frame = view.bounds
		collectionView.contentInset.left = view.layoutMargins.left
		collectionView.contentInset.right = view.layoutMargins.right
	}

	private func setup() {
		view.backgroundColor = .white

		navigationItem.title = "Collection"
		navigationController?.navigationBar.prefersLargeTitles = true

		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

		view.addSubview(collectionView)
	}

	private static func makeCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .horizontal
		layout.itemSize = Constants.itemSize
		layout.minimumLineSpacing = Constants.minimumLineSpacing

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		return collectionView
	}
}

extension ViewController: UICollectionViewDelegate {
	func scrollViewWillEndDragging(
		_ scrollView: UIScrollView,
		withVelocity velocity: CGPoint,
		targetContentOffset: UnsafeMutablePointer<CGPoint>
	) {
		let itemWidthWithSpacing = Constants.itemSize.width + Constants.minimumLineSpacing
		let index = (targetContentOffset.pointee.x - scrollView.contentInset.left) / itemWidthWithSpacing
		let roundedIndex = index.rounded(velocity.x >= 0 ? .up : .down)

		targetContentOffset.pointee.x = roundedIndex * itemWidthWithSpacing - scrollView.contentInset.left
	}
}

extension ViewController: UICollectionViewDataSource {
	func collectionView(
		_ collectionView: UICollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		20
	}

	func collectionView(
		_ collectionView: UICollectionView,
		cellForItemAt indexPath: IndexPath
	) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		cell.backgroundColor = .systemGray6
		cell.layer.cornerRadius = 10
		return cell
	}
}

extension ViewController {
	private enum Constants {
		static let itemSize = CGSize(width: 280, height: 400)
		static let minimumLineSpacing: CGFloat = 10
	}
}
