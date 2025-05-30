import numpy as np
from scipy.io.wavfile import write
import os

def generate_sine_wave(freq, duration=1.5, sample_rate=44100, amplitude=0.5, fade_duration=0.01):
    """Generates a sine wave with a fade-out at the end."""
    total_samples = int(sample_rate * duration)
    t = np.linspace(0, duration, total_samples, endpoint=False)
    wave = amplitude * np.sin(2 * np.pi * freq * t)

    # Apply fade-out at the end
    fade_samples = int(fade_duration * sample_rate)
    if fade_samples > 0:
        fade = np.linspace(1, 0, fade_samples)
        wave[-fade_samples:] *= fade

    return wave

def save_wav(filename, data, sample_rate=44100):
    """Saves a numpy array as a WAV file."""
    scaled = np.int16(data / np.max(np.abs(data)) * 32767)
    write(filename, sample_rate, scaled)

def note_name(n):
    """Returns the note name for a MIDI number."""
    names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B']
    octave = (n // 12) - 1
    note = names[n % 12]
    return f"{note}{octave}"

def midi_to_freq(midi_note):
    """Converts a MIDI note number to frequency in Hz."""
    return 440.0 * (2 ** ((midi_note - 69) / 12))

def cents_to_freq(base_freq, cents):
    """Shifts a frequency by the given number of cents."""
    return base_freq * (2 ** (cents / 1200.0))

def main():
    base_dir = r"C:\Users\trist\Interval Intonation\int\assets"
    os.makedirs(base_dir, exist_ok=True)

    # Define detune variants in cents and their subdirectory names
    detune_variants = {
        "cents_-25": -25,
        "cents_-13": -13,
        "cents_-5": -5,
        "original": 0,
        "cents_+5": 5,
        "cents_+13": 13,
        "cents_+25": 25
    }

    # G3 (MIDI 55) to B5 (MIDI 83)
    for midi_note in range(55, 84):
        base_freq = midi_to_freq(midi_note)
        note = note_name(midi_note)

        for variant_name, cents in detune_variants.items():
            variant_dir = os.path.join(base_dir, variant_name)
            os.makedirs(variant_dir, exist_ok=True)

            freq = cents_to_freq(base_freq, cents)
            tone = generate_sine_wave(freq)

            filename = f"{note}_{freq:.2f}Hz.wav"
            filepath = os.path.join(variant_dir, filename)

            save_wav(filepath, tone)
            print(f"Saved: {filepath}")

    print("\n✅ All files generated in:", base_dir)

if __name__ == "__main__":
    main()