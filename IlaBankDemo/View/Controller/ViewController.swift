//
//  ViewController.swift
//  IlaBankDemo
//
//  Created by webwerks on 14/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var carouselContainerView: UIView!
    @IBOutlet weak var imgCollectionView: UICollectionView!
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
    
    struct VcConstants {
        static let listingTvCell = "ListingTVCell"
        static let imgCorousalCVCell = "ImgCorousalCVCell"
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
        tableView.register(UINib(nibName: VcConstants.listingTvCell, bundle: nil), forCellReuseIdentifier: VcConstants.listingTvCell)
        tableView.estimatedRowHeight = 80
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
    }
    
    private func setupCollectionView() {
        imgCollectionView.dataSource = self
        imgCollectionView.delegate = self
        
        imgCollectionView.register(UINib(nibName: VcConstants.imgCorousalCVCell, bundle: nil), forCellWithReuseIdentifier: VcConstants.imgCorousalCVCell)
        imgCollectionView.isPagingEnabled = false
        provideLayoutToCollectionView()
    }
    
    fileprivate func provideLayoutToCollectionView() {
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 60.0, height: imgCollectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 1.0
        flowLayout.sideItemAlpha = 1.0
        flowLayout.spacingMode = .fixed(spacing: 5.0)
        imgCollectionView.collectionViewLayout = flowLayout
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = viewModel?.numberOfRowsInCarousal ?? 0
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .white
        carouselContainerView.bringSubviewToFront(pageControl)
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
    
    func slideDidScroll() {
        
        clearSearchTxt()
        self.viewModel?.resetData()
        self.reloadTable()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchData(searchTxt: searchText)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchBar.resignFirstResponder()
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if !isAnimationInProgress {
            
            if scrollView.contentOffset.y > .zero &&
                !(self.imgCollectionView.isHidden) {
                
                self.carouselContainerView.isHidden = true
                self.pageControl.isHidden = true
                self.updateViewAnimation()
                
            } else if scrollView.contentOffset.y <= .zero
                        && (self.carouselContainerView.isHidden) && (searchBar.text?.isEmpty ?? true) {
                
                self.carouselContainerView.isHidden = false
                self.pageControl.isHidden = false
                self.updateViewAnimation()
            }
        }
        //MARK: update only whensc
        if scrollView is UICollectionView {
            let layout = self.imgCollectionView.collectionViewLayout as! UPCarouselFlowLayout
            let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
            let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
            currentPageIndex = Int(floor((offset - pageSide / 2) / pageSide) + 1)
            DispatchQueue.main.async {
                self.pageControl.currentPage = self.currentPageIndex
                self.slideDidScroll()
            }
        }
    }
    
    fileprivate var pageSize: CGSize {
        if let layout = self.imgCollectionView.collectionViewLayout as? UPCarouselFlowLayout {
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
    
    // Animate the top view
    private func updateViewAnimation() {
        
        isAnimationInProgress = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        } completion: { [weak self] (_) in
            self?.isAnimationInProgress = false
        }
    }
}
