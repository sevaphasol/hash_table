import re
from collections import Counter
import struct
import argparse

# Функция для обработки текста и подсчёта частоты слов
def process_text(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        text = file.read()

    # Извлекаем слова с помощью регулярного выражения
    words = re.findall(r'\b\w+\b', text.lower())

    # Подсчитываем частоту слов
    word_counts = Counter(words)

    return word_counts

# Функция для объединения нескольких счётчиков
def merge_counters(counters):
    merged = Counter()
    for counter in counters:
        merged.update(counter)
    return merged

# Функция для сохранения частот слов в текстовый файл
def save_word_counts(word_counts, output_file):
    with open(output_file, 'w', encoding='utf-8') as file:
        # Сортируем слова по убыванию частоты
        for word, count in sorted(word_counts.items(), key=lambda x: x[1], reverse=True):
            file.write(f"{word} {count}\n")

# Функция для сохранения данных в бинарном формате
def save_binary_data(word_counts, output_file):
    # Сортируем слова по убыванию частоты
    sorted_items = sorted(word_counts.items(), key=lambda x: x[1], reverse=True)

    # Раздел 1: слова
    section_1 = b''.join(word.encode('utf-8') + b'\0' for word, _ in sorted_items)
    size_section_1 = len(section_1)

    # Раздел 2: частоты слов
    section_2 = b''.join(struct.pack('<Q', count) for _, count in sorted_items)
    size_section_2 = len(section_2)

    # Общий размер файла
    total_size = 8 + 16 + size_section_1 + size_section_2

    # Запись данных в бинарный файл
    with open(output_file, 'wb') as file:
        # Первые 8 байт: общий размер файла
        file.write(struct.pack('<Q', total_size))

        # Следующие 16 байт: размеры разделов 1 и 2
        file.write(struct.pack('<QQ', size_section_1, size_section_2))

        # Раздел 1: слова
        file.write(section_1)

        # Раздел 2: частоты слов
        file.write(section_2)

# Главная функция
def main():
    # Парсим аргументы командной строки
    parser = argparse.ArgumentParser(description="Process text files and save word counts.")
    parser.add_argument("output_file", help="Name of the output file (without extension)")
    parser.add_argument("input_files", nargs='+', help="List of input text files")
    args = parser.parse_args()

    # Обрабатываем каждый файл и получаем частоты слов
    counts = [process_text(path) for path in args.input_files]

    # Объединяем все частоты в один счётчик
    total_counts = merge_counters(counts)

    # Создаём текстовый файл
    text_output_file = f"{args.output_file}.txt"
    save_word_counts(total_counts, text_output_file)

    # Создаём бинарный файл
    binary_output_file = f"{args.output_file}.bin"
    save_binary_data(total_counts, binary_output_file)

# Запуск программы
if __name__ == "__main__":
    main()
