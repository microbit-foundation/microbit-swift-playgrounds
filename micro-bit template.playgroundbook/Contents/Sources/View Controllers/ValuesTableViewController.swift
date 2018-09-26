/*
 MIT License
 
 Copyright (c) 2018 micro:bit Educational Foundation
 Written by Gary J.H. Atkinson of Stinky Kitten Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit

@objc(ValuesTableViewController)
public class ValuesTableViewController: UITableViewController {
    
    public var dataSource: ValuesTableViewDataSourceProtocol? = nil
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource != nil ? dataSource!.numberOfMicrobitMeasurements() : 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "valueTableCellID") as? ValueTableViewCell {
            
            tableViewCell.backgroundColor = UIColor.clear
            
            if let microbitMeasurement = self.dataSource?.microbitMeasurementAtIndex(indexPath.row) {
                tableViewCell.microbitMeasurement = microbitMeasurement
            }
            
            return tableViewCell
        }
        
        return UITableViewCell(style: .value1, reuseIdentifier: "missingCell")
    }
    
    public func setMicrobitValue(_ microbitValue: Double, forMicrobitMeasurement microbitMeasurement: MicrobitMeasurement) {
        
        DispatchQueue.main.async {
            for case let cell as ValueTableViewCell in self.tableView.visibleCells {
                
                if cell.microbitMeasurement == microbitMeasurement {
                    cell.microbitValue = microbitValue
                }
            }
        }
    }
}

@objc(ValueTableViewCell)
public class ValueTableViewCell: UITableViewCell {
    
    let measurementFormatter = MeasurementFormatter()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    public var microbitMeasurement: MicrobitMeasurement? = nil {
        
        didSet {
            measurementFormatter.unitOptions = .providedUnit
            self.nameLabel.text = microbitMeasurement?.name
            self.microbitValue = 0.0
            measurementFormatter.numberFormatter.maximumFractionDigits = 0
        }
    }
    
    public var microbitValue: Double = 0.0 {

        didSet {
            if let measurement = microbitMeasurement?.displayMeasurementFromMicrobitValue(microbitValue) {
                self.valueLabel.text = self.measurementFormatter.string(from: measurement)
            }
        }
    }
}

public protocol ValuesTableViewDataSourceProtocol {
    
    func numberOfMicrobitMeasurements() -> Int
    func microbitMeasurementAtIndex(_ index: Int) -> MicrobitMeasurement
}
