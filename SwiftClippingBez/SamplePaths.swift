//
//  SamplePaths.swift
//  SwiftClippingBez
//
//  Created by Don Mag on 4/24/22.
//

import UIKit

class SamplePaths: NSObject {

	// each set of 6 values defines:
	//	curve To point
	//	control point 1
	//	control point 2
	
	let start1: CGPoint = CGPoint(x: 29, y: 134)
	let vals1: [CGFloat] = [
		15, 34, 5, 94, -6, 57,
		274, 69, 68, -22, 148, 57,
		626, 7, 420, 82, 590, 22,
		871, 102, 662, -7, 845, 33,
		789, 286, 896, 172, 877, 188,
		700, 490, 702, 383, 719, 393,
		569, 605, 682, 587, 626, 638,
		330, 503, 433, 525, 375, 594,
		180, 227, 283, 282, 295, 271,
		29, 134, 65, 182, 53, 174,
	]

	let start2: CGPoint = CGPoint(x: 240, y: 452)
	let vals2: [CGFloat] = [
		421.0, 369.0, 289.0, 452.0, 337.0, 369.0,
		676.0, 468.0, 506.0, 369.0, 581.0, 462.0,
		925.0, 369.0, 771.0, 474.0, 875.0, 385.0,
		1120.0, 397.0, 976.0, 354.0, 1090.0, 334.0,
		1086.0, 581.0, 1150.0, 460.0, 1119.0, 519.0,
		1127.0, 770.0, 1053.0, 643.0, 1173.0, 669.0,
		997.0, 845.0, 1081.0, 871.0, 1093.0, 857.0,
		786.0, 790.0, 902.0, 833.0, 910.0, 790.0,
		536.0, 854.0, 663.0, 790.0, 710.0, 860.0,
		290.0, 731.0, 362.0, 848.0, 405.0, 742.0,
		92.0, 770.0, 174.0, 721.0, 181.0, 794.0,
		3.0, 652.0, 3.0, 746.0, 3.0, 705.0,
		92.0, 519.0, 3.0, 587.0, 13.0, 550.0,
		171.0, 452.0, 172.0, 489.0, 131.0, 464.0,
		240.0, 452.0, 211.0, 439.0, 191.0, 452.0
	]

	func samplePath(_ n: Int) -> UIBezierPath {
		var pt: CGPoint = .zero
		var c1: CGPoint = .zero
		var c2: CGPoint = .zero
		
		var start: CGPoint = .zero
		var vals: [CGFloat] = []
		
		if n == 1 {
			start = start1
			vals = vals1
		} else {
			start = start2
			vals = vals2
		}
		
		let bez = UIBezierPath()
		
		pt = start
		bez.move(to: pt)
		
		for i in stride(from: 0, to: vals.count, by: 6) {
			pt = CGPoint(x: vals[i + 0], y: vals[i + 1])
			c1 = CGPoint(x: vals[i + 2], y: vals[i + 3])
			c2 = CGPoint(x: vals[i + 4], y: vals[i + 5])
			bez.addCurve(to: pt, controlPoint1: c1, controlPoint2: c2)
		}
		
		bez.close()
		
		return bez
	}
	
}
