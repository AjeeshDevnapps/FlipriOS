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
        case owner = "Propriétaire"
        case poolType = "Type"
        case poolName = "Libellé"
        case city = "Ville"
    }
    
    enum Characteristics: String, CaseIterable {
        case Volume = "Volume"
        case Shape = "Forme"
        case CoatingType = "Revêtement"
        case Integration = "Intégration"
        case Construction = "Annee de construction"
    }
    
    enum Maintenance: String, CaseIterable {
        case Treatment = "Traitement"
        case Filtration = "Filtration"
    }
    
    enum Usage: String, CaseIterable {
        case UsagePublic = "Usage public"
        case UsersCount = "Utilisateurs"
        case Status = "Statut"
//        case Interior = "Interieur"
    }
}
