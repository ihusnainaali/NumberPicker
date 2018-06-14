#  NumberPicker

Custom animating gradient number picker. <br />


![gif](ScreenShot/NumberPicker1.gif)
![gif](ScreenShot/NumberPicker2.gif)


How to use 
---------
```swift
let progressBar = TYProgressBar()

func setupProgressBar() {
        progressBar.frame = CGRect(x: 0, y: 0, width: 220, height: 220)
        progressBar.center = self.view.center
        self.view.addSubview(progressBar)
    }
```
Customize 
---------
You can change gradient color and label font and text color 
```swift
progressBar.gradients = [UIColor.red, UIColor.yellow]
progressBar.textColor = .orange
progressBar.font = UIFont(name: "HelveticaNeue-Medium", size: 22)!
```

Show progress 
---------
```swift
progressBar.progress = 0.5    // between 0 to 1
```
