COMPILER = gcc

CFLAGS = -g  		 \
		 -I include  \
		 -O0		 \
		 -fno-inline \

SOURCES_EXTENSION = .cpp

########################################

PROFILER 	     = valgrind
GRAPHIC_PROFILER = kcachegrind

PFLAGS = --quiet							  \
		 --tool=callgrind 					  \
		 --callgrind-out-file=$(PROFILE_DATA) \
		 --dump-instr=yes					  \
		 --collect-jumps=yes				  \

########################################

SOURCES_DIR = src
OBJECTS_DIR = obj
BUILD_DIR   = bin

EXE      = hash-table
EXE_PATH = $(BUILD_DIR)/$(EXE)

PROFILE_DATA = callgrind.out

########################################

SOURCE_FILES = $(wildcard $(SOURCES_DIR)/*.cpp)
OBJECT_FILES = $(subst $(SOURCES_DIR), $(OBJECTS_DIR), $(SOURCE_FILES:.cpp=.o))

########################################

all: $(EXE_PATH)

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(OBJECTS_DIR):
	@mkdir -p $(OBJECTS_DIR)

$(EXE_PATH): $(OBJECT_FILES) $(BUILD_DIR)
	@$(COMPILER) $(OBJECT_FILES) -o $@ $(LDFLAGS)

$(OBJECTS_DIR)/%.o: $(SOURCES_DIR)/%.cpp $(OBJECTS_DIR)
	@$(COMPILER) -c $(CFLAGS) $< -o $@

########################################

clean:
	rm -fr $(OBJECTS_DIR) $(BUILD_DIR) $(LOGS_DIR) callgrind.out

########################################

run:
	@make -s clean
	@make -s all
	@$(EXE_PATH)

########################################

profile:
	@make -s run
	@$(PROFILER) $(PFLAGS) $(EXE_PATH)
	@$(GRAPHIC_PROFILER) callgrind.out 2>/dev/null &

########################################
