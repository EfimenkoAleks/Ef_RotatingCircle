//
//  CircleViewController.swift
//  Ef_RotatingCircle
//
//  Created by Aleksandr on 01.02.2024.
//

import UIKit

class CircleViewController: UIViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var buttonsStack: UIStackView!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    
    private var roundView: RoundView?
    private var lineView1: LineView?
    private var lineView2: LineView?
    private let frame = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    @IBAction private func didTabPlusButton(_ sender: UIButton) {
        roundView?.setScale(.plus)
    }
    
    @IBAction private func didTapMinusButton(_ sender: UIButton) {
        roundView?.setScale(.minus)
    }
}

private extension CircleViewController {
    
    func setup() {
        view.backgroundColor = .white
        addRoundView()
        addLineView()
    }
    
    func addRoundView() {
        roundView = RoundView(frame: CGRect(x: (frame.width / 2 - 50), y: (frame.height / 2 - 50), width: 100, height: 100))
        guard let roundView = roundView else { return }
        view.addSubview(roundView)
    }
    
    func addLineView() {
        lineView1 = LineView(startY: (frame.height / 2 - 60))
        lineView2 = LineView(startY: (frame.height / 2 + 50))
        guard let lineView1 = lineView1,
        let lineView2 = lineView2 else { return }
        view.addSubview(lineView1)
        view.addSubview(lineView2)
    }
}
