package main

import (
	"log"
	"time"

	"github.com/bluecmd/iucv-go/vmtcpip"
)

func main() {
	log.Printf("System booted")

	t, err := vmtcpip.NewTCPIP("TCPIP", "ACMESERV")
	if err != nil {
		log.Fatalf("Failed to initialize VM TCPIP: %v", err)
	}
	log.Printf("VM TCPIP Hostname: %q", t.Hostname())

	for {
		time.Sleep(1)
	}
}
