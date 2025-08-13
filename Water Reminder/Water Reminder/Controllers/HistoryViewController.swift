import UIKit
import Charts

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var barChartView: BarChartView! // storyboard me connect karo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAndShowHistory()
        barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter { (value, _) in
            return "\(Int(value)) ml"
        }


    }
    
    
    func loadAndShowHistory() {
        let (days, values) = loadHistoryData()
        setupChart(days: days, values: values)
    }
    func loadHistoryData() -> ([String], [Int]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let history = UserDefaults.standard.dictionary(forKey: "WaterHistory") as? [String: Int] ?? [:]
        
        let last7Days = (0..<7).compactMap { offset -> (String, Int)? in
            if let date = Calendar.current.date(byAdding: .day, value: -offset, to: Date()) {
                let dateStr = dateFormatter.string(from: date)
                let displayFormatter = DateFormatter()
                displayFormatter.dateFormat = "E" // Mon, Tue
                let dayName = displayFormatter.string(from: date)
                let intake = history[dateStr] ?? 0
                return (dayName, intake)
            }
            return nil
        }.reversed()
        
        let days = last7Days.map { $0.0 }
        let values = last7Days.map { $0.1 }
        
        return (days, values)
    }
    
    func setupChart(days: [String], values: [Int]) {
        var dataEntries: [BarChartDataEntry] = []
        for (index, value) in values.enumerated() {
            dataEntries.append(BarChartDataEntry(x: Double(index), y: Double(value)))
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Water Intake (ml)")
        dataSet.colors = [UIColor.systemBlue]
        
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data
        
        // X Axis
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.xAxis.granularity = 1
        barChartView.xAxis.labelPosition = .bottom
        
        // Y Axis (ML values)
        barChartView.leftAxis.axisMinimum = 0
        barChartView.rightAxis.enabled = false
        
        barChartView.animate(yAxisDuration: 1.5)
    }
    func loadMonthlyData() -> ([String], [Int]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let history = UserDefaults.standard.dictionary(forKey: "WaterHistory") as? [String: Int] ?? [:]
        
        // Group by month
        var monthlyTotals: [String: Int] = [:]
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM yyyy" // e.g. Aug 2025
        
        for (dateStr, intake) in history {
            if let date = dateFormatter.date(from: dateStr) {
                let monthKey = monthFormatter.string(from: date)
                monthlyTotals[monthKey, default: 0] += intake
            }
        }
        
        // Sort by month
        let sortedMonths = monthlyTotals.keys.sorted {
            monthFormatter.date(from: $0)! < monthFormatter.date(from: $1)!
        }
        
        let values = sortedMonths.map { monthlyTotals[$0] ?? 0 }
        
        return (sortedMonths, values)
    }
    func showMonthlyChart() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let history = UserDefaults.standard.dictionary(forKey: "WaterHistory") as? [String: Int] ?? [:]

        var days: [String] = []
        var values: [Int] = []

        // Current month ke start se aaj tak ka data
        let calendar = Calendar.current
        let today = Date()
        let dayCount = calendar.component(.day, from: today) // Aaj ka date number (1..31)

        for day in 1...dayCount {
            if let date = calendar.date(from: DateComponents(year: calendar.component(.year, from: today),
                                                             month: calendar.component(.month, from: today),
                                                             day: day)) {
                let dateStr = dateFormatter.string(from: date)
                let intake = history[dateStr] ?? 0

                days.append("\(day)") // X-axis label
                values.append(intake)
            }
        }

        // Chart entries
        var entries: [BarChartDataEntry] = []
        for (index, value) in values.enumerated() {
            entries.append(BarChartDataEntry(x: Double(index), y: Double(value)))
        }

        let dataSet = BarChartDataSet(entries: entries, label: "Water Intake (ml)")
        dataSet.colors = [UIColor.systemBlue]
        dataSet.valueFormatter = DefaultValueFormatter(decimals: 0)

        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data

        // X-axis labels
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.granularity = 1

        // Y-axis setup
        barChartView.leftAxis.axisMinimum = 0
        barChartView.rightAxis.enabled = false

        barChartView.animate(yAxisDuration: 1.5)
    }


    

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loadAndShowHistory() // weekly
        } else {
            showMonthlyChart()
        }
    }


    
}
