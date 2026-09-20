import Foundation
import SwiftData

// MARK: - Plan (set up when calm)

@Model
public final class Plan {
    public var defaultTechnique: TechniqueKind
    public var alternateTechnique: TechniqueKind
    public var pacedBreathsPerMinute: Double
    public var voiceID: String
    public var voiceEnabled: Bool
    public var defaultBreakMinutes: Int
    public var shortenedBreakNoteSeen: Bool
    public var coldWaterAcknowledged: Bool
    public var movementAcknowledged: Bool
    public var warningSigns: [String]
    public var favoriteWords: [String]
    public var emaWindows: [EMAWindow]
    public var notificationDailyCap: Int
    public var quietHoursStart: Int   // hour 0-23
    public var quietHoursEnd: Int
    public var onDeviceOnlyAI: Bool
    @Relationship(deleteRule: .cascade) public var profiles: [RelationshipProfile]
    @Relationship(deleteRule: .cascade) public var secureBase: [SecureBaseItem]

    public init() {
        defaultTechnique = .physiologicalSigh
        alternateTechnique = .orienting
        pacedBreathsPerMinute = 5.5
        voiceID = "free-default"
        voiceEnabled = true
        defaultBreakMinutes = 20
        shortenedBreakNoteSeen = false
        coldWaterAcknowledged = false
        movementAcknowledged = false
        warningSigns = []
        favoriteWords = []
        emaWindows = EMAWindow.defaults
        notificationDailyCap = 4
        quietHoursStart = 22
        quietHoursEnd = 8
        onDeviceOnlyAI = false
        profiles = []
        secureBase = []
    }
}

@Model
public final class RelationshipProfile {
    public var name: String
    public var breakScript: String
    public var reframes: [String]
    public var intention: String
    public var codeWord: String?
    public var isPaired: Bool
    public var createdAt: Date

    public init(name: String, breakScript: String, reframes: [String], intention: String) {
        self.name = name
        self.breakScript = breakScript
        self.reframes = reframes
        self.intention = intention
        self.codeWord = nil
        self.isPaired = false
        self.createdAt = .now
    }
}

@Model
public final class SecureBaseItem {
    public var kind: SecureBaseKind
    public var title: String
    public var text: String?
    @Attribute(.externalStorage) public var imageData: Data?
    @Attribute(.externalStorage) public var audioData: Data?
    public init(kind: SecureBaseKind, title: String, text: String? = nil) {
        self.kind = kind; self.title = title; self.text = text
    }
}

public enum SecureBaseKind: String, Codable, Sendable, CaseIterable { case person, memory, photo, voiceNote, line }

// MARK: - Session (a reset)

@Model
public final class Session {
    public var id: UUID
    public var startedAt: Date
    public var endedAt: Date?
    public var entrySurface: EntrySurface
    public var device: DeviceKind
    public var technique: TechniqueKind
    public var profileName: String?
    public var hotBefore: Int?
    public var hotAfter: Int?
    public var hrBefore: Double?
    public var hrAfter: Double?
    public var feelingWords: [String]
    public var thirdPersonLine: String?
    public var decision: SessionDecision?
    public var breakMinutes: Int?
    public var breakReturnAt: Date?
    public var breakExtensions: Int
    public var breakIsPrivate: Bool
    public var returnCompleted: Bool?
    public var debriefOutcome: DebriefOutcome?
    public var debriefRepaired: Bool?
    public var debriefNote: String?

    public init(entrySurface: EntrySurface, device: DeviceKind, technique: TechniqueKind) {
        id = UUID(); startedAt = .now
        self.entrySurface = entrySurface; self.device = device; self.technique = technique
        feelingWords = []; breakExtensions = 0; breakIsPrivate = false
    }
}

public enum EntrySurface: String, Codable, Sendable, CaseIterable { case actionButton, lockScreenWidget, homeWidget, controlCenter, siri, watchComplication, watchApp, inApp, suggestion }
public enum DeviceKind: String, Codable, Sendable { case iPhone, watch }
public enum SessionDecision: String, Codable, Sendable { case returnNow, takeBreak, holdMessage, okay }
public enum DebriefOutcome: String, Codable, Sendable { case better, same, worse }

// MARK: - Hold (a held message)

@Model
public final class Hold {
    public var id: UUID
    public var createdAt: Date
    public var delayMinutes: Int
    public var draft: String
    public var rewrite: String?
    public var hotAtStart: Int?
    public var hotAtEnd: Int?
    public var outcome: HoldOutcome?
    public var reflection: HoldReflection?
    public init(draft: String, delayMinutes: Int) {
        id = UUID(); createdAt = .now; self.draft = draft; self.delayMinutes = max(10, delayMinutes)
    }
}
public enum HoldOutcome: String, Codable, Sendable { case deleted, edited, sent }
public enum HoldReflection: String, Codable, Sendable { case gladIWaited, stillWantedToSend, unsure }

// MARK: - CheckIn (EMA)

@Model
public final class CheckIn {
    public var id: UUID
    public var promptedAt: Date
    public var answeredAt: Date?
    public var trigger: CheckInTrigger
    public var hot: Int?
    public var word: String?
    public var connected: Int?          // 1-7
    public var urge: UrgeLevel?
    public var rotatingItem: String?
    public var rotatingValue: Int?
    public var loadShownAfter: Bool
    public init(promptedAt: Date, trigger: CheckInTrigger) {
        id = UUID(); self.promptedAt = promptedAt; self.trigger = trigger; loadShownAfter = false
    }
}
public enum CheckInTrigger: String, Codable, Sendable { case scheduled, afterReset, afterReturn }
public enum UrgeLevel: String, Codable, Sendable { case none, small, strong }

// MARK: - Baseline (derived, on device only; never synced)

@Model
public final class BaselineSnapshot {
    public var date: Date
    public var metric: BaselineMetric
    public var median14: Double?
    public var median28: Double?
    public var latest: Double?
    public init(date: Date, metric: BaselineMetric) { self.date = date; self.metric = metric }
}
public enum BaselineMetric: String, Codable, Sendable, CaseIterable { case restingHR, hrvSDNN, respiratoryRate, sleepHours, wristTemperatureDelta }

// MARK: - Event log (append-only; research export source; schema versioned)

@Model
public final class Event {
    public var at: Date
    public var schemaVersion: Int
    public var kind: String
    public var sessionID: UUID?
    public var payload: String?   // small JSON string; never raw biosignals
    public init(kind: String, sessionID: UUID? = nil, payload: String? = nil) {
        at = .now; schemaVersion = 1; self.kind = kind; self.sessionID = sessionID; self.payload = payload
    }
}

// MARK: - EMA window value type

public struct EMAWindow: Codable, Sendable, Equatable {
    public var startHour: Int
    public var endHour: Int
    public init(startHour: Int, endHour: Int) { self.startHour = startHour; self.endHour = endHour }
    public static let defaults = [EMAWindow(startHour: 10, endHour: 13), EMAWindow(startHour: 18, endHour: 21)]
}

/// All persisted model types; pass to `ModelContainer(for:)`.
public let steadySchemaModels: [any PersistentModel.Type] = [
    Plan.self, RelationshipProfile.self, SecureBaseItem.self, Session.self, Hold.self,
    CheckIn.self, BaselineSnapshot.self, Event.self
]
