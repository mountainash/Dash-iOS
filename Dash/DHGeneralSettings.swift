//
//  GeneralSettingsTableView.swift
//  Dash iOS
//
//  Created by chenhaoyu.1999 on 2021/3/29.
//  Copyright © 2021 Kapeli. All rights reserved.
//

class DHGeneralSettings: UITableViewController {
    
    let sharedPreference = DHAppPreference.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = "General Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.backgroundColor = .secondarySystemBackground
    }
    
    var sections: [SettingSection] = []
    
    enum SettingSection: String {
        case themeSetting
        case selectTheme
        case automaticUpdates
        case sortAlphabetically
        var title: String? {
            switch self {
            case .themeSetting:
                return "Theme Setting"
            case .selectTheme:
                return "Select Theme"
            case .automaticUpdates:
                return "Other Settings"
            default:
                return nil
            }
        }
        var rowCount: Int {
            switch self {
            case .themeSetting:
                return 1
            case .selectTheme:
                return 2
            default:
                return 1
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if DHAppPreference.shared.followSystemSetting {
            sections = [.themeSetting, .automaticUpdates, .sortAlphabetically]
        } else {
            sections = [.themeSetting, .selectTheme, .automaticUpdates, .sortAlphabetically]
        }
        return sections.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rowCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        if section == .themeSetting {
            return switchCell(title: "Use System Theme Setting", isOn: { DHAppPreference.shared.followSystemSetting}, action: #selector(themeSettingChanged(_:)))
        } else if section == .selectTheme {
            if indexPath.item == 0 {
                return checkmarkCell(title: "Light Theme", isChecked: { DHAppPreference.shared.customInterfaceStyle == .light })
            } else {
                return checkmarkCell(title: "Dark Theme") { DHAppPreference.shared.customInterfaceStyle == .dark }
            }
        } else if section == .automaticUpdates {
            if indexPath.item
             == 0 {
                return switchCell(title: "Automatic Updates", isOn: {sharedPreference.automaticallyCheckForUpdates}, action: #selector(automaticUpdatesSettingChanged(_:)))
            }
        } else if section == .sortAlphabetically {
            return switchCell(title: "Sort Alphabetically", isOn: {sharedPreference.docSetAlphabetizing}, action: #selector(sortAlphabeticallySettingChanged(_:)))
        }
        fatalError("")
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = sections[section]
        if section == .automaticUpdates {
            return "Dash \(sharedPreference.automaticallyCheckForUpdates ? "will" : "won't") notify when docset updates are avaliable."
        } else if section == .sortAlphabetically {
            return "Docsets \(sharedPreference.docSetAlphabetizing ? "will" : "won't") be sorted alphabetically in the docset browser."
        }
        return nil
    }
    
    func switchCell(title: String, isOn: () -> Bool, action: Selector) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        cell.selectionStyle = .none
        cell.textLabel?.text = title
        let uiSwitch = UISwitch()
        uiSwitch.isOn = isOn()
        uiSwitch.addTarget(self, action: action, for: .valueChanged)
        cell.accessoryType = .none
        cell.accessoryView = uiSwitch
        cell.backgroundColor = .tertiarySystemGroupedBackground
        return cell
    }
    
    func checkmarkCell(title: String, isChecked: () -> Bool ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        cell.selectionStyle = .none
        cell.textLabel?.text = title
        cell.accessoryView = nil
        cell.accessoryType = isChecked() ? .checkmark : .none
        cell.backgroundColor = .tertiarySystemBackground
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if section == .selectTheme {
            if indexPath.row == 0 {
                useLightTheme()
            } else if indexPath.row == 1 {
                useDarkTheme()
            }
        }
    }
    
    @objc func themeSettingChanged(_ sender: UISwitch) {
        DHAppPreference.shared.followSystemSetting = sender.isOn
        if DHAppPreference.shared.customInterfaceStyle != UITraitCollection.current.userInterfaceStyle {
            DHAppPreference.shared.customInterfaceStyle = UITraitCollection.current.userInterfaceStyle
        }
        if sender.isOn {
            tableView.deleteSections([1], with: .fade)
        } else {
            tableView.insertSections([1], with: .fade)
        }
    }
    
    @objc func automaticUpdatesSettingChanged(_ sender: UISwitch) {
        CATransaction.setCompletionBlock { [weak self] in
            self?.sharedPreference.automaticallyCheckForUpdates = sender.isOn
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self?.reload()
            }
        }
    }
    
    @objc func sortAlphabeticallySettingChanged(_ sender: UISwitch) {
        CATransaction.setCompletionBlock { [weak self] in
            self?.sharedPreference.docSetAlphabetizing = sender.isOn
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self?.reload()
            }
        }
    }
    
    @objc func useLightTheme() {
        DHAppPreference.shared.customInterfaceStyle = .light
        reload()
    }
    
    @objc func useDarkTheme() {
        DHAppPreference.shared.customInterfaceStyle = .dark
        reload()
    }
    
    func reload() {
        tableView.reloadData()
    }
}
