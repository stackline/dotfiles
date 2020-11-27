package main

import (
	"fmt"
	"os"
	"strings"
)

func Exists(s []string, path string) bool {
	for _, v := range s {
		if path == v {
			return true
		}
	}
	return false
}

func Check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {
	default_paths := []string{
		"/usr/local/bin",
		"/usr/local/sbin",
		"/usr/bin",
		"/bin",
		"/usr/sbin",
		"/sbin",
		"/Library/Apple/usr/bin",
	}

	current_path_str := os.Getenv("PATH")
	current_paths := strings.Split(current_path_str, ":")

	var low_priorities []string
	for _, v := range default_paths {
		if Exists(current_paths, v) {
			low_priorities = append(low_priorities, v)
		}
	}

	var high_priorities []string
	for _, v := range current_paths {
		// Avoid duplicate registration.
		if Exists(low_priorities, v) || Exists(high_priorities, v) {
			continue
		}
		high_priorities = append(high_priorities, v)
	}

	next_paths := append(high_priorities, low_priorities...)
	next_path_str := strings.Join(next_paths, ":")
	fmt.Print(next_path_str)
}
