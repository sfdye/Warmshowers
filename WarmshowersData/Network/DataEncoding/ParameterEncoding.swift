//
//  ParameterEncoding.swift
//  Warmshowers
//
//  Created by Rajan Fernandez on 9/12/16.
//  Copyright © 2016 Rajan Fernandez. All rights reserved.
//

import Foundation

struct ParameterEncoding: APIRequestDataEncoder {
    
    /** Utility method that takes a dictionary of parameters, converts them to a query string, and returns the string as data for a HTTP request body. */
    func body(fromParameters parameters: [String: String]) throws -> Data {
        guard let data = parameterString(withParameters: parameters).data(using: .utf8) else {
            throw ParameterEncodingError.resultedInNoData
        }
        return data
    }
    
    // MARK - Utility methods for endcoding parameters
    
    /** Utility method to return a dictionary of parameters as a query string. */
    private func parameterString(withParameters parameters: [String: String], andJoiner joiner: String = "&", sorted: Bool = true) -> String {
        var keys: [String] = Array(parameters.keys)
        if sorted { keys.sort() }
        var components = [String]()
        for key in keys { components.append("\(key)=\(parameters[key]!)") }
        return components.joined(separator: joiner)
    }
    
}
