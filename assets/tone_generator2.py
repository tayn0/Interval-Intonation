import numpy as np
from scipy.io.wavfile import write
import os

def generate_sine_wave(freq, duration=1.5, sample_rate=44100, amplitude=0.5, fade_duration=0.01):
    total_samples = int(sample_rate * duration)
    t = np.linspace(0, duration, total_samples, endpoint=False)
    wave = amplitude * np.sin(2 * np.pi * freq * t)

    fade_samples = int(fade_duration * sample_rate)
    if fade_samples > 0:
        fade = np.linspace(1, 0, fade_samples)
        wave[-fade_samples:] *= fade

    return wave

def save_wav(filename, data, sample_rate=44100):
    scaled = np.int16(data / np.max(np.abs(data)) * 32767)
    write(filename, sample_rate, scaled)

def note_name(midi):
    names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    octave = (midi // 12) - 1
    return f"{names[midi % 12]}{octave}"

def midi_to_freq(midi):
    return 440.0 * (2 ** ((midi - 69) / 12))

def cents_to_freq(freq, cents):
    return freq * (2 ** (cents / 1200.0))

def main():
    base_dir = os.path.join("sounds")

    intervals = {
        "Major Second": 2,
        "Minor Third": 3,
        "Major Third": 4,
        "Perfect Fourth": 5,
        "Perfect Fifth": 7,
        "Major Sixth": 9,
    }

    detune_variants = {
        "flat_25": -25,
        "flat_13": -13,
        "flat_5": -5,
        "in_tune": 0,
        "plus_5": 5,
        "plus_13": 13,
        "plus_25": 25
    }

    for interval_name, semitones in intervals.items():
        for root_midi in range(55, 84 - semitones):  # Keep intervals in range
            note1 = note_name(root_midi)
            note2 = note_name(root_midi + semitones)

            base_freq1 = midi_to_freq(root_midi)
            base_freq2 = midi_to_freq(root_midi + semitones)

            # Save root tone (always original)
            tone1 = generate_sine_wave(base_freq1)
            root_dir = os.path.join(base_dir, interval_name, "original")
            os.makedirs(root_dir, exist_ok=True)
            root_filename = f"{note1}__root.wav"
            save_wav(os.path.join(root_dir, root_filename), tone1)

            for variant, cents in detune_variants.items():
                freq2 = cents_to_freq(base_freq2, cents)
                tone2 = generate_sine_wave(freq2)

                interval_dir = os.path.join(base_dir, interval_name, variant)
                os.makedirs(interval_dir, exist_ok=True)

                filename = f"{note2}__interval__vs_{note1}.wav"
                save_wav(os.path.join(interval_dir, filename), tone2)
                print(f"Saved: {os.path.join(interval_dir, filename)}")

    print(f"\n✅ All individual tone files generated under: {base_dir}")

if __name__ == "__main__":
    main()