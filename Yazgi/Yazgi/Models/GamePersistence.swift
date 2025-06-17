import Foundation
import SwiftUI
import UIKit

struct GameSave: Codable {
    let id: UUID
    let character: Character
    let gameTime: GameTime
    let storyProgress: [String: Bool] // Node ID'leri ve tamamlanma durumları
    let achievements: [GameAchievement]
    let saveDate: Date
    let version: String
    
    var displayName: String {
        "\(character.name) - \(character.age) yaş"
    }
}

class GamePersistence {
    static let shared = GamePersistence()
    private let fileManager = FileManager.default
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    private var documentsDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var savesDirectory: URL {
        documentsDirectory.appendingPathComponent("Saves", isDirectory: true)
    }
    
    private init() {
        createSavesDirectoryIfNeeded()
    }
    
    private func createSavesDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: savesDirectory.path) {
            do {
                try fileManager.createDirectory(at: savesDirectory, withIntermediateDirectories: true)
            } catch {
                print("Kayıt dizini oluşturulamadı: \(error)")
            }
        }
    }
    
    func saveGame(character: Character, gameTime: GameTime, storyProgress: [String: Bool], achievements: [GameAchievement]) throws {
        let save = GameSave(
            id: UUID(),
            character: character,
            gameTime: gameTime,
            storyProgress: storyProgress,
            achievements: achievements,
            saveDate: Date(),
            version: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        )
        
        let saveURL = savesDirectory.appendingPathComponent("\(save.id).yazgi")
        let data = try encoder.encode(save)
        try data.write(to: saveURL)
    }
    
    func loadGame(id: UUID) throws -> GameSave {
        let saveURL = savesDirectory.appendingPathComponent("\(id).yazgi")
        let data = try Data(contentsOf: saveURL)
        return try decoder.decode(GameSave.self, from: data)
    }
    
    func getAllSaves() -> [GameSave] {
        do {
            let saveFiles = try fileManager.contentsOfDirectory(at: savesDirectory, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "yazgi" }
            
            return try saveFiles.compactMap { url in
                let data = try Data(contentsOf: url)
                return try decoder.decode(GameSave.self, from: data)
            }
            .sorted { $0.saveDate > $1.saveDate }
        } catch {
            print("Kayıtlar yüklenemedi: \(error)")
            return []
        }
    }
    
    func deleteSave(id: UUID) throws {
        let saveURL = savesDirectory.appendingPathComponent("\(id).yazgi")
        try fileManager.removeItem(at: saveURL)
    }
    
    func exportSave(id: UUID) throws -> URL {
        let saveURL = savesDirectory.appendingPathComponent("\(id).yazgi")
        let exportURL = documentsDirectory.appendingPathComponent("YazgiExport-\(id).yazgi")
        
        if fileManager.fileExists(atPath: exportURL.path) {
            try fileManager.removeItem(at: exportURL)
        }
        
        try fileManager.copyItem(at: saveURL, to: exportURL)
        return exportURL
    }
    
    func importSave(from url: URL) throws -> GameSave {
        let data = try Data(contentsOf: url)
        let save = try decoder.decode(GameSave.self, from: data)
        
        // Yeni bir ID ile kaydet
        let newSave = GameSave(
            id: UUID(),
            character: save.character,
            gameTime: save.gameTime,
            storyProgress: save.storyProgress,
            achievements: save.achievements,
            saveDate: Date(),
            version: save.version
        )
        
        let saveURL = savesDirectory.appendingPathComponent("\(newSave.id).yazgi")
        let encodedData = try encoder.encode(newSave)
        try encodedData.write(to: saveURL)
        
        return newSave
    }
}

// MARK: - Save Management View
struct SaveManagementView: View {
    @State private var saves: [GameSave] = []
    @State private var showingDeleteAlert = false
    @State private var selectedSave: GameSave?
    @State private var showingExportSheet = false
    @State private var exportURL: URL?
    
    var onLoadGame: (GameSave) -> Void
    
    var body: some View {
        List {
            ForEach(saves, id: \.id) { save in
                SaveRow(save: save) {
                    selectedSave = save
                    showingDeleteAlert = true
                } onLoad: {
                    onLoadGame(save)
                } onExport: {
                    exportSave(save)
                }
            }
        }
        .navigationTitle("Kayıtlı Oyunlar")
        .onAppear {
            loadSaves()
        }
        .alert("Kayıt Silinecek", isPresented: $showingDeleteAlert) {
            Button("İptal", role: .cancel) { }
            Button("Sil", role: .destructive) {
                if let save = selectedSave {
                    deleteSave(save)
                }
            }
        } message: {
            if let save = selectedSave {
                Text("\(save.displayName) silinecek. Bu işlem geri alınamaz.")
            }
        }
        .sheet(isPresented: $showingExportSheet) {
            if let url = exportURL {
                ShareSheet(items: [url])
            }
        }
    }
    
    private mutating func loadSaves() {
        saves = GamePersistence.shared.getAllSaves()
    }
    
    private mutating func deleteSave(_ save: GameSave) {
        do {
            try GamePersistence.shared.deleteSave(id: save.id)
            loadSaves()
        } catch {
            print("Kayıt silinemedi: \(error)")
        }
    }
    
    private mutating func exportSave(_ save: GameSave) {
        do {
            exportURL = try GamePersistence.shared.exportSave(id: save.id)
            showingExportSheet = true
        } catch {
            print("Kayıt dışa aktarılamadı: \(error)")
        }
    }
}

struct SaveRow: View {
    let save: GameSave
    let onDelete: () -> Void
    let onLoad: () -> Void
    let onExport: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(save.displayName)
                        .font(.headline)
                    Text(save.saveDate, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Menu {
                    Button(action: onLoad) {
                        Label("Yükle", systemImage: "play.fill")
                    }
                    Button(action: onExport) {
                        Label("Dışa Aktar", systemImage: "square.and.arrow.up")
                    }
                    Button(role: .destructive, action: onDelete) {
                        Label("Sil", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                }
            }
            
            // Karakter özeti
            HStack {
                StatusIndicator(
                    icon: "brain",
                    value: save.character.intelligence,
                    color: .blue,
                    showValue: false
                )
                StatusIndicator(
                    icon: "heart.fill",
                    value: save.character.happiness,
                    color: .red,
                    showValue: false
                )
                StatusIndicator(
                    icon: "star.fill",
                    value: save.character.aura,
                    color: .yellow,
                    showValue: false
                )
                
                Spacer()
                
                Text("v\(save.version)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    NavigationStack {
        SaveManagementView { _ in }
    }
} 