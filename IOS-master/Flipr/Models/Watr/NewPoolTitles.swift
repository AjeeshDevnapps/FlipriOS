//
//  NewPoolTitles.swift
//  Flipr
//
//  Created by Ajeesh T S on 07/08/22.
//  Copyright © 2022 I See U. All rights reserved.
//

import Foundation

struct NewPoolTitles {
    enum PoolSectionTitles: String, CaseIterable {
        case General = "GENERAL"
        case Characteristics = "CARACTERISTIQUES"
        case Maintenance = "ENTRETIEN"
        case Usage = "Usage"
    }
    
    enum PoolGeneralTitles: String, CaseIterable {
        case poolName = "Libellé "
        case owner = "Propriétaire"
        case poolType = "Type"
        case city = "City"
    }
    
    enum Characteristics: String, CaseIterable {
        case Volume = "Volume"
        case Shape = "Forme "
        case CoatingType = "Revêtement"
        case Integration = "Intégration"
        case Construction = "Année de construction"
    }
    
    enum Maintenance: String, CaseIterable {
        case Treatment = "Traitement"
        case Filtration = "Filtration"
    }
    
    enum Usage: String, CaseIterable {
        case UsagePublic = "Public"
        case UsersCount = "Utilisateurs"
        case Status = "Statut"
        case Interior = "Extérieur"
    }
}
