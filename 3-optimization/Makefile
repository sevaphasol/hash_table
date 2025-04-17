# ---------------------------------------------------------------------------------------- #

COMPILER  = g++

CFLAGS    = -g          \
            -I include  \
            -O2         \
		    -mavx2      \

# ---------------------------------------------------------------------------------------- #

ASSEMBLER = nasm

ASMFLAGS  = -f elf64

# ---------------------------------------------------------------------------------------- #

LINKER    = g++

LDFLAGS   = -Wl,-z,noexecstack

# ---------------------------------------------------------------------------------------- #

PROFILER  = valgrind

PFLAGS    = --quiet                              \
            --tool=callgrind                     \
            --callgrind-out-file=$(PROFILE_DATA) \
            --dump-instr=yes                     \
            --collect-jumps=yes                  \

# ---------------------------------------------------------------------------------------- #

GRAPHIC_PROFILER = kcachegrind

# ---------------------------------------------------------------------------------------- #

SOURCES_DIR = sources
OBJECTS_DIR = build
OUTPUT_DIR  = bin

OUTPUT      = hash-table
OUTPUT_PATH = $(OUTPUT_DIR)/$(OUTPUT)

PROFILE_DATA = callgrind.out

# ---------------------------------------------------------------------------------------- #

CPP_SOURCE_FILES  = $(wildcard $(SOURCES_DIR)/*.cpp)
ASM_SOURCE_FILES  = $(wildcard $(SOURCES_DIR)/*.asm)

CPP_OBJECT_FILES  = $(patsubst $(SOURCES_DIR)/%.cpp, $(OBJECTS_DIR)/%.o, $(CPP_SOURCE_FILES))
ASM_OBJECT_FILES  = $(patsubst $(SOURCES_DIR)/%.asm, $(OBJECTS_DIR)/%.o, $(ASM_SOURCE_FILES))

OBJECT_FILES      = $(CPP_OBJECT_FILES) $(ASM_OBJECT_FILES)

# ---------------------------------------------------------------------------------------- #

all: $(OUTPUT_PATH)

$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

$(OBJECTS_DIR):
	@mkdir -p $(OBJECTS_DIR)

$(OUTPUT_PATH): $(OBJECT_FILES) | $(OUTPUT_DIR)
	@$(LINKER) $(OBJECT_FILES) $(LDFLAGS) -o $@

$(OBJECTS_DIR)/%.o: $(SOURCES_DIR)/%.cpp | $(OBJECTS_DIR)
	@$(COMPILER) -c $(CFLAGS) $< -o $@

$(OBJECTS_DIR)/%.o: $(SOURCES_DIR)/%.asm | $(OBJECTS_DIR)
	@$(ASSEMBLER) $(ASMFLAGS) $< -o $@

# ---------------------------------------------------------------------------------------- #

clean:
	rm -fr $(OBJECTS_DIR) $(OUTPUT_DIR) $(LOGS_DIR) $(PROFILE_DATA)

# ---------------------------------------------------------------------------------------- #

run:
	@make -s clean
	@make -s all
	@$(OUTPUT_PATH)

# ---------------------------------------------------------------------------------------- #

profile:
	@make -s run
	@$(PROFILER) $(PFLAGS) $(OUTPUT_PATH)
	@$(GRAPHIC_PROFILER) $(PROFILE_DATA) 2>/dev/null &

# ---------------------------------------------------------------------------------------- #
