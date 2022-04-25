//
//  ViewController.swift
//  SwiftClippingBez
//
//  Created by Don Mag on 4/24/22.
//

import UIKit

import ClippingBezier

class ViewController: UIViewController {

	let testView: TestView = {
		let v = TestView()
		v.backgroundColor = .white
		return v
	}()
	
	let infoLabel: UILabel = {
		let v = UILabel()
		v.textAlignment = .center
		return v
	}()

	// index to step through examples
	var idx: Int = 0

	override func viewDidLoad() {
		super.viewDidLoad()
	
		view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

		// create a stack view
		let stack: UIStackView = {
			let v = UIStackView()
			v.axis = .vertical
			v.spacing = 8
			v.translatesAutoresizingMaskIntoConstraints = false
			return v
		}()
		
		// create a button
		let btn: UIButton = {
			let v = UIButton()
			v.setTitle("Next Step", for: [])
			v.setTitleColor(.white, for: .normal)
			v.setTitleColor(.lightGray, for: .highlighted)
			v.backgroundColor = .systemBlue
			v.layer.cornerRadius = 8
			v.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
			return v
		}()
		
		// add elements to stack view
		[infoLabel, testView, btn].forEach { v in
			stack.addArrangedSubview(v)
		}
		
		stack.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stack)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			stack.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			stack.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			
			// let's use 300 x 300 for our test view
			testView.widthAnchor.constraint(equalToConstant: 300.0),
			testView.heightAnchor.constraint(equalTo: testView.widthAnchor),
		])
		
		// set the bezier path shapes
		testView.path1 = SamplePaths().samplePath(1)
		testView.path2 = SamplePaths().samplePath(2)
		
		// get started
		nextStep()

	}

	
	@objc func nextStep() {
		
		switch idx % 4 {
		case 1:
			infoLabel.text = "Stroke Second Path"
			testView.show = .second
		case 2:
			infoLabel.text = "Stroke Both Paths"
			testView.show = .both
		case 3:
			infoLabel.text = "Stroke only the Clipped Path"
			testView.show = .clippedPath
		default:
			infoLabel.text = "Stroke First Path"
			testView.show = .first
		}

		idx += 1
		
	}

}

class TestView: UIView {
	
	enum Show {
		case both
		case first
		case second
		case clippedPath
	}
	
	public var show: Show = .both {
		didSet {
			setNeedsDisplay()
		}
	}
	
	public var path1: UIBezierPath!
	public var path2: UIBezierPath!
	
	override func draw(_ rect: CGRect) {

		// don't do anything if we don't have valid paths
		guard let path1 = self.path1,
			  let path2 = self.path2
		else { return }
		
		// this fits the paths into self.bounds
		let margin: CGFloat = 8
		let fittingBounds = self.bounds.insetBy(dx: margin, dy: margin)
		let entireBounds = path1.bounds.union(path2.bounds)
		let scale = min(fittingBounds.size.width / entireBounds.size.width, fittingBounds.size.height / entireBounds.size.height)
		var transform: CGAffineTransform = .identity
		transform = transform.translatedBy(x: margin, y: margin)
		transform = transform.scaledBy(x: scale, y: scale)
		
		let ctx = UIGraphicsGetCurrentContext()
		ctx?.saveGState()
		ctx?.concatenate(transform)

		path1.lineWidth = 4
		path2.lineWidth = 4

		switch show {
		case .first:
			UIColor.systemGreen.setStroke()
			path1.stroke()
			
		case .second:
			UIColor.blue.setStroke()
			path2.stroke()
			
		case .clippedPath:
			// get the unique shapes from slicing path2 with path1
			guard let shapes: [DKUIBezierPathShape] = path2.uniqueShapesCreatedFromSlicing(withUnclosedPath: path1) else { return }
			// get the first shape
			guard let shape: DKUIBezierPathShape = shapes.first else { return }
			// get the first segment
			guard let seg = shape.segments.firstObject as? DKUIBezierPathClippedSegment else { return }
			// get the path from that segment
			let pth: UIBezierPath = seg.pathSegment
			// stroke that segment's path
			UIColor.red.setStroke()
			pth.stroke()
			
			// print the segment's path to the debug console
			print(pth)
			
		default:
			UIColor.systemGreen.setStroke()
			path1.stroke()
			UIColor.blue.setStroke()
			path2.stroke()
			
		}
		
		ctx?.restoreGState()
	}

}
