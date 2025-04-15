import re
from collections import Counter
import struct
import sys

def process_text(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        text = file.read()

    return Counter(re.findall(r'\b\w+\b', text.lower()))

def save_txt(word_counts, output_file):
    with open(output_file, 'w', encoding='utf-8') as file:
        for word, count in word_counts:
            file.write(f"{word} {count}\n")

def save_bin(word_counts, output_file):
    keys      = b''.join(word.encode('utf-8').ljust(32, b'\0') for word, _ in word_counts)
    n_words   = len(keys) // 32

    data      = b''.join(struct.pack('<Q', count) for _, count in word_counts)

    with open(output_file, 'wb') as file:
        file.write(struct.pack('<Q', n_words))
        file.write(keys)
        file.write(data)

def main():
    if len(sys.argv) != 3:
        print("Usage: python3 script.py <input_file> <output_file>")
        sys.exit(1)

    input_file  = sys.argv[1]
    output_file = sys.argv[2]

    word_counts = sorted(process_text(input_file).items(), key=lambda x: x[1], reverse=True)

    save_txt(word_counts, f"{output_file}.txt")
    save_bin(word_counts, f"{output_file}.bin")

if __name__ == "__main__":
    main()
