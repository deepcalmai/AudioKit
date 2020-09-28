// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Triggerable classic ADSR envelope
public class AmplitudeEnvelope: Node, AudioUnitContainer, Tappable, Toggleable {

    public static let ComponentDescription = AudioComponentDescription(effect: "adsr")

    public typealias AudioUnitType = InternalAU

    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    public static let attackDurationDef = NodeParameterDef(
        identifier: "attackDuration",
        name: "Attack time",
        address: akGetParameterAddress("AmplitudeEnvelopeParameterAttackDuration"),
        range: 0 ... 99,
        unit: .seconds,
        flags: .default)

    /// Attack time
    @Parameter public var attackDuration: AUValue

    public static let decayDurationDef = NodeParameterDef(
        identifier: "decayDuration",
        name: "Decay time",
        address: akGetParameterAddress("AmplitudeEnvelopeParameterDecayDuration"),
        range: 0 ... 99,
        unit: .seconds,
        flags: .default)

    /// Decay time
    @Parameter public var decayDuration: AUValue

    public static let sustainLevelDef = NodeParameterDef(
        identifier: "sustainLevel",
        name: "Sustain Level",
        address: akGetParameterAddress("AmplitudeEnvelopeParameterSustainLevel"),
        range: 0 ... 99,
        unit: .generic,
        flags: .default)

    /// Sustain Level
    @Parameter public var sustainLevel: AUValue

    public static let releaseDurationDef = NodeParameterDef(
        identifier: "releaseDuration",
        name: "Release time",
        address: akGetParameterAddress("AmplitudeEnvelopeParameterReleaseDuration"),
        range: 0 ... 99,
        unit: .seconds,
        flags: .default)

    /// Release time
    @Parameter public var releaseDuration: AUValue

    // MARK: - Audio Unit

    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [NodeParameterDef] {
            [AmplitudeEnvelope.attackDurationDef,
             AmplitudeEnvelope.decayDurationDef,
             AmplitudeEnvelope.sustainLevelDef,
             AmplitudeEnvelope.releaseDurationDef]
        }

        public override func createDSP() -> DSPRef {
            akCreateDSP("AmplitudeEnvelopeDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this envelope node
    ///
    /// - Parameters:
    ///   - input: Input node to process
    ///   - attackDuration: Attack time
    ///   - decayDuration: Decay time
    ///   - sustainLevel: Sustain Level
    ///   - releaseDuration: Release time
    ///
    public init(
        _ input: Node,
        attackDuration: AUValue = 0.1,
        decayDuration: AUValue = 0.1,
        sustainLevel: AUValue = 1.0,
        releaseDuration: AUValue = 0.1
        ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit

            self.attackDuration = attackDuration
            self.decayDuration = decayDuration
            self.sustainLevel = sustainLevel
            self.releaseDuration = releaseDuration
        }
        connections.append(input)
    }
}
