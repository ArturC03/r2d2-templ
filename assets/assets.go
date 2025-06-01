package assets

import "embed"

//go:embed css/** js/** images/*
var Assets embed.FS
