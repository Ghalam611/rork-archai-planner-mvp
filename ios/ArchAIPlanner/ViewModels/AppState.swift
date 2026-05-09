//
//  AppState.swift
//  ArchAIPlanner
//
//  Created by Rork on May 8, 2026.
//

import SwiftUI

@Observable
final class AppState {
    var isAuthenticated: Bool = false
    var projects: [DesignProject] = DesignProject.samples
    var selectedProject: DesignProject?
    var userName: String = "Founder"

    func save(project: DesignProject) {
        projects.insert(project, at: 0)
        selectedProject = project
    }
}
