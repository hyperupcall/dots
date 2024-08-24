#!/usr/bin/env bats

load './util/init.sh'

@test "core.ifs_save sets new ifs" {
	core.ifs_save 'w'

	assert [ "$IFS" = 'w' ]
}

@test "core.ifs_restore restores ifs that was saved" {
	IFS=q
	core.ifs_save 'w'
	core.ifs_restore

	assert [ "$IFS" = 'q' ]
}