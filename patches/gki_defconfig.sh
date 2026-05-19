#!/usr/bin/env bash

# Define target defconfig location
DEFCONFIG="arch/arm64/configs/gki_defconfig"

if [ "$KSU" != "no" ]; then
  # Base KSU Config & Dependencies
  echo "⚙️ Added KSU configuration"
  cat >> $DEFCONFIG <<EOF
CONFIG_KSU=y
CONFIG_KPM=y
EOF
fi

if [ "$KSU_SUSFS" = "true" ]; then
  echo "🔧 Mode: SuSFS Hook Enabled"
  cat >> $DEFCONFIG <<EOF
# SuSFS Configuration
CONFIG_KSU_SUSFS=y
CONFIG_KSU_SUSFS_SUS_OVERLAYFS=n
CONFIG_KSU_SUSFS_SUS_MAP=y
CONFIG_KSU_SUSFS_SUS_PATH=y
CONFIG_KSU_SUSFS_SUS_MOUNT=y
CONFIG_KSU_SUSFS_SUS_KSTAT=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_KSU_DEFAULT_MOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_SUS_BIND_MOUNT=y
CONFIG_KSU_SUSFS_TRY_UMOUNT=y
CONFIG_KSU_SUSFS_AUTO_ADD_TRY_UMOUNT_FOR_BIND_MOUNT=y
CONFIG_KSU_SUSFS_SPOOF_UNAME=y
CONFIG_KSU_SUSFS_ENABLE_LOG=n
CONFIG_KSU_SUSFS_HIDE_KSU_SUSFS_SYMBOLS=y
CONFIG_KSU_SUSFS_SPOOF_CMDLINE_OR_BOOTCONFIG=y
CONFIG_KSU_SUSFS_OPEN_REDIRECT=y
EOF

fi

echo "⚙️ Skipping ahmed's perf tuning block."

# Docker block bisect — temporarily disabled for boot-test isolation.
# If base SKSU+6.1.57 boots, the docker block is the KMI-breaking change.
# If base also panics, the issue is SukiSU integration or our toolchain.
if [ "${ENABLE_DOCKER_CONFIG:-false}" = "true" ]; then
  echo "🐳 Adding Docker required configs"
  cat >> $DEFCONFIG <<EOF
CONFIG_NAMESPACES=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_OVERLAY_FS=y
CONFIG_BRIDGE_NETFILTER=y
CONFIG_VETH=y
CONFIG_VXLAN=y
CONFIG_MACVLAN=y
CONFIG_IPVLAN=y
CONFIG_NF_TABLES=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_PIDS=y
CONFIG_POSIX_MQUEUE=y
CONFIG_CHECKPOINT_RESTORE=y
EOF
fi