//
//  NatureViewModel.swift
//  IlaBankDemo
//
//  Created by webwerks on 14/02/23.
//

import Foundation

class NatureViewModel: NSObject {
    private var natureData: [NatureDataModel]?
    private var localSearchedList: [NatureDataModel]?
    
    override init() {}

    func fetchNatureData() {
        if let data = Utils.readLocalJSONFile(forName: "ImageData"), let parsedData = parse(jsonData: data) {
            self.natureData = parsedData
            self.localSearchedList = parsedData
        }
    }
    
    private func parse(jsonData: Data) -> [NatureDataModel]? {
        do {
            let decodedData = try JSONDecoder().decode([NatureDataModel].self, from: jsonData)
            return decodedData
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}

extension NatureViewModel {
    var numberOfRowsInCarousal: Int {
        return localSearchedList?.count ?? 0
    }
    
    func numberOfRowForCarousal(index: Int) -> Int {
        if let imageDetailArr = getNatureDataForCarousalAt(index: index) {
            return imageDetailArr.count
        }
        return 0
    }
    
    func getNatureDataForCarousalAt(index: Int) -> [ImageDetails]? {
        if let natureDataArr = localSearchedList, natureDataArr.count > index {
            return natureDataArr[index].details
        }
        return nil
    }
    
    func getCarousalDataArr() -> [NatureDataModel]? {
        return localSearchedList
    }
    
    func filterDataWith(searchTxt: String, index: Int) {
        if let data = natureData?[index], let details = data.details {
            localSearchedList?[index].details = details.filter({ $0.text?.lowercased().contains(searchTxt.lowercased()) ?? false })
        }
    }
    
    func resetData() {
        localSearchedList = natureData
    }
}
