Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D19C07545
	for <fio@archiver.kernel.org>; Tue, 24 Oct 2023 12:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbjJXMAQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 24 Oct 2023 08:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjJXMAP (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 24 Oct 2023 08:00:15 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68291BD
        for <fio@vger.kernel.org>; Tue, 24 Oct 2023 05:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=PKI8/tgSesPGnGMC46ZvxfeRO6/9hOdXV5ZqnZtoLh0=; b=UK2gOQRQu3w8QdN3xnT1SuaINs
        9trTNS9aNCTAldWxILMiibEdIEYZE5n38DZOEiMaGy3QR2qHgf3KgNVwc3E7YhDmFioOet7T4LJnf
        BOvVePPzFAsAJxtKwAjYQL9EtoFP4KhzbftVGsLp7f+BCTBlgFdaxzBWFYwSG+MPpSWg1dIIlR48S
        k2ZzP/iKWOTsogpA6+utbJ7PC7wJW4XaMeSUvfphEv21Wz0S8SyV0Thh7dra83JKC3cXlJtRz5UA7
        pG6QqF8PaxNrzJJbakgqmPUgYL4+12zbXS3Qa96TlNPs215qn0fzaZGekCPX5SR4YUXsE855iHQo9
        94k9XwXA==;
Received: from [96.43.243.2] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvG4q-00FTIy-25
        for fio@vger.kernel.org;
        Tue, 24 Oct 2023 12:00:07 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id 84ED01BC0167; Tue, 24 Oct 2023 06:00:01 -0600 (MDT)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20231024120001.84ED01BC0167@kernel.dk>
Date:   Tue, 24 Oct 2023 06:00:01 -0600 (MDT)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit d4fdbe3fa91bbcc9583886af35b56cc7b691f8fa:

  Merge branch 'fix-riscv64-cpu-clock' of https://github.com/gilbsgilbs/fio (2023-10-22 18:52:51 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to c11e22e92f3796f21eb15eb6ddc1614d9fa4f99d:

  Merge branch 'spellingfixes-2023-10-23' of https://github.com/proact-de/fio (2023-10-23 08:32:46 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'spellingfixes-2023-10-23' of https://github.com/proact-de/fio

Martin Steigerwald (1):
      Various spelling fixes.

 HOWTO.rst | 14 +++++++-------
 configure |  2 +-
 fio.1     |  8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

---

Diff of recent changes:

diff --git a/HOWTO.rst b/HOWTO.rst
index cc7124b1..6a8fb3e3 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2344,8 +2344,8 @@ with the caveat that when used on the command line, they must come after the
 
 		cmdprio_bssplit=blocksize/percentage/class/level/hint:...
 
-	This is an extension of the second accepted format that allows to also
-	specify a priority hint.
+	This is an extension of the second accepted format that allows one to
+	also specify a priority hint.
 
 	For all formats, only the read and write data directions are supported,
 	values for trim IOs are ignored. This option is mutually exclusive with
@@ -3014,7 +3014,7 @@ with the caveat that when used on the command line, they must come after the
 	**hugepage**
 		Use hugepages, instead of existing posix memory backend. The
 		memory backend uses hugetlbfs. This require users to allocate
-		hugepages, mount hugetlbfs and set an enviornment variable for
+		hugepages, mount hugetlbfs and set an environment variable for
 		XNVME_HUGETLB_PATH.
 	**spdk**
 		Uses SPDK's memory allocator.
@@ -3047,7 +3047,7 @@ with the caveat that when used on the command line, they must come after the
 	creating but before connecting the libblkio instance. Each property must
 	have the format ``<name>=<value>``. Colons can be escaped as ``\:``.
 	These are set after the engine sets any other properties, so those can
-	be overriden. Available properties depend on the libblkio version in use
+	be overridden. Available properties depend on the libblkio version in use
 	and are listed at
 	https://libblkio.gitlab.io/libblkio/blkio.html#properties
 
@@ -3071,7 +3071,7 @@ with the caveat that when used on the command line, they must come after the
 	connecting but before starting the libblkio instance. Each property must
 	have the format ``<name>=<value>``. Colons can be escaped as ``\:``.
 	These are set after the engine sets any other properties, so those can
-	be overriden. Available properties depend on the libblkio version in use
+	be overridden. Available properties depend on the libblkio version in use
 	and are listed at
 	https://libblkio.gitlab.io/libblkio/blkio.html#properties
 
@@ -3635,8 +3635,8 @@ Threads, processes and job synchronization
 	By default, fio will continue running all other jobs when one job finishes.
 	Sometimes this is not the desired action. Setting ``exitall`` will
 	instead make fio terminate all jobs in the same group. The option
-        ``exit_what`` allows to control which jobs get terminated when ``exitall`` is
-        enabled. The default is ``group`` and does not change the behaviour of
+        ``exit_what`` allows one to control which jobs get terminated when ``exitall``
+        is enabled. The default is ``group`` and does not change the behaviour of
         ``exitall``. The setting ``all`` terminates all jobs. The setting ``stonewall``
         terminates all currently running jobs across all groups and continues execution
         with the next stonewalled group.
diff --git a/configure b/configure
index 742cb7c5..3e3f8132 100755
--- a/configure
+++ b/configure
@@ -334,7 +334,7 @@ if test "$show_help" = "yes" ; then
 fi
 
 cross_prefix=${cross_prefix-${CROSS_COMPILE}}
-# Preferred compiler (can be overriden later after we know the platform):
+# Preferred compiler (can be overridden later after we know the platform):
 #  ${CC} (if set)
 #  ${cross_prefix}gcc (if cross-prefix specified)
 #  gcc if available
diff --git a/fio.1 b/fio.1
index 628e278d..a8dc8f6c 100644
--- a/fio.1
+++ b/fio.1
@@ -2142,7 +2142,7 @@ The third accepted format for this option is:
 cmdprio_bssplit=blocksize/percentage/class/level/hint:...
 .RE
 .P
-This is an extension of the second accepted format that allows to also
+This is an extension of the second accepted format that allows one to also
 specify a priority hint.
 .P
 For all formats, only the read and write data directions are supported, values
@@ -2774,7 +2774,7 @@ This is the default posix memory backend for linux NVMe driver.
 .BI hugepage
 Use hugepages, instead of existing posix memory backend. The memory backend
 uses hugetlbfs. This require users to allocate hugepages, mount hugetlbfs and
-set an enviornment variable for XNVME_HUGETLB_PATH.
+set an environment variable for XNVME_HUGETLB_PATH.
 .TP
 .BI spdk
 Uses SPDK's memory allocator.
@@ -2803,7 +2803,7 @@ support it; see \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
 A colon-separated list of additional libblkio properties to be set after
 creating but before connecting the libblkio instance. Each property must have
 the format \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are
-set after the engine sets any other properties, so those can be overriden.
+set after the engine sets any other properties, so those can be overridden.
 Available properties depend on the libblkio version in use and are listed at
 \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
 .TP
@@ -2821,7 +2821,7 @@ may support it; see \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#drivers\fR
 A colon-separated list of additional libblkio properties to be set after
 connecting but before starting the libblkio instance. Each property must have
 the format \fB<name>=<value>\fR. Colons can be escaped as \fB\\:\fR. These are
-set after the engine sets any other properties, so those can be overriden.
+set after the engine sets any other properties, so those can be overridden.
 Available properties depend on the libblkio version in use and are listed at
 \fIhttps://libblkio.gitlab.io/libblkio/blkio.html#properties\fR
 .TP
