#  NumberPicker

<img src="ScreenShot/numberPicker1.gif" width="300"><img src="ScreenShot/numberPicker2.gif" width="300">

How to use 
---------
call this function in action.
```swift
    func openNumberPicker() {
        let numberPicker = TYNumberPicker(self, maxNumber: 300) // set max number 
        numberPicker.bgGradients = [.red, .yellow]
        numberPicker.tintColor = .white
        numberPicker.heading = "Weight"
        numberPicker.defaultSelectedNumber = 150 // set default selected number
        
        self.present(numberPicker, animated: true, completion: nil)
    }
```
### Customize 
You can change gradient color and tint color and title 
```swift
        numberPicker.bgGradients = [.red, .yellow]
        numberPicker.tintColor = .white
        numberPicker.heading = "Weight"
```
### delegate 
```swift
 extension ViewController: TYNumberPickerDelegate {
    
    func selectedNumber(_ number: Int) {
        print(number)
    }
}
```
