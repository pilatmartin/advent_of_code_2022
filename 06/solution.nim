import std/re
import std/strutils

proc buildPattern(length: int): string =
    var parts = @["(?!\\2)"]
    for i in 2..length-1:
        parts.add(parts[i-2] & "(?!\\" & $(i+1) & ")")

    "((\\w)(" & parts.join("\\w)(") & "\\w))"

proc main() = 
    let input = readFile("data")
    let pattern1 = buildPattern(4)
    let pattern2 = buildPattern(14)

    echo "First: ", re.find(input, re(pattern1)) + 4
    echo "First: ", re.find(input, re(pattern2)) + 14

main()
