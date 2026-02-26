//
//  AppRoute.swift.swift
//  TulumDeliverys
//
//  Created by Sergio Torres Landa González on 24/02/26.
//
// AppRoute.swift
import Foundation

enum AppRoute: Hashable {
    case cart
    case map
    case rate
    case productDetails(id: String) // Passing data strictly via the route
    case sduiScreen(id: String)     // Backend-driven fallback
}

