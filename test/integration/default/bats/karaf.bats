#!/usr/bin/env bats

@test "karaf-service is installed" {
	[ -e /etc/init.d/karaf-service ] && result=1 || result=0
	[ "$result" -eq 1 ]
}