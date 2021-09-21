Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3059EC433FE
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 12:01:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158C461186
	for <fio@archiver.kernel.org>; Tue, 21 Sep 2021 12:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhIUMC3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 21 Sep 2021 08:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhIUMC1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 21 Sep 2021 08:02:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE69C061574
        for <fio@vger.kernel.org>; Tue, 21 Sep 2021 05:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=ja/XqzKHliuukZvETEK9ydP1HGHMuICelT2t/kaj9sc=; b=fQf0sa+2EjkykU2VZKlOwE8Jtv
        G9OgLgu9/sC3+Fl5tMg31IFqzCfDMagLaoBra3xbncqc91ep+q1fwbDJMimXT2XjVKXFNHfmitUzG
        ibGMKqRqygSQy7/2V+2nFBm29fnjq9jsD6Z7rs2oWsb3hwE/jwyEv3M1zcEIxb7AIEh3x4A+o5x0Z
        XUUall2hXER3mi2VuQZsDiUePwrH27EREMMeT/YOk5z5OSFQIy7XRhViqDiFRxmqnfvpC1o53clXl
        GNm5CfkNux+YaaIwTQP/uiSTy4b8ZCVlfSiMWOxlqb3KheXxt3Zz5mOU80ELl/F067sO1i3hmU8R0
        cihI7wBg==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSeRR-003mDU-B4
        for fio@vger.kernel.org; Tue, 21 Sep 2021 12:00:37 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 8D2481BC00EE; Tue, 21 Sep 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210921120001.8D2481BC00EE@kernel.dk>
Date:   Tue, 21 Sep 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit f3057d268d98aeb638b659a284d087fb0c2f654c:

  t/io_uring: fix bandwidth calculation (2021-09-16 11:41:06 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to d9137307bc621280dcb1738e5df5d5ee4269a665:

  Merge branch 'one-core' of https://github.com/ErwanAliasr1/fio (2021-09-20 18:29:40 -0600)

----------------------------------------------------------------
Erwan Velu (1):
      t/one-core.sh: Adding script to run the one-core io benchmark

Jens Axboe (1):
      Merge branch 'one-core' of https://github.com/ErwanAliasr1/fio

 t/one-core-peak.sh | 199 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 199 insertions(+)
 create mode 100755 t/one-core-peak.sh

---

Diff of recent changes:

diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
new file mode 100755
index 00000000..791deece
--- /dev/null
+++ b/t/one-core-peak.sh
@@ -0,0 +1,199 @@
+#!/bin/bash
+
+args=$*
+first_cores=""
+taskset_cores=""
+first_cores_count=0
+nb_threads=4 #default from the benchmark
+
+fatal() {
+  echo "$@"
+  exit 1
+}
+
+hint() {
+  echo "Warning: $*"
+}
+
+info() {
+  item=$1
+  shift
+  echo "${item}: $*"
+}
+
+check_root() {
+  [[ ${EUID} -eq 0 ]] || fatal "You should be root to run this tool"
+}
+
+check_binary() {
+  # Ensure the binaries are present and executable
+  for bin in "$@"; do
+    if [ ! -x ${bin} ]; then
+      which ${bin} >/dev/null
+      [ $? -eq 0 ] || fatal "${bin} doesn't exists or is not executable"
+    fi
+  done
+}
+
+
+detect_first_core() {
+  # Detect which logical cpus belongs to the first physical core
+  # If Hyperthreading is enabled, two cores are returned
+  cpus=$(lscpu  --all -pSOCKET,CORE,CPU |grep "0,0")
+  for cpu in ${cpus}; do
+    IFS=','
+    # shellcheck disable=SC2206
+    array=(${cpu})
+    if [ ${first_cores_count} -eq 0 ]; then
+      first_cores="${array[2]}"
+    else
+      first_cores="${first_cores} ${array[2]}"
+    fi
+
+    first_cores_count=$((first_cores_count + 1))
+    unset IFS
+  done
+  [ ${first_cores_count} -eq 0 ] && fatal "Cannot detect first core"
+  taskset_cores=$(echo "${first_cores}" | tr ' ' ',')
+}
+
+check_args() {
+  [ $1 -eq 0 ] && fatal "Missing drive(s) as argument"
+}
+
+check_drive_exists() {
+  # Ensure the block device exists
+  [ -b $1 ] || fatal "$1 is not a valid block device"
+}
+
+is_nvme() {
+  [[ ${*} == *"nvme"* ]]
+}
+
+check_poll_queue() {
+  # Print a warning if the nvme poll queues aren't enabled
+  is_nvme ${args} || return
+  poll_queue=$(cat /sys/module/nvme/parameters/poll_queues)
+  [ ${poll_queue} -eq 0 ] && hint "For better performance, you should enable nvme poll queues by setting nvme.poll_queues=32 on the kernel commande line"
+}
+
+block_dev_name() {
+  echo ${1#"/dev/"}
+}
+
+get_sys_block_dir() {
+  # Returns the /sys/block/ directory of a given block device
+  device_name=$1
+  sys_block_dir="/sys/block/${device_name}"
+  [ -d "${sys_block_dir}" ] || fatal "Cannot find ${sys_block_dir} directory"
+  echo ${sys_block_dir}
+}
+
+check_io_scheduler() {
+  # Ensure io_sched is set to none
+  device_name=$(block_dev_name $1)
+  sys_block_dir=$(get_sys_block_dir ${device_name})
+  sched_file="${sys_block_dir}/queue/scheduler"
+  [ -f "${sched_file}" ] || fatal "Cannot find IO scheduler for ${device_name}"
+  grep -q '\[none\]' ${sched_file}
+  if [ $? -ne 0 ]; then
+    info "${device_name}" "set none as io scheduler"
+    echo "none" > ${sched_file}
+  fi
+
+}
+
+check_sysblock_value() {
+  device_name=$(block_dev_name $1)
+  sys_block_dir=$(get_sys_block_dir ${device_name})
+  target_file="${sys_block_dir}/$2"
+  value=$3
+  [ -f "${target_file}" ] || fatal "Cannot find ${target_file} for ${device_name}"
+  content=$(cat ${target_file})
+  if [ "${content}" != "${value}" ]; then
+    info "${device_name}" "${target_file} set to ${value}."
+    echo ${value} > ${target_file} 2>/dev/null || hint "${device_name}: Cannot set ${value} on ${target_file}"
+  fi
+}
+
+compute_nb_threads() {
+  # Increase the number of threads if there is more devices or cores than the default value
+  [ $# -gt ${nb_threads} ] && nb_threads=$#
+  [ ${first_cores_count} -gt ${nb_threads} ] && nb_threads=${first_cores_count}
+}
+
+check_scaling_governor() {
+  driver=$(LC_ALL=C cpupower frequency-info |grep "driver:" |awk '{print $2}')
+  if [ -z "${driver}" ]; then
+    hint "Cannot detect processor scaling driver"
+    return
+  fi
+  cpupower frequency-set -g performance >/dev/null 2>&1 || fatal "Cannot set scaling processor governor"
+}
+
+check_idle_governor() {
+  filename="/sys/devices/system/cpu/cpuidle/current_governor"
+  if [ ! -f "${filename}" ]; then
+    hint "Cannot detect cpu idle governor"
+    return
+  fi
+  echo "menu" > ${filename} 2>/dev/null || fatal "Cannot set cpu idle governor to menu"
+}
+
+show_nvme() {
+  device_name=$(block_dev_name $1)
+  device_dir="/sys/block/${device_name}/device/"
+  pci_addr=$(cat ${device_dir}/address)
+  pci_dir="/sys/bus/pci/devices/${pci_addr}/"
+  link_speed=$(cat ${pci_dir}/current_link_speed)
+  irq=$(cat ${pci_dir}/irq)
+  numa=$(cat ${pci_dir}/numa_node)
+  cpus=$(cat ${pci_dir}/local_cpulist)
+  model=$(cat ${device_dir}/model | xargs) #xargs for trimming spaces
+  fw=$(cat ${device_dir}/firmware_rev | xargs) #xargs for trimming spaces
+  serial=$(cat ${device_dir}/serial | xargs) #xargs for trimming spaces
+  info ${device_name} "MODEL=${model} FW=${fw} serial=${serial} PCI=${pci_addr}@${link_speed} IRQ=${irq} NUMA=${numa} CPUS=${cpus} "
+}
+
+show_device() {
+  device_name=$(block_dev_name $1)
+  is_nvme $1 && show_nvme $1
+}
+
+show_system() {
+CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | awk '{print substr($0, index($0,$4))}')
+MEMORY_SPEED=$(dmidecode -t 17 -q |grep -m 1 "Configured Memory Speed: " | awk '{print substr($0, index($0,$4))}')
+KERNEL=$(uname -r)
+info "system" "CPU: ${CPU_MODEL}"
+info "system" "MEMORY: ${MEMORY_SPEED}"
+info "system" "KERNEL: ${KERNEL}"
+}
+
+### MAIN
+check_args $#
+check_root
+check_binary t/io_uring lscpu grep taskset cpupower awk tr xargs dmidecode
+detect_first_core
+
+info "##################################################"
+show_system
+for drive in ${args}; do
+  check_drive_exists ${drive}
+  check_io_scheduler ${drive}
+  check_sysblock_value ${drive} "queue/iostats" 0 # Ensure iostats are disabled
+  check_sysblock_value ${drive} "queue/nomerges" 2 # Ensure merge are disabled
+  check_sysblock_value ${drive} "queue/io_poll" 1 # Ensure io_poll is enabled
+  show_device ${drive}
+done
+
+check_poll_queue
+compute_nb_threads ${args}
+check_scaling_governor
+check_idle_governor
+
+info "##################################################"
+echo
+
+cmdline="taskset -c ${taskset_cores} t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n${nb_threads} ${args}"
+info "io_uring" "Running ${cmdline}"
+${cmdline}
