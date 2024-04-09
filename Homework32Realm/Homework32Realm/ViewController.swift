import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var cars: [Car] = []
    
    lazy private var realm: Realm? = {
        do {
            let _realm = try Realm()
            return _realm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetting()
    }
    
    private func tableViewSetting() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        guard let realm else { return }
        
        cars = realm.objects(Car.self).map{$0}
    }
    
    private func addAlert() {
        let alert = UIAlertController(title: "New Car", message: "Add a new car", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            guard let fields = alert.textFields, fields.count == 4 else { return }
            
            let nameToSave = fields[0].text
            let maxSpeedToSave = fields[1].text
            let weightToSave = fields[2].text
            let yearOfIssueToSave = fields[3].text
            addCar(name: nameToSave ?? "", maxSpeed: maxSpeedToSave ?? "", yearOfIssue: yearOfIssueToSave ?? "", weight: weightToSave ?? "")
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        guard let fields = alert.textFields, fields.count > 3 else { return }
        
        fields[0].placeholder = "Name"
        fields[1].placeholder = "Max speed"
        fields[2].placeholder = "Weight"
        fields[3].placeholder = "Year of issue"
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func addCar(name: String, maxSpeed: String, yearOfIssue: String, weight: String) {
        guard let realm else { return }
        
        let carObject = Car(name: name, maxSpeed: maxSpeed, yearOfIssue: yearOfIssue, weight: weight)
        do {
            try realm.write {
                realm.add(carObject)
            }
            cars.append(carObject)
            tableView.reloadData()
        } catch {
            print("Error")
        }
    }
    
    private func presentSecondViewController(car: Car) {
        let storyboard = UIStoryboard(name: "SecondViewController", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else { return }
        
        vc.modalPresentationStyle = .formSheet
        vc.carModel = car
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func plusButtonPressed(_ sender: UIButton) {
        addAlert()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard cars.count > indexPath.row else { return UITableViewCell() }
        
        let car = cars[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = car.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let realm,
                  cars.count > indexPath.row else { return }
            
            let carId = cars[indexPath.row].id
        
            do {
                guard let deletingCar = realm.object(ofType: Car.self, forPrimaryKey: carId) else { return }
                
                try realm.write {
                    realm.delete(deletingCar)
                }
            } catch {
                print("Error")
            }
            cars.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentSecondViewController(car: cars[indexPath.row])
    }
}
