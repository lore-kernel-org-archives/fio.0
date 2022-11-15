Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6ECEC4332F
	for <fio@archiver.kernel.org>; Tue, 15 Nov 2022 20:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiKOUEy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Nov 2022 15:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231857AbiKOUEu (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Nov 2022 15:04:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC9C2AE25
        for <fio@vger.kernel.org>; Tue, 15 Nov 2022 12:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=5PO31yo9+bqfHrFxWJ5s0QVt0CrVB4OixHXtKwm744U=; b=vdysGWNLOqdVNmvWHaVcGYM3RH
        yPXhMReNorMEmfpJ4rMCjgqnPzghJy8cnfsAdh3wNJlYdZ7CNgs0y76gXupoJKaS9k0vG0BCZTNwn
        2NmBkjSN/l2lVsK7I45725reZ+RY7/tTM/qhLqjnCPJCXbr4nu6IUjJ1pIUc5jCQLSgBvREZLGqIf
        JRIB3ONGGZ8jyup33p8JYiN6+SenG0E77Q9FUxHq5joBUJBOppb2z+BVzPEtySK8Cq4UUWxMpSpJt
        yu6j2A8Ba+Z2BkJTh9AAOcTx6rN2uUknzGm2IMXmHPtqROS2RjOSP4UunolIxGAUq0g0R76rcjPFu
        2u3rwMPw==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ov2As-00GaqI-C7
        for fio@vger.kernel.org; Tue, 15 Nov 2022 20:04:50 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 2D62B1BC01BD; Tue, 15 Nov 2022 06:00:02 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221115130002.2D62B1BC01BD@kernel.dk>
Date:   Tue, 15 Nov 2022 06:00:02 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 2d92b09513b3c11a04541298aece35eae3dbc963:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-11-07 16:20:04 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 07c8fe21021681f86fbfd3c3d63b88a5ebd4e557:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-11-14 08:47:00 -0500)

----------------------------------------------------------------
Bart Van Assche (3):
      configure: Fix clock_gettime() detection
      configure: Fix the struct nvme_uring_cmd detection
      os/os.h: Improve cpus_configured()

Vincent Fu (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 configure | 10 ++++++----
 os/os.h   |  4 +++-
 2 files changed, 9 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 30bf5acb..1b12d268 100755
--- a/configure
+++ b/configure
@@ -1172,7 +1172,9 @@ cat > $TMPC << EOF
 #include <time.h>
 int main(int argc, char **argv)
 {
-  return clock_gettime(0, NULL);
+  struct timespec ts;
+
+  return clock_gettime(0, &ts);
 }
 EOF
 if compile_prog "" "" "clock_gettime"; then
@@ -1194,7 +1196,9 @@ if test "$clock_gettime" = "yes" ; then
 #include <time.h>
 int main(int argc, char **argv)
 {
-  return clock_gettime(CLOCK_MONOTONIC, NULL);
+  struct timespec ts;
+
+  return clock_gettime(CLOCK_MONOTONIC, &ts);
 }
 EOF
   if compile_prog "" "$LIBS" "clock monotonic"; then
@@ -2634,8 +2638,6 @@ cat > $TMPC << EOF
 #include <linux/nvme_ioctl.h>
 int main(void)
 {
-  struct nvme_uring_cmd *cmd;
-
   return sizeof(struct nvme_uring_cmd);
 }
 EOF
diff --git a/os/os.h b/os/os.h
index a6fde1fd..c428260c 100644
--- a/os/os.h
+++ b/os/os.h
@@ -355,7 +355,9 @@ static inline unsigned long long get_fs_free_size(const char *path)
 #ifndef FIO_HAVE_CPU_CONF_SYSCONF
 static inline unsigned int cpus_configured(void)
 {
-	return sysconf(_SC_NPROCESSORS_CONF);
+	int nr_cpus = sysconf(_SC_NPROCESSORS_CONF);
+
+	return nr_cpus >= 1 ? nr_cpus : 1;
 }
 #endif
 
