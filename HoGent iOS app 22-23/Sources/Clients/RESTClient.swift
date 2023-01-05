//
//  RESTClient.swift
//  HoGent iOS app 22-23
//
//  Created by Jens Penneman on 05/01/2023.
//

import Foundation
import Supabase

struct RESTClient {
    static let shared: SupabaseClient = SupabaseClient(supabaseURL: ClientConstants.SupabaseURL, supabaseKey: ClientConstants.SupabaseKEY)
}
