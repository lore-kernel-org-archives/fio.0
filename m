Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AA2C4332F
	for <fio@archiver.kernel.org>; Tue,  8 Nov 2022 13:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbiKHNAN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 8 Nov 2022 08:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234302AbiKHNAK (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 8 Nov 2022 08:00:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A6913F85
        for <fio@vger.kernel.org>; Tue,  8 Nov 2022 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Date:Message-Id:To:From:Subject:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=P5/U8qXBvPnKPviZgGxiToOSEwrozt+sAMEmAJgm7hQ=; b=k0sM1866hwV8K6sQL/0gHC/VPI
        rApun8QFKiRp7+WpPZKI4yga9rnlA6/yEL8SmJFqcB9lVYbcux7KVWZmudWaB3mnectNCA3K/6vfk
        uxq1b2u0NS3jv+N+JpsZkn3Akw7JVR3/7hQg9svUfmpZdNzRVbJDWddXSdT3UYA6q2nFOgIwoMCP8
        R++tRA+V2x3nwuVQ2ciB1ZhprMYZ7WMSzVSyjagBlx8htytiFNlGJDa/2t3+HYN9gQ7P1bNQFmd98
        S9nzqqS//Sp+7JqZKU5PfOsFgWMABUXjY78SYikacYhscGpRUSb4aBbmqM4vqnrYTN6zwcHhri1Wc
        hWoyYD6A==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1osOD4-00AHCl-Vn
        for fio@vger.kernel.org; Tue, 08 Nov 2022 13:00:11 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 867811BC0134; Tue,  8 Nov 2022 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20221108130001.867811BC0134@kernel.dk>
Date:   Tue,  8 Nov 2022 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 72bcaffd7d56d4c2ebad6d0a1e465e0e9db8be40:

  Fio 3.33 (2022-11-06 13:55:41 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2d92b09513b3c11a04541298aece35eae3dbc963:

  Merge branch 'master' of https://github.com/bvanassche/fio (2022-11-07 16:20:04 -0700)

----------------------------------------------------------------
Bart Van Assche (2):
      Windows: Fix the build
      Android: Enable zoned block device support

Jens Axboe (1):
      Merge branch 'master' of https://github.com/bvanassche/fio

 configure                         |  2 +-
 os/windows/dlls.c                 | 16 +++++++++++-----
 os/windows/posix/include/syslog.h |  2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

---

Diff of recent changes:

diff --git a/configure b/configure
index 24c599a8..30bf5acb 100755
--- a/configure
+++ b/configure
@@ -2561,7 +2561,7 @@ if compile_prog "" "" "valgrind_dev"; then
 fi
 print_config "Valgrind headers" "$valgrind_dev"
 
-if test "$targetos" = "Linux" ; then
+if test "$targetos" = "Linux" || test "$targetos" = "Android"; then
 ##########################################
 # <linux/blkzoned.h> probe
 if test "$linux_blkzoned" != "yes" ; then
diff --git a/os/windows/dlls.c b/os/windows/dlls.c
index 774b1c61..ffedfa1e 100644
--- a/os/windows/dlls.c
+++ b/os/windows/dlls.c
@@ -11,12 +11,18 @@ void os_clk_tck(long *clk_tck)
 	 */
 	unsigned long minRes, maxRes, curRes;
 	HMODULE lib;
-	FARPROC queryTimer;
-	FARPROC setTimer;
+	NTSTATUS NTAPI (*queryTimer)
+		(OUT PULONG              MinimumResolution,
+		 OUT PULONG              MaximumResolution,
+		 OUT PULONG              CurrentResolution);
+	NTSTATUS NTAPI (*setTimer)
+		(IN ULONG                DesiredResolution,
+		 IN BOOLEAN              SetResolution,
+		 OUT PULONG              CurrentResolution);
 
 	if (!(lib = LoadLibrary(TEXT("ntdll.dll"))) ||
-		!(queryTimer = GetProcAddress(lib, "NtQueryTimerResolution")) ||
-		!(setTimer = GetProcAddress(lib, "NtSetTimerResolution"))) {
+		!(queryTimer = (void *)GetProcAddress(lib, "NtQueryTimerResolution")) ||
+		!(setTimer = (void *)GetProcAddress(lib, "NtSetTimerResolution"))) {
 		dprint(FD_HELPERTHREAD, 
 			"Failed to load ntdll library, set to lower bound 64 Hz\n");
 		*clk_tck = 64;
@@ -30,4 +36,4 @@ void os_clk_tck(long *clk_tck)
 		setTimer(maxRes, 1, &curRes);
 		*clk_tck = (long) (10000000L / maxRes);
 	}
-}
\ No newline at end of file
+}
diff --git a/os/windows/posix/include/syslog.h b/os/windows/posix/include/syslog.h
index b8582e95..03a04f69 100644
--- a/os/windows/posix/include/syslog.h
+++ b/os/windows/posix/include/syslog.h
@@ -1,7 +1,7 @@
 #ifndef SYSLOG_H
 #define SYSLOG_H
 
-int syslog();
+int syslog(int priority, const char *format, ...);
 
 #define LOG_INFO	0x1
 #define LOG_ERROR	0x2
