import matplotlib.pyplot as plt
import sys

if len(sys.argv) != 3:
    print("Usage: python3 plot.py <input_file> <output_file>")
    sys.exit(1)

input_file  = sys.argv[1]
output_file = sys.argv[2]

buckets = []
counts = []
with open(input_file, "r") as file:
    for line in file:
        bucket, count = map(int, line.split())
        buckets.append(bucket)
        counts.append(count)

load_factor = sum(counts) / len(buckets)
mean_count = sum(counts) / len(counts)
dispercion = sum((count - mean_count) ** 2 for count in counts) / len(counts)

plt.figure(figsize=(10, 6))
plt.bar(buckets, counts, color='blue', alpha=0.7)
plt.title(f"Bucket Distribution for {output_file}")
plt.xlabel("Bucket Index")
plt.ylabel("Number of Key-Value Pairs")
plt.grid(axis='y', linestyle='--', alpha=0.7)

plt.text(
    0.95, 0.95,
    f"Dispercion = {dispercion:.2f}",
    fontsize=12, color='black', ha='right', va='top',
    transform=plt.gca().transAxes,
    bbox=dict(facecolor='white', alpha=0.5, edgecolor='gray')
)

plt.savefig(output_file, dpi=300, bbox_inches='tight')

print(f"Load factor = {load_factor:.1f}")
print(f"Dispercion = {dispercion:.2f}")

plt.show()
