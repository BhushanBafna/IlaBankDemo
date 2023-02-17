//
//  NatureViewModel.swift
//  IlaBankDemo
//
//  Created by webwerks on 17/02/23.
//

import Foundation

class NatureViewModel: NSObject {
    private var natureData: [NatureDataModel]?
    private var localSearchedList: [NatureDataModel]?
    
    override init() {}

    //MARK: Fetch data from local saved json file
    func fetchNatureData() {
        if let data = Utils.readLocalJSONFile(forName: "ImageData"), let parsedData = parse(jsonData: data) {
            self.natureData = parsedData
            self.localSearchedList = parsedData
        }
    }
    
    //MARK: Parse json data into readable format
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
    //MARK: Get total row count for carousel
    var numberOfRowsInCarousal: Int {
        return localSearchedList?.count ?? 0
    }
    
    //MARK: Get total row count for given carousel index
    func numberOfRowForCarousal(index: Int) -> Int {
        if let imageDetailArr = getNatureDataForCarousalAt(index: index) {
            return imageDetailArr.count
        }
        return 0
    }
    
    //MARK: Get data array for given carousel index
    func getNatureDataForCarousalAt(index: Int) -> [ImageDetails]? {
        if let natureDataArr = localSearchedList, natureDataArr.count > index {
            return natureDataArr[index].details
        }
        return nil
    }
    
    //MARK: Get carousel data array
    func getCarousalDataArr() -> [NatureDataModel]? {
        return localSearchedList
    }
    
    //MARK: Get filtered data based on search text
    func filterDataWith(searchTxt: String, index: Int) {
        if let data = natureData?[index], let details = data.details {
            localSearchedList?[index].details = details.filter({ $0.text?.lowercased().contains(searchTxt.lowercased()) ?? false })
        }
    }
    
    func resetData() {
        localSearchedList = natureData
    }
}
