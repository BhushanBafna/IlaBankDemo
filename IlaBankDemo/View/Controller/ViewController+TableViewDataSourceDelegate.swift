//
//  ViewController+TableViewDatasource.swift
//  IlaBankDemo
//
//  Created by webwerks on 17/02/23.
//

import UIKit

//MARK: Table view datasource & delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowCount = viewModel?.numberOfRowForCarousal(index: currentPageIndex) ?? 0
        return rowCount > 0 ? rowCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel?.numberOfRowForCarousal(index: currentPageIndex) ?? 0 > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VcConstants.naturePicListingTableCell) as? NaturePicListingTableCell
            if let sectionData = viewModel?.getNatureDataForCarousalAt(index: currentPageIndex) {
                let cellData = sectionData[indexPath.row]
                cell?.setupData(data: cellData)
            }
            return cell ?? UITableViewCell()
        }
        
        //MARK: show no data cell
        let defaultCell = UITableViewCell(style: .value1, reuseIdentifier: VcConstants.defaultCell)
        defaultCell.separatorInset = .zero
        defaultCell.textLabel?.text = VcConstants.noDataFound
        return defaultCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
