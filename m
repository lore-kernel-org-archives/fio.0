Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B54C433F5
	for <fio@archiver.kernel.org>; Tue, 26 Oct 2021 12:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FE6860F22
	for <fio@archiver.kernel.org>; Tue, 26 Oct 2021 12:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhJZMDX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 26 Oct 2021 08:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbhJZMDQ (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 26 Oct 2021 08:03:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504C2C061745
        for <fio@vger.kernel.org>; Tue, 26 Oct 2021 05:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=tR/0Ico/pwfhhr4YFEo3CrhH+5CLq3qSpiihW17f8Rg=; b=BrMVEKvI6TbrUsC9nFGQS0KNII
        VZ0OKNpVwjB9war0eh4VGaSOs6W8WAlMC33aF4WqnE+zs4RqijFPIUPcgOqL1QEVWn9DMJOH5cZ8B
        PUjbbxg4P1M8a5UCM5J+4SLDg7yVrQxIAgqCE9QNPeJrvOUaMefQoFzuBxLVtlgKVZA6INT1BsH/i
        l2/QjrYH/qIIh2yrl7MNQI0ikTfnuwSS2R9BQNKg2hpTYmyf9FsXSwBv7aZGyk0AnTykHspaHrk7r
        8S61nmyboKM76WINeC+W3YTkFur2PD8k4W+77CndWFLvnef/0gkG9P2msxenHOKjocA+OVWM+ewHx
        yE2z858g==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mfL7c-00Gpg8-5v
        for fio@vger.kernel.org; Tue, 26 Oct 2021 12:00:16 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 4EEFA1BC1DC1; Tue, 26 Oct 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211026120002.4EEFA1BC1DC1@kernel.dk>
Date:   Tue, 26 Oct 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 515418094c61cf135513a34651af6134a8794b5d:

  Merge branch 'master' of https://github.com/bvanassche/fio (2021-10-22 10:19:04 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a87ea1a869595ca57052e7645431a397d3c7d5ac:

  Merge branch 'evelu-peak' of https://github.com/ErwanAliasr1/fio (2021-10-25 12:38:35 -0600)

----------------------------------------------------------------
Erwan Velu (3):
      t/one-core-peak: Reporting SElinux status
      t/io_uring: Fixing typo in help message
      t/one-core-peak: Don't report errors if missing NVME features

Jens Axboe (1):
      Merge branch 'evelu-peak' of https://github.com/ErwanAliasr1/fio

 t/io_uring.c       |  2 +-
 t/one-core-peak.sh | 19 +++++++++++++------
 2 files changed, 14 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index a87042f8..f758a6d9 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -1059,7 +1059,7 @@ static void usage(char *argv, int status)
 		" -b <int>  : Block size, default %d\n"
 		" -p <bool> : Polled IO, default %d\n"
 		" -B <bool> : Fixed buffers, default %d\n"
-		" -R <bool> : DMA map fixed buffers, default %d\n"
+		" -D <bool> : DMA map fixed buffers, default %d\n"
 		" -F <bool> : Register files, default %d\n"
 		" -n <int>  : Number of threads, default %d\n"
 		" -O <bool> : Use O_DIRECT, default %d\n"
diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
index fba4ec95..9da8304e 100755
--- a/t/one-core-peak.sh
+++ b/t/one-core-peak.sh
@@ -199,12 +199,18 @@ show_nvme() {
   info ${device_name} "MODEL=${model} FW=${fw} serial=${serial} PCI=${pci_addr}@${link_speed} IRQ=${irq} NUMA=${numa} CPUS=${cpus} "
   which nvme &> /dev/null
   if [ $? -eq 0 ]; then
-    NCQA=$(nvme get-feature -H -f 0x7 ${device} |grep NCQA |cut -d ':' -f 2 | xargs)
-    NSQA=$(nvme get-feature -H -f 0x7 ${device} |grep NSQA |cut -d ':' -f 2 | xargs)
-    power_state=$(nvme get-feature -H -f 0x2 ${device} | grep PS |cut -d ":" -f 2 | xargs)
-    apste=$(nvme get-feature -H -f 0xc ${device} | grep APSTE |cut -d ":" -f 2 | xargs)
-    temp=$(nvme smart-log ${device} |grep 'temperature' |cut -d ':' -f 2 |xargs)
-    info ${device_name} "Temp:${temp}, Autonomous Power State Transition:${apste}, PowerState:${power_state}, Completion Queues:${NCQA}, Submission Queues:${NSQA}"
+    status=""
+    NCQA=$(nvme get-feature -H -f 0x7 ${device} 2>&1 |grep NCQA |cut -d ':' -f 2 | xargs)
+    [ -n "${NCQA}" ] && status="${status}Completion Queues:${NCQA}, "
+    NSQA=$(nvme get-feature -H -f 0x7 ${device} 2>&1 |grep NSQA |cut -d ':' -f 2 | xargs)
+    [ -n "${NSQA}" ] && status="${status}Submission Queues:${NSQA}, "
+    power_state=$(nvme get-feature -H -f 0x2 ${device} 2>&1 | grep PS |cut -d ":" -f 2 | xargs)
+    [ -n "${power_state}" ] && status="${status}PowerState:${power_state}, "
+    apste=$(nvme get-feature -H -f 0xc ${device} 2>&1 | grep APSTE |cut -d ":" -f 2 | xargs)
+    [ -n "${apste}" ] && status="${status} Autonomous Power State Transition:${apste}, "
+    temp=$(nvme smart-log ${device} 2>&1 |grep 'temperature' |cut -d ':' -f 2 |xargs)
+    [ -n "${temp}" ] && status="${status}Temp:${temp}"
+    info ${device_name} "${status}"
   fi
 }
 
@@ -241,6 +247,7 @@ show_system() {
     info "system" "KERNEL: $(show_kernel_config_item ${config_item})"
   done
   info "system" "KERNEL: $(cat /proc/cmdline)"
+  info "system" "SElinux: $(getenforce)"
   tsc=$(journalctl -k | grep 'tsc: Refined TSC clocksource calibration:' | awk '{print $11}')
   if [ -n "${tsc}" ]; then
     info "system" "TSC: ${tsc} Mhz"
