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
    keys      = b''.join(word.encode('utf-8') + b'\0' for word, _ in word_counts)
    keys_size = len(keys)

    data      = b''.join(struct.pack('<Q', count) for _, count in word_counts)
    data_size = len(data)

    relative_pointers = []
    total_length = 0
    for word, _ in word_counts:
        relative_pointers.append(total_length)
        total_length += len(word) + 1

    relative_pointers      = b''.join(struct.pack('<Q', pointer) for pointer in relative_pointers)
    relative_pointers_size = len(relative_pointers) // 8

    with open(output_file, 'wb') as file:
        file.write(struct.pack('<QQQ', keys_size + data_size + relative_pointers_size * 8 + 24,
                                       keys_size,
                                       relative_pointers_size))
        file.write(keys)
        file.write(data)
        file.write(relative_pointers)

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
