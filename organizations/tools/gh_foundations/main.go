/*
Copyright © 2024 NAME HERE <EMAIL ADDRESS>
*/
package main

import (
	"gh_foundations/cmd"
	"log"

	ui "github.com/gizak/termui/v3"
)

func main() {
	if err := ui.Init(); err != nil {
		log.Fatalf("failed to initialize termui: %v", err)
	}
	defer ui.Close()

	cmd.Execute()
}
