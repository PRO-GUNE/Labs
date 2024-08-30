# Makefile

# Compiler
CXX = g++

# Compiler flags
CXXFLAGS = -std=c++11 -Wall -Wextra -O2

# Source and object files
TOP_DIR = ./..
SRC_DIR = $(TOP_DIR)/src
TEST_DIR = $(TOP_DIR)/test
EXE_DIR = $(TOP_DIR)/bin
SRCS = $(TEST_DIR)/test_BigNum.cpp $(SRC_DIR)/BigNum.cpp
OBJS = $(SRCS:.cpp=.o)

# Target executable
TARGET = $(EXE_DIR)/BigNumTest

# Include directories
INCLUDES = -I$(SRC_DIR)

# Default target
all: $(TARGET)

# Rule to create the target executable
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $(TARGET) $(OBJS)

# Rule to create object files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Clean up build artifacts
clean:
	rm -f $(OBJS) $(TARGET)

# Phony targets
.PHONY: all clean
