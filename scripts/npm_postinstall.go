package main

import (
	"errors"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func Check(e error) {
	if e != nil {
		panic(e)
	}
}

// Filter empty string from slice.
func Filter(from []string) []string {
	to := make([]string, 0)
	for _, v := range from {
		if v != "" {
			to = append(to, v)
		}
	}
	return to
}

// Remove specified value from slice.
func Remove(from []string, target int) ([]string, error) {
	if target > (len(from) - 1) {
		return nil, errors.New(fmt.Sprintf("Index %d does not exist.", target))
	}

	to := make([]string, 0)
	for i, v := range from {
		if target != i {
			to = append(to, v)
		}
	}
	return to, nil
}

func Exist(name string) bool {
	_, err := os.Stat(name)
	return err == nil
}

// After installing npm packages, create symbolic links under dotfiles/bin directory.
func main() {
	out, err := exec.Command("npm", "ls", "--depth=0", "--parseable").Output()
	Check(err)

	dirnames := strings.Split(string(out), "\n")
	dirnames = Filter(dirnames)
	// The first line of "npm list --parseable"
	// is the parent directory of node_modules directory.
	dirnames, err = Remove(dirnames, 0)
	Check(err)

	for _, dirname := range dirnames {
		files, err := ioutil.ReadDir(dirname + "/bin")
		Check(err)

		for _, file := range files {
			filename := file.Name()
			filename_without_ext := filename[0 : len(filename)-len(filepath.Ext(filename))]
			oldname := dirname + "/bin/" + filename
			newname := "/usr/local/bin/" + filename_without_ext

			if !Exist(newname) {
				err = os.Symlink(oldname, newname)
				Check(err)
				fmt.Println("Create a symbolic link.")
				fmt.Println("  from: " + oldname)
				fmt.Println("  to:   " + newname)
			}
		}
	}
}
