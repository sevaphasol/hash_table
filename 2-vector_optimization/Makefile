COMPILER = g++

CFLAGS = -g          \
         -I include  \
         -O3         \
         -fno-inline \
		 -mavx2      \

################################################################################

PROFILER         = valgrind
GRAPHIC_PROFILER = kcachegrind

PFLAGS = --quiet                              \
         --tool=callgrind                     \
         --callgrind-out-file=$(PROFILE_DATA) \
         --dump-instr=yes                     \
         --collect-jumps=yes                  \

################################################################################

SOURCES_DIR = sources
OBJECTS_DIR = build
OUTPUT_DIR  = bin

OUTPUT      = hash-table
OUTPUT_PATH = $(OUTPUT_DIR)/$(OUTPUT)

PROFILE_DATA = callgrind.out

################################################################################

SOURCES = $(wildcard $(SOURCES_DIR)/*.cpp)
OBJECTS = $(subst $(SOURCES_DIR), $(OBJECTS_DIR), $(SOURCES:.cpp=.o))

################################################################################

all: $(OUTPUT_PATH)

$(OUTPUT_DIR):
	@mkdir -p $(OUTPUT_DIR)

$(OBJECTS_DIR):
	@mkdir -p $(OBJECTS_DIR)

$(OUTPUT_PATH): $(OBJECTS) $(OUTPUT_DIR)
	@$(COMPILER) $(OBJECTS) -o $@ $(LDFLAGS)

$(OBJECTS_DIR)/%.o: $(SOURCES_DIR)/%.cpp $(OBJECTS_DIR)
	@$(COMPILER) -c $(CFLAGS) $< -o $@

################################################################################

clean:
	rm -fr $(OBJECTS_DIR) $(OUTPUT_DIR) $(LOGS_DIR) $(PROFILE_DATA)

################################################################################

run:
	@make -s clean
	@make -s all
	@$(OUTPUT_PATH)

################################################################################

profile:
	@make -s run
	@$(PROFILER) $(PFLAGS) $(OUTPUT_PATH)
	@$(GRAPHIC_PROFILER) $(PROFILE_DATA) 2>/dev/null &

################################################################################
