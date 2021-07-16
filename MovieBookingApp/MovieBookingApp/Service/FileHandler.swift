
import Foundation

struct FileHandler {
    
    //MARK: Variables
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    //MARK: functions
    func getPathForImage(id: Int) -> URL {
        let pathComponent = "\(id).jpg"
        return documentsDirectory.appendingPathComponent(pathComponent)
    }
    
    func checkIfFileExists(id: Int) -> Bool {
        let pathComponent = "\(id).jpg"
        return FileManager.default.fileExists(atPath: documentsDirectory.appendingPathComponent(pathComponent).path)
    }
    
    func flushDocumentsDirectory() -> Bool {
        guard let paths = try? FileManager.default.contentsOfDirectory(at: self.documentsDirectory, includingPropertiesForKeys: nil) else { return false }
        for path in paths {
            try? FileManager.default.removeItem(at: path)
        }
        return true
    }
}
