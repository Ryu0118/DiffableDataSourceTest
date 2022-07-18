//
//  ViewController3.swift
//  CollectionViewPractice
//
//  Created by 上條栞汰 on 2022/07/18.
//

import UIKit

class ViewController3: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "CollectionViewCell1", bundle: nil), forCellWithReuseIdentifier: "cell1")
            collectionView.register(UINib(nibName: "CollectionViewCell2", bundle: nil), forCellWithReuseIdentifier: "cell2")
            collectionView.register(UINib(nibName: "CollectionViewCell3", bundle: nil), forCellWithReuseIdentifier: "cell3")
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
    
    var isBasicExpanded = false
    var isTopExpanded = false
    var isAdvanceExpanded = false
    
    var basicItems = [Item]()
    var advanceItems = [Item]()
    var topItems = [Item]()
    
    enum Section: CaseIterable {
        case graph
        case basic
        case advance
        case top
    }
    
    enum Item: Hashable {
        case charts(data:[Int])
        case levelCell(level: Level)
        case circleProgress(level: Level, category: String, progress: Float)
    }
    
    enum Level: Int, Hashable {
        case basic, advance, top
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataSource()
        configureCells()
        //configureLayout()
    }
    
    private func setupDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { [weak self] (collectionView: UICollectionView, indexPath: IndexPath, identifier: Item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            switch identifier {
            case .charts( _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
                return cell
            case .levelCell(let level):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CollectionViewCell2
                cell.delegate = self
                cell.configure(level: level)
                return cell
            case .circleProgress(_, _, _):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell3", for: indexPath)
                return cell
            }
        }
    }
    
    private func configureCells() {
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([.charts(data: [1]), .charts(data: [2])], toSection: .graph)
        snapshot.appendItems([.levelCell(level: .basic)], toSection: .basic)
        snapshot.appendItems([.levelCell(level: .advance)], toSection: .advance)
        snapshot.appendItems([.levelCell(level: .top)], toSection: .top)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func verticalRectangleSection(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        let verticalRectangleHeight = collectionViewBounds.height * 0.7
        let verticalRectangleItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                              heightDimension: .fractionalHeight(1.0)))
        let verticalRectangleGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                                         heightDimension: .absolute(verticalRectangleHeight)),
                                                                      subitem: verticalRectangleItem,
                                                                      count: 2)
        return NSCollectionLayoutSection(group: verticalRectangleGroup)
    }

    
    private func configureLayout() {
        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            //guard let self = self else { return nil }
            let sectionKind = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
            switch sectionKind {
            case .graph:
                return verticalRectangleSection(collectionViewBounds: collectionView.bounds)
            case .basic, .advance, .top:
                return levelSectionLayout(collectionViewBounds: collectionView.bounds)
            }
        }
        collectionView.collectionViewLayout = layout
    }
    
    func levelButtonDidTap(level: Level) {
        defer { dataSource.apply(snapshot) }
        
        switch level {
        case .basic:
            defer { isBasicExpanded = !isBasicExpanded }
            if !isBasicExpanded {
                snapshot.insertItems([.circleProgress(level: .basic, category: "法律", progress: 0.4)], afterItem: .levelCell(level: .basic))
            }
            else {
                snapshot.deleteItems([.circleProgress(level: .basic, category: "法律", progress: 0.4)])
            }
        case .advance:
            defer { isAdvanceExpanded = !isAdvanceExpanded }
            if !isAdvanceExpanded {
                snapshot.insertItems([.circleProgress(level: .advance, category: "法律", progress: 0.4), .circleProgress(level: .advance, category: "企業", progress: 0.2), .circleProgress(level: .advance, category: "法", progress: 0.4), .circleProgress(level: .advance, category: "業", progress: 0.2)], afterItem: .levelCell(level: .advance))
            }
            else {
                snapshot.deleteItems([.circleProgress(level: .advance, category: "法律", progress: 0.4), .circleProgress(level: .advance, category: "企業", progress: 0.2), .circleProgress(level: .advance, category: "法", progress: 0.4), .circleProgress(level: .advance, category: "業", progress: 0.2)])
            }
        case .top:
            defer { isTopExpanded = !isTopExpanded }
            if !isTopExpanded {
                snapshot.insertItems([.circleProgress(level: .top, category: "法律", progress: 0.4)], afterItem: .levelCell(level: .top))
            }
            else {
                snapshot.deleteItems([.circleProgress(level: .top, category: "法律", progress: 0.4)])
            }
        }
    }
    
    
    func levelSectionLayout(collectionViewBounds: CGRect) -> NSCollectionLayoutSection {
        //        let itemCount = 3
        //        let lineCount = itemCount - 1
        //        let itemSpacing = CGFloat(1)
        //        let itemLength = (collectionViewBounds.width - (itemSpacing * CGFloat(lineCount))) / CGFloat(itemCount)
        let largeItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                  heightDimension: .absolute(70)))
        let largeGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    
                                                                                             heightDimension: .absolute(70)), subitem: largeItem, count: 1
                                                          
        )
        
        let itemCount = 3 // 横に並べる数
        let lineCount = itemCount - 1
        let itemSpacing = CGFloat(1) // セル間のスペース
        let itemLength = (collectionViewBounds.width - (itemSpacing * CGFloat(lineCount))) / CGFloat(itemCount)
        // １つのitemを生成
        // .absoluteは固定値で指定する方法
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(itemLength),
                                                                             heightDimension: .absolute(itemLength)))
        // itemを3つ横並びにしたグループを生成
        // .fractional~は親Viewとの割合
        let items = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                          heightDimension: .fractionalHeight(1.0)),
                                                       subitem: item,
                                                       count: itemCount)
        // グループ内のitem間のスペースを設定
        items.interItemSpacing = .fixed(itemSpacing)
        
        // 生成したグループ(items)が縦に並んでいくグループを生成（実質これがセクション）
        let grid = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                                       
                                                                                       heightDimension: .estimated(itemLength)),
                                                    subitems: [items])
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [largeItem, grid])
        return NSCollectionLayoutSection(group: group)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
//}
//
//extension ViewController3: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 100)
//    }
//
//}

extension ViewController3: CollectionViewCell2Delegate {
    
    func cell2DidTap(_ cell: CollectionViewCell2, level: Level) {
        levelButtonDidTap(level: level)
    }
    
}
