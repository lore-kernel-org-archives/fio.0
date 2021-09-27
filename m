Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6AFC433F5
	for <fio@archiver.kernel.org>; Mon, 27 Sep 2021 12:01:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 489FF60F6C
	for <fio@archiver.kernel.org>; Mon, 27 Sep 2021 12:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhI0MCz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 27 Sep 2021 08:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbhI0MCs (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Sep 2021 08:02:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D478CC061604
        for <fio@vger.kernel.org>; Mon, 27 Sep 2021 05:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KTbTZJ4JhA5ATgZ7QYVlxwDjJpVP6l19KkWoJcsX1s0=; b=C+UN0lXiZcrzXpKvr2mcyMUkXS
        QQf0/AJxDgsFs2hcZc+K4e9JMUIWmjDkAuJio1u59fexTyGSkCudw1Ygaokhp9V0ubjIh9X2GzFxP
        adain7TFPHLsj9zgdt3kM2WxbeucB9NTYuJfU7Dxy4EZqH7jFAjndzmTzuEaExIQ8gNzeT3insbKN
        nE9sykK9wJbKnUOhJx/mrlyGMWk17x6L94J5t5KWgXzi8ukSzUgDjI47rsdwynY9TyXQKvtljdG25
        CUzl2hmk7rZELAR4Uvkcn0cqTSTMGBaHf5nFWr/vCJtVPDJN5VAhcwRyt7on5PoY1FNsoabQusrZB
        +W2D6JfA==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mUpIj-009igN-9V
        for fio@vger.kernel.org; Mon, 27 Sep 2021 12:00:20 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id B9A951BC013D; Mon, 27 Sep 2021 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210927120001.B9A951BC013D@kernel.dk>
Date:   Mon, 27 Sep 2021 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 0b2114e7b46d047271d8d404beaae7006e89f8ef:

  Merge branch 'evelu-uring' of https://github.com/ErwanAliasr1/fio (2021-09-25 14:56:14 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 6e0ef20ffd975fc217aba4e7c125b420cd2fbd91:

  Merge branch 'onecore' of https://github.com/ByteHamster/fio (2021-09-26 16:32:32 -0600)

----------------------------------------------------------------
ByteHamster (1):
      Pick core for running t/one-core-peak.sh

Erwan Velu (5):
      one-core-peak: Avoid reporting Unknown memory speed
      one-core-peak: Adding option to reporting latencies
      one-core-peak.sh: Fixing bash
      t/one-core-peak: Reporting kernel config
      one-core-peak: Reporting NVME features

Jens Axboe (3):
      Merge branch 'tsc' of https://github.com/ErwanAliasr1/fio
      Merge branch 'evelu-fio' of https://github.com/ErwanAliasr1/fio
      Merge branch 'onecore' of https://github.com/ByteHamster/fio

 t/one-core-peak.sh | 109 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 93 insertions(+), 16 deletions(-)

---

Diff of recent changes:

diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
index 791deece..57c45451 100755
--- a/t/one-core-peak.sh
+++ b/t/one-core-peak.sh
@@ -4,7 +4,11 @@ args=$*
 first_cores=""
 taskset_cores=""
 first_cores_count=0
-nb_threads=4 #default from the benchmark
+nb_threads=1
+drives=""
+
+# Default options
+latency_cmdline=""
 
 fatal() {
   echo "$@"
@@ -35,11 +39,22 @@ check_binary() {
   done
 }
 
-
 detect_first_core() {
+  cpu_to_search="0"
+  if [ "${#drives[@]}" -eq 1 ]; then
+    device_name=$(block_dev_name ${drives[0]})
+    device_dir="/sys/block/${device_name}/device/"
+    pci_addr=$(cat ${device_dir}/address)
+    pci_dir="/sys/bus/pci/devices/${pci_addr}/"
+    cpu_to_search=$(cat ${pci_dir}/local_cpulist | cut -d"," -f 1 | cut -d"-" -f 1)
+  else
+    hint 'Passed multiple devices. Running on the first core.'
+  fi
+  core_to_run=$(lscpu  --all -pSOCKET,CORE,CPU | grep ",$cpu_to_search\$" | cut -d"," -f1-2)
+
   # Detect which logical cpus belongs to the first physical core
   # If Hyperthreading is enabled, two cores are returned
-  cpus=$(lscpu  --all -pSOCKET,CORE,CPU |grep "0,0")
+  cpus=$(lscpu  --all -pSOCKET,CORE,CPU | grep "$core_to_run")
   for cpu in ${cpus}; do
     IFS=','
     # shellcheck disable=SC2206
@@ -57,8 +72,37 @@ detect_first_core() {
   taskset_cores=$(echo "${first_cores}" | tr ' ' ',')
 }
 
+usage() {
+  echo "usage: [options] block_device [other_block_devices]
+
+   -h         : print help
+   -l         : enable latency reporting
+
+   example:
+      t/one-core-peak.sh /dev/nvme0n1
+      t/one-core-peak.sh -l /dev/nvme0n1 /dev/nvme1n1
+  "
+  exit 0
+}
+
 check_args() {
-  [ $1 -eq 0 ] && fatal "Missing drive(s) as argument"
+  local OPTIND option
+  while getopts "hl" option; do
+    case "${option}" in
+        h) # Show help
+            usage
+            ;;
+        l) # Report latency
+            latency_cmdline="1"
+            ;;
+        *)
+            fatal "Unsupported ${option} option"
+            ;;
+    esac
+  done
+  shift $((OPTIND-1))
+  [ $# -eq 0 ] && fatal "Missing drive(s) as argument"
+  drives="$*"
 }
 
 check_drive_exists() {
@@ -72,7 +116,7 @@ is_nvme() {
 
 check_poll_queue() {
   # Print a warning if the nvme poll queues aren't enabled
-  is_nvme ${args} || return
+  is_nvme ${drives} || return
   poll_queue=$(cat /sys/module/nvme/parameters/poll_queues)
   [ ${poll_queue} -eq 0 ] && hint "For better performance, you should enable nvme poll queues by setting nvme.poll_queues=32 on the kernel commande line"
 }
@@ -141,6 +185,7 @@ check_idle_governor() {
 }
 
 show_nvme() {
+  device="$1"
   device_name=$(block_dev_name $1)
   device_dir="/sys/block/${device_name}/device/"
   pci_addr=$(cat ${device_dir}/address)
@@ -153,6 +198,12 @@ show_nvme() {
   fw=$(cat ${device_dir}/firmware_rev | xargs) #xargs for trimming spaces
   serial=$(cat ${device_dir}/serial | xargs) #xargs for trimming spaces
   info ${device_name} "MODEL=${model} FW=${fw} serial=${serial} PCI=${pci_addr}@${link_speed} IRQ=${irq} NUMA=${numa} CPUS=${cpus} "
+  NCQA=$(nvme get-feature -H -f 0x7 ${device} |grep NCQA |cut -d ':' -f 2 | xargs)
+  NSQA=$(nvme get-feature -H -f 0x7 ${device} |grep NSQA |cut -d ':' -f 2 | xargs)
+  power_state=$(nvme get-feature -H -f 0x2 ${device} | grep PS |cut -d ":" -f 2 | xargs)
+  apste=$(nvme get-feature -H -f 0xc ${device} | grep APSTE |cut -d ":" -f 2 | xargs)
+  temp=$(nvme smart-log ${device} |grep 'temperature' |cut -d ':' -f 2 |xargs)
+  info ${device_name} "Temp:${temp}, Autonomous Power State Transition:${apste}, PowerState:${power_state}, Completion Queues:${NCQA}, Submission Queues:${NSQA}"
 }
 
 show_device() {
@@ -160,24 +211,50 @@ show_device() {
   is_nvme $1 && show_nvme $1
 }
 
+show_kernel_config_item() {
+  config_item="CONFIG_$1"
+  config_file="/boot/config-$(uname -r)"
+  if [ ! -f "${config_file}" ]; then
+    config_file='/proc/config.gz'
+    if [ ! -f "${config_file}" ]; then
+      return
+    fi
+  fi
+  status=$(zgrep ${config_item}= ${config_file})
+  if [ -z "${status}" ]; then
+    echo "${config_item}=N"
+  else
+    echo "${config_item}=$(echo ${status} | cut -d '=' -f 2)"
+  fi
+}
+
 show_system() {
-CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | awk '{print substr($0, index($0,$4))}')
-MEMORY_SPEED=$(dmidecode -t 17 -q |grep -m 1 "Configured Memory Speed: " | awk '{print substr($0, index($0,$4))}')
-KERNEL=$(uname -r)
-info "system" "CPU: ${CPU_MODEL}"
-info "system" "MEMORY: ${MEMORY_SPEED}"
-info "system" "KERNEL: ${KERNEL}"
+  CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | awk '{print substr($0, index($0,$4))}')
+  MEMORY_SPEED=$(dmidecode -t 17 -q | grep -m 1 "Configured Memory Speed: [0-9]" | awk '{print substr($0, index($0,$4))}')
+  KERNEL=$(uname -r)
+  info "system" "CPU: ${CPU_MODEL}"
+  info "system" "MEMORY: ${MEMORY_SPEED}"
+  info "system" "KERNEL: ${KERNEL}"
+  for config_item in BLK_CGROUP_IOCOST HZ; do
+    info "system" "KERNEL: $(show_kernel_config_item ${config_item})"
+  done
+  tsc=$(journalctl -k | grep 'tsc: Refined TSC clocksource calibration:' | awk '{print $11}')
+  if [ -n "${tsc}" ]; then
+    info "system" "TSC: ${tsc} Mhz"
+    tsc=$(echo ${tsc} | tr -d '.')
+    [ -n "${latency_cmdline}" ] && latency_cmdline="-t1 -T${tsc}000"
+  fi
 }
 
 ### MAIN
-check_args $#
+check_args ${args}
 check_root
-check_binary t/io_uring lscpu grep taskset cpupower awk tr xargs dmidecode
+check_binary t/io_uring lscpu grep taskset cpupower awk tr xargs dmidecode nvme
 detect_first_core
 
 info "##################################################"
 show_system
-for drive in ${args}; do
+for drive in ${drives}; do
   check_drive_exists ${drive}
   check_io_scheduler ${drive}
   check_sysblock_value ${drive} "queue/iostats" 0 # Ensure iostats are disabled
@@ -187,13 +264,13 @@ for drive in ${args}; do
 done
 
 check_poll_queue
-compute_nb_threads ${args}
+compute_nb_threads ${drives}
 check_scaling_governor
 check_idle_governor
 
 info "##################################################"
 echo
 
-cmdline="taskset -c ${taskset_cores} t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n${nb_threads} ${args}"
+cmdline="taskset -c ${taskset_cores} t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n${nb_threads} ${latency_cmdline} ${drives}"
 info "io_uring" "Running ${cmdline}"
 ${cmdline}
