//
//  ContentView.swift
//  MaterialBug
//
//  Created by Phil Zakharchenko on 4/6/25.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: MaterialBugDocument
    
    init(document: Binding<MaterialBugDocument>) {
        self._document = document
    }

    var body: some View {
        ScrollView {
            Text("This is crazy")
                .font(.largeTitle)
            
            Grid {
                GridRow {
                    Image(.leopardIPad)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300)
                    
                    Image(.lionIPadV2)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300)
                }
                
                GridRow {
                    Image(.snowLeopardIPadV2)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300)
                    
                    Image(.mountainIPad)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300)
                }
            }
        }
        .onAppear {
            print("View appeared.")
            
            let scenes = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let window = scenes?.windows.first
            window?.rootViewController?.view.printViewHierarchy()
            
            // Uncomment to apply the workaround:
            // window?.rootViewController?.view.cleanupRedundantViews(withClassNameContaining: "_UIHostingView")
        }
        .onDisappear {
            print("View disappeared.")
        }
    }
}

extension UIView {
    func printViewHierarchy(level: Int = 0) {
        let indent = String(repeating: "  ", count: level)
        let className = "\(type(of: self))"
        let frame = self.frame
        let tag = self.tag
        let identifier = self.accessibilityIdentifier ?? "nil"
        
        print("\(indent)• \(className): frame=\(frame), tag=\(tag), accessibilityID=\(identifier)")
        
        if let label = self as? UILabel {
            print("\(indent)  text: \"\(label.text ?? "nil")\"")
        } else if let button = self as? UIButton {
            let title = button.title(for: .normal) ?? "nil"
            print("\(indent)  title: \"\(title)\"")
        } else if let textField = self as? UITextField {
            print("\(indent)  text: \"\(textField.text ?? "nil")\"")
        } else if let imageView = self as? UIImageView {
            print("\(indent)  image: \(imageView.image != nil ? "set" : "nil")")
        } else if let tableView = self as? UITableView {
            print("\(indent)  rows: \(tableView.numberOfRows(inSection: 0))")
        }
        
        for subview in self.subviews {
            subview.printViewHierarchy(level: level + 1)
        }
    }
}

extension UIView {
    /// Removes redundant sibling view instances of the same class containing the provided substring in their class name, keeping only one instance per group of sibling views.
    func cleanupRedundantViews(withClassNameContaining classNameSubstring: String) {
        func processViewGroup(_ viewGroup: [UIView]) {
            // Group sibling views by their class name.
            var viewsByClassName: [String: [UIView]] = [:]
            
            for view in viewGroup {
                let className = NSStringFromClass(type(of: view))
                if className.contains(classNameSubstring) {
                    viewsByClassName[className, default: []].append(view)
                }
                
                // Recursively process this view's children.
                processViewGroup(view.subviews)
            }
            
            // For each group of same-class views with the matching size, keep only one.
            for (_, views) in viewsByClassName where views.count > 1 {
                // Keep the last one, remove the rest.
                for view in views.dropLast() {
                    view.removeFromSuperview()
                    print("Removing \(view)...")
                }
            }
        }
        
        // Start with the root view's immediate subviews.
        processViewGroup(self.subviews)
    }
}
