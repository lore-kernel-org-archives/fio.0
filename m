Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985C3C433EF
	for <fio@archiver.kernel.org>; Sat,  2 Oct 2021 12:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B7C961AF8
	for <fio@archiver.kernel.org>; Sat,  2 Oct 2021 12:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232927AbhJBMC6 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 2 Oct 2021 08:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbhJBMC5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 2 Oct 2021 08:02:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C72C061570
        for <fio@vger.kernel.org>; Sat,  2 Oct 2021 05:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=VXJfa73YeWYIsKqQKGhQG/tTzqkyH8PxRV34MB477mE=; b=EnfNseshJ5ZoiiG/6PX4y4rulM
        0Z5DCdqfmQnGI3EkokGsCyNOFz2JHc0lomLhfF/sD0DhYdwo90FfAxxFNtUZwm1F79ocyFTw6KsXB
        TgNGzqqCzanDrZf71OOhcq/SrZyubUw910hc6oWvVYltkQze9bOr1s7E3XsBJLqyGyD3mfCoHnUPI
        kJ0tCK+7XHVYZPnZXyFtlE6oNZw5nW6b2QAZZraMNUHzjbn01eVZMjeuvf9++fLP4apb8Ev7KOHno
        bazRAMiwV6qiW7m/E/T0fqvgKpqkT3VL2VflDeYJdI6yMt+f0b4hYDf14oJYTr5itL85hcG2vppb6
        pNE4wKhQ==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mWdgU-00EuXZ-11
        for fio@vger.kernel.org; Sat, 02 Oct 2021 12:00:15 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 532751BC0139; Sat,  2 Oct 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211002120002.532751BC0139@kernel.dk>
Date:   Sat,  2 Oct 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 0f77c977ab44a10d69268546a849376efc327d47:

  zbd: Fix unexpected job termination by open zone search failure (2021-09-30 10:05:23 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ca4eefc1b55d7f9fc03bf113d63e3d0b2d7b38ae:

  Merge branch 'evelu-fixes2' of https://github.com/ErwanAliasr1/fio (2021-10-01 13:55:52 -0600)

----------------------------------------------------------------
Erwan Velu (2):
      t/one-core-peak: Report numa as off if missing
      t/one-core-peak: nvme-cli as optional tooling

Jens Axboe (2):
      t/io_uring: correct percentile ranking
      Merge branch 'evelu-fixes2' of https://github.com/ErwanAliasr1/fio

Shin'ichiro Kawasaki (2):
      Revert "Fix for loop count issue when do_verify=0 (#1093)"
      Refer td->loops instead of td->o.loops to fix loop count issue

 backend.c          |  4 ++--
 libfio.c           |  2 +-
 t/io_uring.c       |  2 +-
 t/one-core-peak.sh | 19 +++++++++++--------
 4 files changed, 15 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 4c260747..86fa6d41 100644
--- a/backend.c
+++ b/backend.c
@@ -1920,13 +1920,13 @@ static void *thread_main(void *data)
 		if (td->error || td->terminate)
 			break;
 
-		clear_io_state(td, 0);
-		
 		if (!o->do_verify ||
 		    o->verify == VERIFY_NONE ||
 		    td_ioengine_flagged(td, FIO_UNIDIR))
 			continue;
 
+		clear_io_state(td, 0);
+
 		fio_gettime(&td->start, NULL);
 
 		do_verify(td, verify_bytes);
diff --git a/libfio.c b/libfio.c
index 6144a474..ed5906d4 100644
--- a/libfio.c
+++ b/libfio.c
@@ -104,7 +104,7 @@ static void reset_io_counters(struct thread_data *td, int all)
 	/*
 	 * reset file done count if we are to start over
 	 */
-	if (td->o.time_based || td->o.loops || td->o.do_verify)
+	if (td->o.time_based || td->loops > 1 || td->o.do_verify)
 		td->nr_done_files = 0;
 }
 
diff --git a/t/io_uring.c b/t/io_uring.c
index d7ae18b0..2ec4caeb 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -115,7 +115,7 @@ static unsigned long tsc_rate;
 static int vectored = 1;
 
 static float plist[] = { 1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0,
-			80.0, 90.0, 95.0, 99.9, 99.5, 99.9, 99.95, 99.99 };
+			80.0, 90.0, 95.0, 99.0, 99.5, 99.9, 99.95, 99.99 };
 static int plist_len = 17;
 
 static unsigned long cycles_to_nsec(unsigned long cycles)
diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
index 57c45451..d0649d2e 100755
--- a/t/one-core-peak.sh
+++ b/t/one-core-peak.sh
@@ -192,18 +192,21 @@ show_nvme() {
   pci_dir="/sys/bus/pci/devices/${pci_addr}/"
   link_speed=$(cat ${pci_dir}/current_link_speed)
   irq=$(cat ${pci_dir}/irq)
-  numa=$(cat ${pci_dir}/numa_node)
+  numa=$([ -f ${pci_dir}/numa_node ] && cat ${pci_dir}/numa_node || echo "off")
   cpus=$(cat ${pci_dir}/local_cpulist)
   model=$(cat ${device_dir}/model | xargs) #xargs for trimming spaces
   fw=$(cat ${device_dir}/firmware_rev | xargs) #xargs for trimming spaces
   serial=$(cat ${device_dir}/serial | xargs) #xargs for trimming spaces
   info ${device_name} "MODEL=${model} FW=${fw} serial=${serial} PCI=${pci_addr}@${link_speed} IRQ=${irq} NUMA=${numa} CPUS=${cpus} "
-  NCQA=$(nvme get-feature -H -f 0x7 ${device} |grep NCQA |cut -d ':' -f 2 | xargs)
-  NSQA=$(nvme get-feature -H -f 0x7 ${device} |grep NSQA |cut -d ':' -f 2 | xargs)
-  power_state=$(nvme get-feature -H -f 0x2 ${device} | grep PS |cut -d ":" -f 2 | xargs)
-  apste=$(nvme get-feature -H -f 0xc ${device} | grep APSTE |cut -d ":" -f 2 | xargs)
-  temp=$(nvme smart-log ${device} |grep 'temperature' |cut -d ':' -f 2 |xargs)
-  info ${device_name} "Temp:${temp}, Autonomous Power State Transition:${apste}, PowerState:${power_state}, Completion Queues:${NCQA}, Submission Queues:${NSQA}"
+  which nvme &> /dev/null
+  if [ $? -eq 0 ]; then
+    NCQA=$(nvme get-feature -H -f 0x7 ${device} |grep NCQA |cut -d ':' -f 2 | xargs)
+    NSQA=$(nvme get-feature -H -f 0x7 ${device} |grep NSQA |cut -d ':' -f 2 | xargs)
+    power_state=$(nvme get-feature -H -f 0x2 ${device} | grep PS |cut -d ":" -f 2 | xargs)
+    apste=$(nvme get-feature -H -f 0xc ${device} | grep APSTE |cut -d ":" -f 2 | xargs)
+    temp=$(nvme smart-log ${device} |grep 'temperature' |cut -d ':' -f 2 |xargs)
+    info ${device_name} "Temp:${temp}, Autonomous Power State Transition:${apste}, PowerState:${power_state}, Completion Queues:${NCQA}, Submission Queues:${NSQA}"
+  fi
 }
 
 show_device() {
@@ -249,7 +252,7 @@ show_system() {
 ### MAIN
 check_args ${args}
 check_root
-check_binary t/io_uring lscpu grep taskset cpupower awk tr xargs dmidecode nvme
+check_binary t/io_uring lscpu grep taskset cpupower awk tr xargs dmidecode
 detect_first_core
 
 info "##################################################"
