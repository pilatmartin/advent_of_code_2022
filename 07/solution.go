package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

type Directory struct {
	name        string
	size        int
	parent      *Directory
	directories []*Directory
}

func (Directory *Directory) addDirectory(item *Directory) {
	directories := Directory.directories
	directories = append(directories, item)
	Directory.directories = directories
}

func main() {
	content, err := ioutil.ReadFile("data")
	lines := strings.Split(string(content), "\n")

	if err != nil {
		return
	}

	root := &Directory{
		name:        "/",
		size:        0,
		parent:      nil,
		directories: []*Directory{},
	}

	currentDirectory := root

	for _, line := range lines {
		if strings.Contains(line, "cd ..") {
			currentDirectory = currentDirectory.parent
			continue
		}

		if strings.Contains(line, "$ cd") {
			nextF := getNextDirectory(line[5:], currentDirectory)
			currentDirectory = nextF
			continue
		}

		if strings.Contains(line, "$ ls") {
			continue
		}

		if strings.Contains(line, "dir ") {
			newDirectory := &Directory{
				name:        line[4:],
				size:        0,
				parent:      currentDirectory,
				directories: []*Directory{},
			}
			currentDirectory.addDirectory(newDirectory)
			continue
		}

		fileSize, _ := strconv.Atoi(strings.Split(line, " ")[0])
		currentDirectory.size += fileSize
	}

	setSizes(root)
	sumOfSmallDirectories := root.size

	if root.size > 100000 {
		sumOfSmallDirectories = 0
	}

	getSmallDirectories(root, &sumOfSmallDirectories)
	fmt.Printf("First:  %v\n", sumOfSmallDirectories)

	smallestToDelete := 70000000
	getSmallestDirectoryToDelete(root, &smallestToDelete, (30000000 - (70000000 - root.size)))
	fmt.Printf("Second: %v\n", smallestToDelete)
}

func getNextDirectory(name string, currentDirectory *Directory) *Directory {
	for _, directory := range currentDirectory.directories {
		if directory.name == name {
			return directory
		}
	}

	return currentDirectory
}

func setSizes(root *Directory) {
	for _, directory := range root.directories {
		setSizes(directory)
		root.size += directory.size
	}
}

func getSmallDirectories(root *Directory, sum *int) {
	for _, directory := range root.directories {
		if directory.size <= 100000 {
			*sum += directory.size
		}

		getSmallDirectories(directory, sum)
	}
}

func getSmallestDirectoryToDelete(root *Directory, smallest *int, target int) {
	for _, directory := range root.directories {
		if directory.size >= target && directory.size < *smallest {
			*smallest = directory.size
		}

		getSmallestDirectoryToDelete(directory, smallest, target)
	}
}
