//
//  FirestoreQuery.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

enum FirestoreQuery {
    static func recordsBetweenDate(from here: Date, to there: Date, of userNickname: String) -> String {
        return
            """
            {
                "structuredQuery": {
                    "where": {
                        "compositeFilter": {
                            "op": "AND",
                            "filters": [
                                {
                                    "fieldFilter": {
                                        "field": {
                                            "fieldPath": "dateTime"
                                        },
                                        "op": "GREATER_THAN_OR_EQUAL",
                                        "value": {
                                            "timestampValue": "\(here.yyyyMMddTHHmmssSSZ)"
                                        }
                                    }
                                },
                                {
                                    "fieldFilter": {
                                        "field": {
                                            "fieldPath": "dateTime"
                                        },
                                        "op": "LESS_THAN_OR_EQUAL",
                                        "value": {
                                            "timestampValue": "\(there.yyyyMMddTHHmmssSSZ)"
                                        }
                                    }
                                },
                                {
                                    "fieldFilter": {
                                        "field": {
                                            "fieldPath": "username"
                                        },
                                        "op": "EQUAL",
                                        "value": {
                                            "stringValue": "\(userNickname)"
                                        }
                                    }
                                }
                            ]
                        }
                    },
                    "from": [
                        {
                            "collectionId": "records",
                            "allDescendants": true
                        }
                    ]
                }
            }
            """
    }
    static func allRecords(of userNickname: String, from offset: Int, by limit: Int) -> String {
        return
            """
            {
            "structuredQuery": {
                "where": {
                    "fieldFilter": {
                        "field": {
                            "fieldPath": "userNickname"
                        },
                        "op": "EQUAL",
                        "value": {
                            "stringValue": "\(userNickname)"
                        }
                    }
                },
            "from": [
                {
                    "collectionId": "records",
                    "allDescendants": true
                }
            ],
            "offset": \(offset),
            "limit": \(limit)
            }
        }
        """
    }
}
