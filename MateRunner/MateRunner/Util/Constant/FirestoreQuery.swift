//
//  FirestoreQuery.swift
//  MateRunner
//
//  Created by 전여훈 on 2021/11/24.
//

import Foundation

enum FirestoreQuery {
    static func recordsBetweenDate(from here: Date, to there: Date, of userNickname: String) -> Data? {
        return
            """
            { "structuredQuery": {
                    "where": { "compositeFilter": {
                            "op": "AND",
                            "filters": [
                                { "fieldFilter": { "field": { "fieldPath": "dateTime" },
                                        "op": "GREATER_THAN_OR_EQUAL",
                                        "value": { "timestampValue": "\(here.yyyyMMddTHHmmssSSZ)" }
                                }},
                                { "fieldFilter": { "field": { "fieldPath": "dateTime" },
                                        "op": "LESS_THAN_OR_EQUAL",
                                        "value": { "timestampValue": "\(there.yyyyMMddTHHmmssSSZ)" }
                                }},
                                { "fieldFilter": { "field": { "fieldPath": "ownerID" },
                                        "op": "EQUAL",
                                        "value": { "stringValue": "\(userNickname)" }
                                }}
                            ]
                        }
                    },
                    "from": [ { "collectionId": "records", "allDescendants": true } ]
                }
            }
            """.data(using: .utf8)
    }
    
    static func allRecords(of userNickname: String, from offset: Int, by limit: Int) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": { "collectionId": "records", "allDescendants": true },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "ownerID" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(userNickname)" }
                    }
                },
                "orderBy": {
                    "field": {
                        "fieldPath" : "runningID"
                    },
                    "direction" : "DESCENDING"
                },
                "offset": \(offset),
                "limit": \(limit)
            }
        }
        """.data(using: .utf8)
    }
    
    static func append(mate newNickname: String, to targetNickname: String) -> Data? {
        return """
        {
            "writes": {
                "transform": {
                    "document": "projects/mate-runner-e232c/databases/(default)/documents/User/\(targetNickname)",
                    "fieldTransforms": [
                        {
                            "setToServerValue": "REQUEST_TIME",
                            "fieldPath": "lastUpdate"
                        },
                        {
                            "appendMissingElements": {
                                "values": [
                                    {
                                        "stringValue": "\(newNickname)"
                                    }
                                ]
                            },
                            "fieldPath": "mate"
                        }
                    ]
                }
            }
        }
        """.data(using: .utf8)
    }
    
    static func remove(mate nickname: String, from targetNickname: String) -> Data? {
        return """
        {
            "writes": {
                "transform": {
                    "document": "projects/mate-runner-e232c/databases/(default)/documents/User/\(targetNickname)",
                    "fieldTransforms": [
                        {
                            "setToServerValue": "REQUEST_TIME",
                            "fieldPath": "lastUpdate"
                        },
                        {
                            "removeAllFromArray": {
                                "values": [
                                    {
                                        "stringValue": "\(nickname)"
                                    }
                                ]
                            },
                            "fieldPath": "mate"
                        }
                    ]
                }
            }
        }
        """.data(using: .utf8)
    }
    
    static func nameFilter(by text: String, selfNickname: String) -> Data? {
        return"""
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "User",
                    "allDescendants": true
                },
                "where": {
                    "compositeFilter": {
                        "op": "AND",
                        "filters": [
                            {
                                "fieldFilter": {
                                    "field": {
                                        "fieldPath": "nickname"
                                    },
                                    "op": "GREATER_THAN_OR_EQUAL",
                                    "value": {
                                        "stringValue": "\(text)"
                                    }
                                }
                            },
                            {
                                "fieldFilter": {
                                    "field": {
                                        "fieldPath": "nickname"
                                    },
                                    "op": "LESS_THAN_OR_EQUAL",
                                    "value": {
                                        "stringValue": "\(text)\u{00B0}"
                                    }
                                }
                            },
                            {
                                "fieldFilter": {
                                    "field": {
                                        "fieldPath": "nickname"
                                    },
                                    "op": "NOT_EQUAL",
                                    "value": {
                                        "stringValue": "\(selfNickname)"
                                    }
                                }
                            }
                        ]
                    }
                }
            }
        }
        """.data(using: .utf8)
    }
    
    static func uidFilter(by nickname: String) -> Data? {
        return """
        {
            "structuredQuery": {
                "from": {
                    "collectionId": "UID",
                },
                "where": {
                    "fieldFilter": {
                        "field": { "fieldPath": "nickname" },
                        "op": "EQUAL",
                        "value": { "stringValue": "\(nickname)" }
                    }
                }
            }
        }
        """.data(using: .utf8)
    }
}
