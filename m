Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D8BC433F5
	for <fio@archiver.kernel.org>; Fri,  8 Oct 2021 12:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E00360FD8
	for <fio@archiver.kernel.org>; Fri,  8 Oct 2021 12:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240731AbhJHMCC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 8 Oct 2021 08:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhJHMCB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 8 Oct 2021 08:02:01 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58747C061570
        for <fio@vger.kernel.org>; Fri,  8 Oct 2021 05:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=rX4EwdcYUf58tt2pxrb7C1tGifY6OTl1dHIo+ueRFdA=; b=qExd7b57yCYe6sli2DBYA/Mwnc
        KeF4+Ap5vkI7clD7GudYT9NsCA+eKBMVr5Xc/imy2g8WXboX90RXYuXP7Qj1iWSikJf9hWuw0vneY
        ap8omXDJtjaySo8rPt9foKkSKyZm20KO67qGsShjsR14joJ0u3IY3hpPUMwpBP8Lq3+OaQgd9iwKQ
        f7QDs81oIyzjzvTzU5eAsLHEQy/ssdR0ifbgZ9OhVQSzWKxZw1cE/xji1aCTuY2jZLeYY1msvoEY7
        bHPYp4zVXyZ8TysNZle2WzrzzEvqTnqpR1a/XkcWnZdeE/8i9XgP2nbVEjcJTYm+gjibQatJ3lPnJ
        yt0Q2qJw==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mYoXk-008em5-Dy
        for fio@vger.kernel.org; Fri, 08 Oct 2021 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 33B811BC012A; Fri,  8 Oct 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211008120002.33B811BC012A@kernel.dk>
Date:   Fri,  8 Oct 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 09ee86fa431939cb8f634e9ee8e1fc8d9302ea59:

  t/io_uring: get rid of old debug printfs (2021-10-05 06:58:07 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b1ebcbce6499fed58f87d1bcbfd50899c508d3ab:

  Merge branch 'evelu-ocp' of https://github.com/ErwanAliasr1/fio (2021-10-07 06:18:21 -0600)

----------------------------------------------------------------
Erwan Velu (5):
      t/one-core-peak: Reporting BLK_CGROUP
      t/one-core-peak: Reporting BLK_WBT_MQ
      t/one-core-peak: Reporting kernel cmdline
      t/one-core-peak: Reporting RETPOLINE & PAGE_TABLE_ISOLATION
      t/io_uring: Add -r option to control the runtime

Jens Axboe (1):
      Merge branch 'evelu-ocp' of https://github.com/ErwanAliasr1/fio

 t/io_uring.c       | 26 ++++++++++++++++++++------
 t/one-core-peak.sh |  6 ++++--
 2 files changed, 24 insertions(+), 8 deletions(-)

---

Diff of recent changes:

diff --git a/t/io_uring.c b/t/io_uring.c
index 7ef2f6ce..2c9fd08c 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -118,6 +118,7 @@ static int do_nop = 0;		/* no-op SQ ring commands */
 static int nthreads = 1;
 static int stats = 0;		/* generate IO stats */
 static int aio = 0;		/* use libaio */
+static int runtime = 0;	/* runtime */
 
 static unsigned long tsc_rate;
 
@@ -841,11 +842,10 @@ static struct submitter *get_submitter(int offset)
 	return ret;
 }
 
-static void sig_int(int sig)
+static void do_finish(const char *reason)
 {
 	int j;
-
-	printf("Exiting on signal %d\n", sig);
+	printf("Exiting on %s\n", reason);
 	for (j = 0; j < nthreads; j++) {
 		struct submitter *s = get_submitter(j);
 		s->finish = 1;
@@ -853,6 +853,11 @@ static void sig_int(int sig)
 	finish = 1;
 }
 
+static void sig_int(int sig)
+{
+	do_finish("signal");
+}
+
 static void arm_sig_int(void)
 {
 	struct sigaction act;
@@ -1000,6 +1005,8 @@ static void file_depths(char *buf)
 
 static void usage(char *argv, int status)
 {
+	char runtime_str[16];
+	snprintf(runtime_str, sizeof(runtime_str), "%d", runtime);
 	printf("%s [options] -- [filenames]\n"
 		" -d <int>  : IO Depth, default %d\n"
 		" -s <int>  : Batch submit, default %d\n"
@@ -1013,9 +1020,11 @@ static void usage(char *argv, int status)
 		" -N <bool> : Perform just no-op requests, default %d\n"
 		" -t <bool> : Track IO latencies, default %d\n"
 		" -T <int>  : TSC rate in HZ\n"
-		" -a <bool> : Use legacy aio, default %d\n",
+		" -a <bool> : Use legacy aio, default %d\n"
+		" -r <int>  : Runtime in seconds, default %s\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
-		fixedbufs, register_files, nthreads, !buffered, do_nop, stats, aio);
+		fixedbufs, register_files, nthreads, !buffered, do_nop, stats, aio,
+		runtime == 0 ? "unlimited" : runtime_str);
 	exit(status);
 }
 
@@ -1075,7 +1084,7 @@ int main(int argc, char *argv[])
 	if (!do_nop && argc < 2)
 		usage(argv[0], 1);
 
-	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:h?")) != -1) {
+	while ((opt = getopt(argc, argv, "d:s:c:b:p:B:F:n:N:O:t:T:a:r:h?")) != -1) {
 		switch (opt) {
 		case 'a':
 			aio = !!atoi(optarg);
@@ -1133,6 +1142,9 @@ int main(int argc, char *argv[])
 			tsc_rate = strtoul(optarg, NULL, 10);
 			write_tsc_rate();
 			break;
+		case 'r':
+			runtime = atoi(optarg);
+			break;
 		case 'h':
 		case '?':
 		default:
@@ -1273,6 +1285,8 @@ int main(int argc, char *argv[])
 		unsigned long iops, bw;
 
 		sleep(1);
+		if (runtime && !--runtime)
+			do_finish("timeout");
 
 		/* don't print partial run, if interrupted by signal */
 		if (finish)
diff --git a/t/one-core-peak.sh b/t/one-core-peak.sh
index d0649d2e..11b1d69a 100755
--- a/t/one-core-peak.sh
+++ b/t/one-core-peak.sh
@@ -152,7 +152,7 @@ check_sysblock_value() {
   sys_block_dir=$(get_sys_block_dir ${device_name})
   target_file="${sys_block_dir}/$2"
   value=$3
-  [ -f "${target_file}" ] || fatal "Cannot find ${target_file} for ${device_name}"
+  [ -f "${target_file}" ] || return
   content=$(cat ${target_file})
   if [ "${content}" != "${value}" ]; then
     info "${device_name}" "${target_file} set to ${value}."
@@ -238,9 +238,10 @@ show_system() {
   info "system" "CPU: ${CPU_MODEL}"
   info "system" "MEMORY: ${MEMORY_SPEED}"
   info "system" "KERNEL: ${KERNEL}"
-  for config_item in BLK_CGROUP_IOCOST HZ; do
+  for config_item in BLK_CGROUP BLK_WBT_MQ HZ RETPOLINE PAGE_TABLE_ISOLATION; do
     info "system" "KERNEL: $(show_kernel_config_item ${config_item})"
   done
+  info "system" "KERNEL: $(cat /proc/cmdline)"
   tsc=$(journalctl -k | grep 'tsc: Refined TSC clocksource calibration:' | awk '{print $11}')
   if [ -n "${tsc}" ]; then
     info "system" "TSC: ${tsc} Mhz"
@@ -263,6 +264,7 @@ for drive in ${drives}; do
   check_sysblock_value ${drive} "queue/iostats" 0 # Ensure iostats are disabled
   check_sysblock_value ${drive} "queue/nomerges" 2 # Ensure merge are disabled
   check_sysblock_value ${drive} "queue/io_poll" 1 # Ensure io_poll is enabled
+  check_sysblock_value ${drive} "queue/wbt_lat_usec" 0 # Disabling wbt lat
   show_device ${drive}
 done
 
