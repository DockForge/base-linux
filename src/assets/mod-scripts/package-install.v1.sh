#!/usr/bin/with-contenv bash
# shellcheck shell=bash

# Version 1
# 2024-03-26 - Initial Version
PKG_SCRIPT_VER="3.20240326"

write_mod_info() {
    local MSG=$*
    echo "[pkg-install-init] **** $MSG ****"
}

write_mod_debug() {
    local MSG=$*
    if [[ ${DOCKER_MODS_DEBUG,,} = "true" ]]; then echo "[pkg-install-init] (DEBUG) $MSG"; fi
}

write_mod_debug "Package install script version ${PKG_SCRIPT_VER}"

if [[ -f "/mod-pip-packages-to-install.list" ]]; then
    IFS=' ' read -ra PIP_PACKAGES <<< "$(tr '\n' ' ' < /mod-pip-packages-to-install.list)"
    if [[ ${#PIP_PACKAGES[@]} -ne 0 ]] && [[ ${PIP_PACKAGES[*]} != "" ]]; then
        if [[ "$(command -v python3)" != "/dockforgeopy/bin/python3" ]]; then
            CREATE_VENV="true"
            write_mod_debug "Marking venv for creation and adding python os dependencies to install list."
            if [[ -f /usr/bin/apt ]]; then
                echo "python3-venv" >> /mod-repo-packages-to-install.list
            elif [[ -f /sbin/apk ]]; then
                echo "python3" >> /mod-repo-packages-to-install.list
            elif [[ -f /usr/sbin/pacman ]]; then
                echo "python" >> /mod-repo-packages-to-install.list
            elif [[ -f /usr/bin/dnf ]]; then
                echo "python3" >> /mod-repo-packages-to-install.list
            fi
        else
            write_mod_debug "Venv at /dockforgeopy is already active"
        fi
    else
        write_mod_debug "No pip packages identified in install list, skipping."
    fi
else
    write_mod_debug "No pip packages defined for install, skipping."
fi

if [[ -f "/mod-repo-packages-to-install.list" ]]; then
    IFS=' ' read -ra REPO_PACKAGES <<< "$(tr '\n' ' ' < /mod-repo-packages-to-install.list)"
    if [[ ${#REPO_PACKAGES[@]} -ne 0 ]] && [[ ${REPO_PACKAGES[*]} != "" ]]; then
        write_mod_info "Installing all mod packages"
        write_mod_debug "Defined packages: ${REPO_PACKAGES[@]}"
        if [[ -f /usr/bin/apt ]]; then
            export DEBIAN_FRONTEND="noninteractive"
            apt-get update
            apt-get install -y --no-install-recommends \
                "${REPO_PACKAGES[@]}"
        elif [[ -f /sbin/apk ]]; then
            apk add --no-cache \
                "${REPO_PACKAGES[@]}"
        elif [[ -f /usr/sbin/pacman ]]; then
            pacman -Sy --noconfirm \
                "${REPO_PACKAGES[@]}"
        elif [[ -f /usr/bin/dnf ]]; then
            dnf install -y --setopt=install_weak_deps=False --best \
                "${REPO_PACKAGES[@]}"
        fi
    else
        write_mod_debug "No os packages identified in install list, skipping."
    fi
else
    write_mod_debug "No os packages defined for install, skipping."
fi

if [[ -f "/mod-pip-packages-to-install.list" ]]; then
    IFS=' ' read -ra PIP_PACKAGES <<< "$(tr '\n' ' ' < /mod-pip-packages-to-install.list)"
    if [[ ${#PIP_PACKAGES[@]} -ne 0 ]] && [[ ${PIP_PACKAGES[*]} != "" ]]; then
        write_mod_info "Installing all pip packages"
        if [[ ${CREATE_VENV} == "true" ]]; then
            write_mod_info "Creating venv"
            python3 -m venv /dockforgeopy
        fi
        write_mod_debug "Updating/installing pip, wheel and setuptools."
        python3 -m pip install -U pip wheel setuptools
        PIP_ARGS=()
        if [[ -f /usr/bin/apt ]] && grep -q 'ID=ubuntu' /etc/os-release; then
            PIP_ARGS+=("-f" "https://wheel-index.linuxserver.io/ubuntu/")
        elif [[ -f /sbin/apk ]]; then
            ALPINE_VER=$(grep main /etc/apk/repositories | sed 's|.*alpine/v||' | sed 's|/main.*||')
            PIP_ARGS+=("-f" "https://wheel-index.linuxserver.io/alpine-${ALPINE_VER}/")
        fi
        write_mod_debug "Installing defined pip packages: ${PIP_PACKAGES[@]}"
        write_mod_debug "Using pip args ${PIP_ARGS[@]}"
        python3 -m pip install \
            "${PIP_ARGS[@]}" \
            "${PIP_PACKAGES[@]}"
    fi
fi

write_mod_debug "Deleting temporary install lists for os and pip packages."
rm -rf \
    /mod-repo-packages-to-install.list \
    /mod-pip-packages-to-install.list