Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3808C433F5
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 12:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CF00619EC
	for <fio@archiver.kernel.org>; Thu, 30 Sep 2021 12:00:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350623AbhI3MBu (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350490AbhI3MBt (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Sep 2021 08:01:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E90DC06176A
        for <fio@vger.kernel.org>; Thu, 30 Sep 2021 05:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=UDM9YtyVsDWKgDtOz0nwVF6KvL7q1TbspWCpsmGc9zc=; b=VwDxAtwQ+nWn6mypQET70M0meh
        e2PMTpovbZVVnaum/3oL8W+T4aRRIqFGnyrh3bIDPe5PQ3e2qrpre0EvCUyhhkMA36r+zkc5x8pzg
        NlZgOWWDHauwgB3Rw7T2NE5hjax7lyw430jnVBMP+1dq4hpMwDh/9yDMBTv20Fwhl/0RV75FS+nKk
        USwF7Sp+RaYHwbJ04huiiN/qpmTOtmThTWe5hcE0vX5uW7Mi43s2/s4wbzmcKCeV/RH8R6dT1T4hM
        1NJ3PXhz/dk6gip3A9JBd+4DXtn6zYSXquKE5xOJ8LX5xwgOvFpdsJDPP/4WIxogXyG0SHU2nleBt
        l+u9pIGA==;
Received: from [65.144.74.35] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVujM-006wpE-GV
        for fio@vger.kernel.org; Thu, 30 Sep 2021 12:00:04 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 0D8C81BC0172; Thu, 30 Sep 2021 06:00:02 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20210930120002.0D8C81BC0172@kernel.dk>
Date:   Thu, 30 Sep 2021 06:00:02 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit cd312799e6a82557abbd742797b59f51e8c2c2e4:

  Merge branch 'sigbreak' of https://github.com/bjpaupor/fio (2021-09-28 13:28:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 203e4c2624493c0db8c69c9ad830090c5b79be67:

  t/io_uring: store TSC rate in local file (2021-09-29 20:16:54 -0600)

----------------------------------------------------------------
Jens Axboe (2):
      Merge branch 'patch-1' of https://github.com/ravisowmya/fio
      t/io_uring: store TSC rate in local file

ravisowmya (1):
      Fix for loop count issue when do_verify=0 (#1093)

 .gitignore   |  1 +
 backend.c    |  4 ++--
 t/io_uring.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+), 2 deletions(-)

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index 6651f96e..72494a1e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -31,3 +31,4 @@ doc/output
 /TAGS
 /t/zbd/test-zbd-support.log.*
 /t/fuzz/fuzz_parseini
+tsc-rate
diff --git a/backend.c b/backend.c
index 86fa6d41..4c260747 100644
--- a/backend.c
+++ b/backend.c
@@ -1920,13 +1920,13 @@ static void *thread_main(void *data)
 		if (td->error || td->terminate)
 			break;
 
+		clear_io_state(td, 0);
+		
 		if (!o->do_verify ||
 		    o->verify == VERIFY_NONE ||
 		    td_ioengine_flagged(td, FIO_UNIDIR))
 			continue;
 
-		clear_io_state(td, 0);
-
 		fio_gettime(&td->start, NULL);
 
 		do_verify(td, verify_bytes);
diff --git a/t/io_uring.c b/t/io_uring.c
index e5568aa2..d7ae18b0 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -110,6 +110,8 @@ static int nthreads = 1;
 static int stats = 0;		/* generate IO stats */
 static unsigned long tsc_rate;
 
+#define TSC_RATE_FILE	"tsc-rate"
+
 static int vectored = 1;
 
 static float plist[] = { 1.0, 5.0, 10.0, 20.0, 30.0, 40.0, 50.0, 60.0, 70.0,
@@ -816,6 +818,50 @@ static void usage(char *argv, int status)
 	exit(status);
 }
 
+static void read_tsc_rate(void)
+{
+	char buffer[32];
+	int fd, ret;
+
+	if (tsc_rate)
+		return;
+
+	fd = open(TSC_RATE_FILE, O_RDONLY);
+	if (fd < 0)
+		return;
+
+	ret = read(fd, buffer, sizeof(buffer));
+	if (ret < 0) {
+		close(fd);
+		return;
+	}
+
+	tsc_rate = strtoul(buffer, NULL, 10);
+	printf("Using TSC rate %luHz\n", tsc_rate);
+	close(fd);
+}
+
+static void write_tsc_rate(void)
+{
+	char buffer[32];
+	struct stat sb;
+	int fd, ret;
+
+	if (!stat(TSC_RATE_FILE, &sb))
+		return;
+
+	fd = open(TSC_RATE_FILE, O_WRONLY | O_CREAT, 0644);
+	if (fd < 0)
+		return;
+
+	memset(buffer, 0, sizeof(buffer));
+	sprintf(buffer, "%lu", tsc_rate);
+	ret = write(fd, buffer, strlen(buffer));
+	if (ret < 0)
+		perror("write");
+	close(fd);
+}
+
 int main(int argc, char *argv[])
 {
 	struct submitter *s;
@@ -881,6 +927,7 @@ int main(int argc, char *argv[])
 			return 1;
 #endif
 			tsc_rate = strtoul(optarg, NULL, 10);
+			write_tsc_rate();
 			break;
 		case 'h':
 		case '?':
@@ -890,6 +937,9 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	if (stats)
+		read_tsc_rate();
+
 	if (batch_complete > depth)
 		batch_complete = depth;
 	if (batch_submit > depth)
