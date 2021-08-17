//
//  AppsCompositionalView.swift
//  AppStoreJSONApis
//
//  Created by Elizeu RS on 17/08/21.
//

import SwiftUI

class CompositionalController: UICollectionViewController {
  
  init() {
    super.init(collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath)
    cell.backgroundColor = .red
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
    collectionView.backgroundColor = .yellow
    navigationItem.title = "Apps"
    navigationController?.navigationBar.prefersLargeTitles = true
  }
}

struct AppsView: UIViewControllerRepresentable {
  func makeUIViewController(context: UIViewControllerRepresentableContext<AppsView>) -> UIViewController {
    let controller = CompositionalController(collectionViewLayout: UICollectionViewFlowLayout())
    return UINavigationController(rootViewController: controller)
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    
  }
  
  typealias UIViewControllerType = UIViewController
  
  
}

struct AppsCompositionalView: View {
    var body: some View {
        Text("Modify")
    }
}

struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
//        AppsCompositionalView()
      AppsView()
        .edgesIgnoringSafeArea(.all)
    }
}
