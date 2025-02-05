//
//  CryptoDetailViewController.swift
//  CryptoApp
//
//  Created by Emirhan Aydın on 13.08.2024.
//

import UIKit
import Charts

protocol CryptoDetailsViewControllerInterface: AnyObject{
    func style()
    func layout()
    func configureChart(prices: [Double])
    func prepareView(crypto: Crypto)
    func changeIcon(data: Data)
    func showNetworkError(_ errorMessage: ErrorMessage)
}
final class CryptoDetailsViewController: UIViewController{
    
    lazy var viewModel = CryptoDetailsViewModel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let cryptoName = UILabel()
    private let cryptoSymbol = UIImageView()
    private let overviewTitle = UILabel()
    private let additionalDetailTitle = UILabel()
    private let currentPrice = UILabel()
    private let currentPriceChange = UILabel()
    private let marketCap = UILabel()
    private let marketCapChange = UILabel()
    private let rank = UILabel()
    private let volume = UILabel()
    private let maxPrice24h = UILabel()
    private let minPrice24h = UILabel()
    private let priceChange24h = UILabel()
    private let marketCapChange24h = UILabel()
    
    private var cryptoSV = UIStackView()
    private var currentPriceSV = UIStackView()
    private var marketCapSV = UIStackView()
    private var rankSV = UIStackView()
    private var volumeSV = UIStackView()
    private var maxPrice24hSV = UIStackView()
    private var minPrice24hSV = UIStackView()
    private var priceChange24hSV = UIStackView()
    private var marketCapChange24hSV = UIStackView()
    
    private var firstSV = UIStackView()
    private var secondSV = UIStackView()
    private var thirdSV = UIStackView()
    private var fourthSV = UIStackView()

    var crypto: Crypto?
    
    private let lineChartView: LineChartView = {
            let chartView = LineChartView()
            chartView.rightAxis.enabled = false
            chartView.xAxis.labelPosition = .bottom
            chartView.xAxis.drawGridLinesEnabled = false
            chartView.xAxis.drawLabelsEnabled = false
            chartView.leftAxis.drawGridLinesEnabled = true
            chartView.legend.enabled = true
            chartView.backgroundColor = .clear
        
            return chartView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        prepareView(crypto: crypto!)
        
    }
}

extension CryptoDetailsViewController: CryptoDetailsViewControllerInterface{
    
    func style(){
        view.backgroundColor = .systemBackground
        cryptoSV = UIStackView(arrangedSubviews: [cryptoSymbol, cryptoName])
        cryptoSV.axis = .horizontal
        cryptoSV.distribution = .fill
        cryptoSV.spacing = 2
        cryptoName.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        cryptoSymbol.translatesAutoresizingMaskIntoConstraints = false
        cryptoSymbol.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cryptoSymbol.widthAnchor.constraint(equalToConstant: 30).isActive = true
        cryptoSymbol.contentMode = .scaleAspectFit
//MARK: - Overview
        overviewTitle.text = "Overview"
        overviewTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        let currentPriceTitle = UILabel()
        currentPriceTitle.text = "Current Price"
        currentPriceTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let marketCapTitle = UILabel()
        marketCapTitle.text = "Market Cap"
        marketCapTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let rankTitle = UILabel()
        rankTitle.text = "Rank"
        rankTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let volumeTitle = UILabel()
        volumeTitle.text = "Volume"
        volumeTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        currentPrice.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        marketCap.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        rank.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        volume.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        currentPriceChange.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        marketCapChange.font = UIFont.systemFont(ofSize: 15, weight: .semibold)

        currentPriceSV = UIStackView(arrangedSubviews: [currentPriceTitle, currentPrice, currentPriceChange])
        currentPriceSV.axis = .vertical
        currentPriceSV.distribution = .fillEqually
        
        marketCapSV = UIStackView(arrangedSubviews: [marketCapTitle, marketCap, marketCapChange])
        marketCapSV.axis = .vertical
        marketCapSV.distribution = .fillEqually
        
        rankSV = UIStackView(arrangedSubviews: [rankTitle, rank])
        rankSV.axis = .vertical
        rankSV.distribution = .fillEqually
        
        volumeSV = UIStackView(arrangedSubviews: [volumeTitle, volume])
        volumeSV.axis = .vertical
        volumeSV.distribution = .fillEqually
        
        firstSV = UIStackView(arrangedSubviews: [currentPriceSV, rankSV])
        firstSV.axis = .vertical
        firstSV.distribution = .fill
        firstSV.spacing = 20
        
        secondSV = UIStackView(arrangedSubviews: [marketCapSV, volumeSV])
        secondSV.axis = .vertical
        secondSV.distribution = .fill
        secondSV.spacing = 20

        
//MARK: - Additional Details
        additionalDetailTitle.text = "Additional Detail"
        additionalDetailTitle.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        let highPriceTitle = UILabel()
        highPriceTitle.text = "24h High"
        highPriceTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let lowPriceTitle = UILabel()
        lowPriceTitle.text = "24h Low"
        lowPriceTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let priceChangeTitle = UILabel()
        priceChangeTitle.text = "24h Price Change"
        priceChangeTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let marketCapChangeTitle = UILabel()
        marketCapChangeTitle.text = "24h Market Cap Change"
        marketCapChangeTitle.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        maxPrice24h.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        minPrice24h.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        priceChange24h.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        marketCapChange24h.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        
        maxPrice24hSV = UIStackView(arrangedSubviews: [highPriceTitle, maxPrice24h])
        maxPrice24hSV.axis = .vertical
        maxPrice24hSV.distribution = .fillEqually
        
        minPrice24hSV = UIStackView(arrangedSubviews: [lowPriceTitle, minPrice24h])
        minPrice24hSV.axis = .vertical
        minPrice24hSV.distribution = .fillEqually
        
        priceChange24hSV = UIStackView(arrangedSubviews: [priceChangeTitle, priceChange24h])
        priceChange24hSV.axis = .vertical
        priceChange24hSV.distribution = .fillEqually
        
        marketCapChange24hSV = UIStackView(arrangedSubviews: [marketCapChangeTitle, marketCapChange24h])
        marketCapChange24hSV.axis = .vertical
        marketCapChange24hSV.distribution = .fillEqually
        
        thirdSV = UIStackView(arrangedSubviews: [maxPrice24hSV, priceChange24hSV])
        thirdSV.axis = .vertical
        thirdSV.distribution = .fill
        thirdSV.spacing = 20
        
        fourthSV = UIStackView(arrangedSubviews: [minPrice24hSV, marketCapChange24hSV])
        fourthSV.axis = .vertical
        fourthSV.distribution = .fill
        fourthSV.spacing = 20
        
    }
    func layout(){
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cryptoSV)
        contentView.addSubview(lineChartView)
        contentView.addSubview(overviewTitle)
        contentView.addSubview(additionalDetailTitle)
        contentView.addSubview(firstSV)
        contentView.addSubview(secondSV)
        contentView.addSubview(thirdSV)
        contentView.addSubview(fourthSV)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        cryptoSV.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        overviewTitle.translatesAutoresizingMaskIntoConstraints = false
        additionalDetailTitle.translatesAutoresizingMaskIntoConstraints = false
        firstSV.translatesAutoresizingMaskIntoConstraints = false
        secondSV.translatesAutoresizingMaskIntoConstraints = false
        thirdSV.translatesAutoresizingMaskIntoConstraints = false
        fourthSV.translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            cryptoSV.topAnchor.constraint(equalTo: contentView.topAnchor),
            cryptoSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            lineChartView.topAnchor.constraint(equalTo: cryptoSV.bottomAnchor, constant: 5),
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            lineChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            lineChartView.heightAnchor.constraint(equalToConstant: 300),
            
            overviewTitle.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 20),
            overviewTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            overviewTitle.heightAnchor.constraint(equalToConstant: 50),
            
            firstSV.topAnchor.constraint(equalTo: overviewTitle.bottomAnchor, constant: 10),
            firstSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            secondSV.topAnchor.constraint(equalTo: overviewTitle.bottomAnchor, constant: 10),
            secondSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            additionalDetailTitle.topAnchor.constraint(equalTo: firstSV.bottomAnchor, constant: 20),
            additionalDetailTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            additionalDetailTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            additionalDetailTitle.heightAnchor.constraint(equalToConstant: 50),
            
            thirdSV.topAnchor.constraint(equalTo: additionalDetailTitle.bottomAnchor, constant: 10),
            thirdSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            thirdSV.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            fourthSV.topAnchor.constraint(equalTo: additionalDetailTitle.bottomAnchor, constant: 10),
            fourthSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            fourthSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        ])
    }
    
    func configureChart(prices: [Double]) {
        var entries: [ChartDataEntry] = []

        for (index, price) in prices.enumerated() {
            entries.append(ChartDataEntry(x: Double(index), y: price))
        }

        let dataSet = LineChartDataSet(entries: entries, label: "Price")
        dataSet.colors = [NSUIColor.systemBlue]
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 1

        let data = LineChartData(dataSet: dataSet)
        lineChartView.data = data
        lineChartView.animate(xAxisDuration: 0.5)
    }



    
    func prepareView(crypto: Crypto){
        
        let formattedPriceChangeValue = String(format: "%.2f", crypto.priceChange24H ?? 0.0)
        cryptoName.text = "\(crypto.name)"
        currentPrice.text = "$\(crypto.currentPrice ?? 0.0)"
        
        let formattedValue = String(format: "%.2f", crypto.priceChangePercentage24H ?? 0.0)
           if crypto.priceChangePercentage24H ?? 0.0 > 0.001 {
               currentPriceChange.text = "%+\(formattedValue)"
               currentPriceChange.textColor = UIColor(red: 92/255, green: 200/255, blue: 134/255, alpha: 1.0)
           } else if crypto.priceChangePercentage24H ?? 0.0 < -0.001 {
               currentPriceChange.text = "%\(formattedValue)"
               currentPriceChange.textColor = UIColor(red: 226/255, green: 84/255, blue: 97/255, alpha: 1.0)
           } else {
               currentPriceChange.text = "%\(formattedValue)"
               currentPriceChange.textColor = .systemGray
           }
        
        marketCap.text = "\(formatNumber(crypto.marketCap))"
        
        let formattedMarketCapChange = String(format: "%.2f", crypto.marketCapChangePercentage24H ?? 0.0)
            if crypto.marketCapChangePercentage24H ?? 0.0 > 0.001 {
                marketCapChange.textColor = UIColor(red: 92/255, green: 200/255, blue: 134/255, alpha: 1.0)
            } else if crypto.marketCapChangePercentage24H ?? 0.0 < -0.001 {
                marketCapChange.textColor = UIColor(red: 226/255, green: 84/255, blue: 97/255, alpha: 1.0)
            } else {
                marketCapChange.textColor = .systemGray
            }
            marketCapChange.text = "%\(formattedMarketCapChange)"
        
        rank.text = "\(crypto.marketCapRank ?? 0)"
        volume.text = "\(formatNumber(crypto.totalVolume))"
        
        maxPrice24h.text = "$\(crypto.high24H ?? 0.0)"
        minPrice24h.text = "$\(crypto.low24H ?? 0.0)"
        priceChange24h.text = "$\(formattedPriceChangeValue)"
        marketCapChange24h.text = "\(formatNumber(crypto.marketCapChange24H))"
        
        if let prices = crypto.sparklineIn7D?.price {
            configureChart(prices: prices)
           }
        viewModel.getIcon(iconUrl: crypto.image)
        
    }
    
    func changeIcon(data: Data){
        DispatchQueue.main.async {
            self.cryptoSymbol.image = UIImage(data: data)
                }
    }
    
    func showNetworkError(_ errorMessage: ErrorMessage){
        DispatchQueue.main.async {
            self.showHud(show: "Error", detailShow: errorMessage.rawValue, delay: 1.0)
        }
    }
}
