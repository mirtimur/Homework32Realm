import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var yearOfIssueLabel: UILabel!
    
    var carModel: Car?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = "Name: \(carModel?.name ?? "")"
        maxSpeedLabel.text = "Max speed: \(carModel?.maxSpeed ?? "") km/h"
        yearOfIssueLabel.text = "Year of issue: \(carModel?.yearOfIssue ?? "")"
        weightLabel.text = "Weight: \(carModel?.weight ?? "") kg"
        
    }
}
