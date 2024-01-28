//
//  File.swift
//  
//
//  Created by Nikola Matijevic on 21.12.23..
//

import Foundation

import Foundation

final class DefaultErrorResolver: DataTransferErrorResolver {

    func resolve(error: NetworkError) -> Error {

        switch error {

        case .error(_, let data):
            if let data, let errorDTO = try? JSONDecoder().decode(ErrorDTO.self, from: data) {

                return LBError.descriptive(errorDTO.message)
            }
            return error

        default:
            return error
        }
    }
}

enum LBError: Error {
    case descriptive(String)
}
