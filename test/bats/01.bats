load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "docker ps works" {
  run /bin/bash -c "docker ps -a"
  assert_output --partial "CONTAINER ID"
  assert_equal "$status" 0
}
@test "docker-compose is installed" {
  run /bin/bash -c "docker-compose --version"
  assert_output --partial "docker-compose version 1.23.2"
  assert_equal "$status" 0
}
@test "docker pull from public docker registry" {
  run /bin/bash -c "docker pull alpine:3.5"
  assert_output --partial "Pulling"
  assert_equal "$status" 0
}
@test "dojo is installed" {
  run /bin/bash -c "dojo --version"
  echo "output: ${output}"
  assert_output --partial "Dojo version"
  assert_equal "$status" 0
}
@test "vault is installed" {
  run /bin/bash -c "vault --version"
  echo "output: ${output}"
  assert_output --partial "Vault v"
  assert_equal "$status" 0
}
@test "bats is installed" {
  run /bin/bash -c "bats --version"
  echo "output: ${output}"
  assert_output --partial "Bats 0.4.0"
  assert_equal "$status" 0
}
@test "rsync is installed" {
  run /bin/bash -c "rsync --version"
  echo "output: ${output}"
  assert_output --partial "rsync  version"
  assert_equal "$status" 0
}
@test "bash-completion is installed" {
  run /bin/bash -c "dpkg -s bash-completion"
  echo "output: ${output}"
  assert_equal "$status" 0
}
@test "ssh-client is installed" {
  run /bin/bash -c "ssh --version"
  echo "output: ${output}"
  assert_output --partial "usage: ssh"
  assert_equal "$status" 255
}
@test "python 3.5 is installed" {
  run /bin/bash -c "python3 --version"
  echo "output: ${output}"
  assert_output --partial "3.5"
  assert_equal "$status" 0
}
@test "python pytest CLI is installed" {
  run /bin/bash -c "pytest --version"
  echo "output: ${output}"
  assert_output --partial "6.2.2"
  assert_equal "$status" 0
}
