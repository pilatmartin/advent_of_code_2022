#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <stack>

std::string get_input();
std::string get_result(std::vector<std::stack<std::string>> stacks);
std::vector<std::string> split(std::string string, std::string delim);
std::vector<std::stack<std::string>> get_stacks(std::vector<std::string> lines);
void move_crate(std::string command, std::vector<std::stack<std::string>> &stacks);
void move_crates(std::string command, std::vector<std::stack<std::string>> &stacks);

int main() {
    std::string input = get_input();
    std::vector<std::string> lines = split(input, "\n");
    std::vector<std::stack<std::string>> stacks_1 = get_stacks(lines);
    std::vector<std::stack<std::string>> stacks_2 = get_stacks(lines);

    for (std::string line : lines) {
        if (line[0] != 'm') {
            continue;
        }

        move_crate(line, stacks_1);
        move_crates(line, stacks_2);
    } 

    std::cout << "First:  " << get_result(stacks_1) << std::endl;
    std::cout << "Second: " << get_result(stacks_2) << std::endl;

    return 0;
}

std::string get_input() {
    std::ifstream in_file ("data");
    std::stringstream str_stream;
    str_stream << in_file.rdbuf();

    return str_stream.str(); 
}

std::string get_result(std::vector<std::stack<std::string>> stacks) {
    std::string result = "";
    for (std::stack<std::string> stack : stacks) {
        result += stack.top();
    }

    return result;
}

std::vector<int> parse_move(std::string command) {
    std::vector<std::string> parts = split(command, " ");
    return std::vector<int> {stoi(parts[1]), stoi(parts[3]) - 1, stoi(parts[5]) - 1};
}

void move_crate(std::string command, std::vector<std::stack<std::string>> &stacks) {
    auto move = parse_move(command);
    int amount = move[0]; int from = move[1]; int to = move[2];

    for (size_t i = 0; i < amount; i++) {
        stacks[to].push(stacks[from].top());
        stacks[from].pop();
    }
}

void move_crates(std::string command, std::vector<std::stack<std::string>> &stacks) {
    std::stack<std::string> tmp_stack;
    std::vector<int> move = parse_move(command);
    int amount = move[0]; int from = move[1]; int to = move[2];

    for (size_t i = 0; i < amount; i++) {
        tmp_stack.push(stacks[from].top());
        stacks[from].pop();
    }

    while (!tmp_stack.empty()) {
        stacks[to].push(tmp_stack.top());
        tmp_stack.pop();
    }
}

std::vector<std::string> split(std::string string, std::string delim) {
    size_t start = 0;
    size_t end = string.find(delim);
    std::vector<std::string> result;

    while (end != std::string::npos) {
        result.push_back(string.substr(start, end - start));
        start = end + delim.length();
        end = string.find(delim, start);
    }

    result.push_back(string.substr(start, size(string) - start));

    return result;
}

size_t get_stacks_index(std::vector<std::string> lines) {
    int index = 0;
    for (size_t i = 0; i < size(lines); i++) {
        if (lines[i][0] == ' ' && lines[i].find("[") == std::string::npos) {
            break;
        }

        index++;
    }
    
    return --index;
}

std::vector<std::stack<std::string>> get_stacks(std::vector<std::string> lines) {
    std::vector<std::stack<std::string>> result (9);
    
    int index = get_stacks_index(lines);

    while (index >= 0) {
        size_t crate_idx = 1;
        
        while (crate_idx < size(lines[index])-1) {
            if (lines[index][crate_idx] == ' ') {
                crate_idx += 4;
                continue;
            }

            std::string crate (1, lines[index][crate_idx]);
            result[(size_t)(crate_idx/4)].push(crate);
            crate_idx += 4;
        }

        index--;
    }
    
    return result;
}
