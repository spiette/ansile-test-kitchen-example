#!/usr/bin/env bats

distro=$(python -c 'import platform; print(platform.linux_distribution(full_distribution_name=0)[0])')

@test "check for ntp package" {
    case "$distro" in
        centos|redhat)
            run rpm -q ntp
            [[ $state -eq 0 ]]
            ;;
        Debian|debian|Ubuntu|ubuntu)
            run dpkg -l ntp
            [[ $state -eq 0 ]]
            ;;
        *) return 1 ;;
    esac

}
@test "check for ntp service enabled and running" {
    case "$distro" in
        centos|redhat)
            run systemctl status ntpd.service
            [[ $state -eq 0 ]]
            [[ $output =~ active.*running ]]
            [[ $output =~ enabled ]]
            ;;
        Debian|debian|Ubuntu|ubuntu)
            run service ntp status
            [[ $state -eq 0 ]]
            # debian : (
            run ls /etc/rc2.d/S??ntp
            [[ $state -eq 0 ]]
            ;;
        *) return 1 ;;
    esac

}
