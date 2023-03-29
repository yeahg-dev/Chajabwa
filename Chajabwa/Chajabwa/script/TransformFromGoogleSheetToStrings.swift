#!/usr/bin/xcrun --sdk macosx swift
import Foundation

let semaphore = DispatchSemaphore(value: 0)
let sheetURL = "https://docs.google.com/spreadsheets/d/e/2PACX-1vRICy_wrgnczSxVYlx4J7LlwTDpEGWWPtCZu7EBIQSbw4iQ7GThckvaPae5lSFhNe9zH-Rf23fnMYR1/pub?gid=0&single=true&output=csv"
let englishStringsDirectory = "/a1/Library/Mobile Documents/com~apple~CloudDocs/iOS/ToyProjects/app-show-room/app-show-room/app-show-room/Text/en.lproj/Localizable.strings"
let koreanStringsDirectory = "/a1/Library/Mobile Documents/com~apple~CloudDocs/iOS/ToyProjects/app-show-room/app-show-room/app-show-room/Text/ko.lproj/Localizable.strings"

class GogleSheetURLSessionDelegate: NSObject, URLSessionDataDelegate {
    
    var recievedData = Data()
    
    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data)
    {
        self.recievedData.append(data)
    }
    
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?)
    {
        guard let csvString = String(bytes: recievedData, encoding: .utf8)?.replacingOccurrences(of: "\r", with: "") else {
            return
        }
        print(csvString)
        let stringsArray = csvToStringsArray(csvString: csvString)
        createStringsFile(dictionary: stringsArray)
        semaphore.signal()
    }
    
}

func main() {
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config, delegate: GogleSheetURLSessionDelegate(), delegateQueue: nil)
    guard let url = URL(string: sheetURL) else {  fatalError("Google Sheet URL 생성 오류") }
    session.dataTask(with: url).resume()
    semaphore.wait()
}

extension GogleSheetURLSessionDelegate {
    
    func csvToStringsArray(csvString: String) -> [[String: String]] {
        let csv = csvString.components(separatedBy: "\n")
        var keyIndex: Int!
        var koreanIndex: Int!
        var englishIndex: Int!
        var stringsArray = [[String: String]]()
        
        for rowIndex in csv.indices {
            let row = csv[rowIndex].components(separatedBy: ",")
//            print(row)
            if rowIndex == 0 {
                for columnIndex in row.indices {
                    switch row[columnIndex] {
                    case "screen":
                        continue
                    case "Key":
                        keyIndex = columnIndex
                    case "ko":
                        koreanIndex = columnIndex
                    case "en":
                        englishIndex = columnIndex
                    default:
                        print("error Index")
                        continue
                    }
                }
            } else {
                stringsArray.append(["key": row[keyIndex], "ko": row[koreanIndex], "en": row[englishIndex]])
            }
        }
//        print(stringsArray)
        return stringsArray
    }
    
    func createStringsFile(dictionary: [[String: String]]) {
        var koreanStrings = ""
        var englishStrings = ""
        
        for item in dictionary {
            guard let key = item["key"] else { return }
            guard let ko = item["ko"] else { return }
            guard let en = item["en"] else { return }
            
            koreanStrings.append("\"\(key)\" = \"\(ko)\";\n")
            englishStrings.append("\"\(key)\" = \"\(en)\";\n")
        }
        
        let fileManager = FileManager()
        guard let projectDirectory = fileManager.urls(for: .userDirectory, in: .userDomainMask).first else {
            return
        }
        do {
            let koreanStringsFilPath = projectDirectory.appendingPathComponent(koreanStringsDirectory)
            let englishStringsFilePath = projectDirectory.appendingPathComponent(englishStringsDirectory)
            try koreanStrings.write(to: koreanStringsFilPath, atomically: false, encoding: .utf8)
            try englishStrings.write(to: englishStringsFilePath, atomically: false, encoding: .utf8)
        } catch let error as NSError {
            print("Error writing File : \(error.localizedDescription)")
        }
    }
    
}

main()
