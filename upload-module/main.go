package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"log"
	"os"

	tfe "github.com/hashicorp/go-tfe"
)

func main() {
	org := flag.String("org", "", "organization name (required)")
	name := flag.String("name", "s3-bucket", "module name")
	provider := flag.String("provider", "aws", "provider name")
	version := flag.String("version", "0.1.0", "module version (semver)")
	src := flag.String("path", "./modules/s3-bucket", "path to the module directory")
	flag.Parse()

	if *org == "" {
		fmt.Fprintln(os.Stderr, "error: -org is required")
		flag.Usage()
		os.Exit(2)
	}

	client, err := tfe.NewClient(&tfe.Config{
		Address: "https://tf.pulumi.com",
		Token:   os.Getenv("PULUMI_ACCESS_TOKEN"),
	})
	if err != nil {
		log.Fatalf("new client: %v", err)
	}

	ctx := context.Background()

	id := tfe.RegistryModuleID{
		Organization: *org,
		Name:         *name,
		Provider:     *provider,
		Namespace:    *org,
		RegistryName: tfe.PrivateRegistry,
	}

	if _, err := client.RegistryModules.Read(ctx, id); err != nil {
		if !errors.Is(err, tfe.ErrResourceNotFound) {
			log.Fatalf("read module: %v", err)
		}
		log.Printf("creating module %s/%s/%s", *org, *name, *provider)
		if _, err := client.RegistryModules.Create(ctx, *org, tfe.RegistryModuleCreateOptions{
			Name:         tfe.String(*name),
			Provider:     tfe.String(*provider),
			RegistryName: tfe.PrivateRegistry,
		}); err != nil {
			log.Fatalf("create module: %v", err)
		}
	}

	rmv, err := client.RegistryModules.CreateVersion(ctx, id, tfe.RegistryModuleCreateVersionOptions{
		Version: tfe.String(*version),
	})
	if err != nil {
		log.Fatalf("create version: %v", err)
	}

	if err := client.RegistryModules.Upload(ctx, *rmv, *src); err != nil {
		log.Fatalf("upload module: %v", err)
	}

	fmt.Printf("uploaded %s/%s/%s@%s\n", *org, *name, *provider, *version)
}
