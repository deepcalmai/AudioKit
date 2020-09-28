// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Reads from the table sequentially and repeatedly at given frequency.
/// Linear interpolation is applied for table look up from internal phase values.
/// 
public class Oscillator: Node, AudioUnitContainer, Tappable, Toggleable {

    public static let ComponentDescription = AudioComponentDescription(generator: "oscl")

    public typealias AudioUnitType = InternalAU

    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    fileprivate var waveform: Table?

    public static let frequencyDef = NodeParameterDef(
        identifier: "frequency",
        name: "Frequency (Hz)",
        address: akGetParameterAddress("OscillatorParameterFrequency"),
        range: 0.0 ... 20_000.0,
        unit: .hertz,
        flags: .default)

    /// Frequency in cycles per second
    @Parameter public var frequency: AUValue

    public static let amplitudeDef = NodeParameterDef(
        identifier: "amplitude",
        name: "Amplitude",
        address: akGetParameterAddress("OscillatorParameterAmplitude"),
        range: 0.0 ... 10.0,
        unit: .generic,
        flags: .default)

    /// Output Amplitude.
    @Parameter public var amplitude: AUValue

    public static let detuningOffsetDef = NodeParameterDef(
        identifier: "detuningOffset",
        name: "Frequency offset (Hz)",
        address: akGetParameterAddress("OscillatorParameterDetuningOffset"),
        range: -1_000.0 ... 1_000.0,
        unit: .hertz,
        flags: .default)

    /// Frequency offset in Hz.
    @Parameter public var detuningOffset: AUValue

    public static let detuningMultiplierDef = NodeParameterDef(
        identifier: "detuningMultiplier",
        name: "Frequency detuning multiplier",
        address: akGetParameterAddress("OscillatorParameterDetuningMultiplier"),
        range: 0.9 ... 1.11,
        unit: .generic,
        flags: .default)

    /// Frequency detuning multiplier
    @Parameter public var detuningMultiplier: AUValue

    // MARK: - Audio Unit

    public class InternalAU: AudioUnitBase {

        public override func getParameterDefs() -> [NodeParameterDef] {
            [Oscillator.frequencyDef,
             Oscillator.amplitudeDef,
             Oscillator.detuningOffsetDef,
             Oscillator.detuningMultiplierDef]
        }

        public override func createDSP() -> DSPRef {
            akCreateDSP("OscillatorDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this oscillator node
    ///
    /// - Parameters:
    ///   - waveform: The waveform of oscillation
    ///   - frequency: Frequency in cycles per second
    ///   - amplitude: Output Amplitude.
    ///   - detuningOffset: Frequency offset in Hz.
    ///   - detuningMultiplier: Frequency detuning multiplier
    ///
    public init(
        waveform: Table = Table(.sine),
        frequency: AUValue = 440.0,
        amplitude: AUValue = 1.0,
        detuningOffset: AUValue = 0.0,
        detuningMultiplier: AUValue = 1.0
    ) {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit
            self.stop()

            audioUnit.setWavetable(waveform.content)

            self.waveform = waveform
            self.frequency = frequency
            self.amplitude = amplitude
            self.detuningOffset = detuningOffset
            self.detuningMultiplier = detuningMultiplier
        }
    }
}
