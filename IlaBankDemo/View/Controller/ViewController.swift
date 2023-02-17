//
//  ViewController.swift
//  IlaBankDemo
//
//  Created by webwerks on 17/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var viewModel: NatureViewModel?
    var currentPageIndex = 0
    private var isAnimationInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTblView()
        viewModel = NatureViewModel()
        fetchData()
        setupSearchBar()
        setupCollectionView()
        setupPageControl()
    }
    
    //MARK: File constants
    struct VcConstants {
        static let naturePicListingTableCell = "NaturePicListingTableCell"
        static let carouselCollectionCell = "CarouselCollectionCell"
        static let defaultCell = "Cell"
        static let noDataFound = "No data found"
    }
    
    private func fetchData() {
        viewModel?.fetchNatureData()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupTblView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: VcConstants.naturePicListingTableCell, bundle: nil), forCellReuseIdentifier: VcConstants.naturePicListingTableCell)
        tableView.estimatedRowHeight = 80
        tableView.separatorInset = .zero
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    private func setupCollectionView() {
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        
        carouselCollectionView.register(UINib(nibName: VcConstants.carouselCollectionCell, bundle: nil), forCellWithReuseIdentifier: VcConstants.carouselCollectionCell)
        carouselCollectionView.isPagingEnabled = false
        provideLayoutToCollectionView()
    }
    
    //MARK: Setup collection view flow layout
    fileprivate func provideLayoutToCollectionView() {
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60.0, height: carouselCollectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 1.0
        flowLayout.sideItemAlpha = 1.0
        flowLayout.spacingMode = .fixed(spacing: 5.0)
        carouselCollectionView.collectionViewLayout = flowLayout
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel?.numberOfRowsInCarousal ?? 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        pageControl.currentPageIndicatorTintColor = .systemGreen
    }
    
    private func clearSearchTxt() {
        searchBar.text?.removeAll()
    }
    
    private func searchData(searchTxt: String) {
        if !searchTxt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewModel?.filterDataWith(searchTxt: searchTxt, index: currentPageIndex)
        } else {
            viewModel?.resetData()
        }
        self.reloadTable()
    }
    
    //MARK: Update view on carousel slide changes
    func slideDidScroll() {
        clearSearchTxt()
        self.viewModel?.resetData()
        self.reloadTable()
    }
    
    //MARK: Calculate the collection cell size
    private var pageSize: CGSize {
        if let layout = self.carouselCollectionView.collectionViewLayout as? UPCarouselFlowLayout {
            var pageSize = layout.itemSize
            if layout.scrollDirection == .horizontal {
                pageSize.width += layout.minimumLineSpacing
            } else {
                pageSize.height += layout.minimumLineSpacing
            }
            return pageSize
        }
        return CGSize(width: 0, height: 0)
    }

    //MARK: Update layout on table scroll
    private func updateViewAnimation() {
        isAnimationInProgress = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] (_) in
            self?.isAnimationInProgress = false
        }
    }
}

//MARK: Search bar delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData(searchTxt: searchText)
    }
}

//MARK: Text field deleagte
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
    }
}

//MARK: Scroll view delegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //MARK: hide top components when table scroll up
        //MARK: unhide top components when table scroll down
        if !isAnimationInProgress {
            if scrollView.contentOffset.y > .zero &&
                !(self.carouselCollectionView.isHidden) {
                
                self.carouselCollectionView.isHidden = true
                self.pageControl.isHidden = true
                self.updateViewAnimation()
            } else if scrollView.contentOffset.y <= .zero
                        && (self.carouselCollectionView.isHidden) && (searchBar.text?.isEmpty ?? true) {
                
                self.carouselCollectionView.isHidden = false
                self.pageControl.isHidden = false
                self.updateViewAnimation()
            }
        }
        
        //MARK: update only when scroll happen collection view
        if scrollView is UICollectionView {
            let layout = self.carouselCollectionView.collectionViewLayout as! UPCarouselFlowLayout
            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            currentPageIndex = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            DispatchQueue.main.async {
                self.pageControl.currentPage = self.currentPageIndex
                self.slideDidScroll()
            }
        }
    }
}
