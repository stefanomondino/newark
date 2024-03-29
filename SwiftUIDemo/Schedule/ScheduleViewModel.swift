//
//  ScheduleViewModel.swift
//  SwiftUIDemo
//
//  Created by Stefano Mondino on 03/11/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import Foundation
import SwiftUIBoomerang
import CombineBoomerang
import Combine
import Boomerang

class ScheduleViewModel: CombineListViewModel, NavigationViewModel, ObservableObject {

    var sectionsSubject: CurrentValueSubject<[Boomerang.Section], Never> = CurrentValueSubject([])

    var cancellables: [AnyCancellable] = []

    var objectWillChange: ObservableObjectPublisher = ObservableObjectPublisher()

    var onNavigation: (Route) -> Void = { _ in }

    let layoutIdentifier: LayoutIdentifier

    var downloadTask: Task?

    @Published var currentSelection: IdentifiableViewModel?

    init(identifier: SceneIdentifier = .schedule) {
        self.layoutIdentifier = identifier
    }

    static func demo() -> ScheduleViewModel {
        let viewModel = ScheduleViewModel()

        viewModel.sections = [Section(id: "Schedule",
                               items: (0..<20).map { ShowViewModel.demo($0)})]
        return viewModel
    }

    func reload() {
        downloadTask?.cancel()
        downloadTask = URLSession.shared.getEntity([Episode].self, from: .schedule) {[weak self] result in
            switch result {
            case .success(let episodes):
                self?.sections = [Section(id: "Schedule",
                                          items: episodes.map { ShowViewModel(episode: $0)},
                                          header: ShowViewModel.demo(),
                                          footer: ShowViewModel.demo(10)
                                          )]
            case .failure(let error):
                print(error)
            }
        }
    }
    func selectItem(at indexPath: IndexPath) {
//        if let viewModel = self[indexPath] as? ShowViewModel {
//            onNavigation(NavigationRoute(viewModel: ShowDetailViewModel(show: viewModel.show)))
//        }
    }
}
