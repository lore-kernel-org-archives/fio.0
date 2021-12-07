Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E837C433F5
	for <fio@archiver.kernel.org>; Tue,  7 Dec 2021 13:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhLGNDm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 7 Dec 2021 08:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhLGNDm (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 7 Dec 2021 08:03:42 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C1BC061574
        for <fio@vger.kernel.org>; Tue,  7 Dec 2021 05:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=KirmKMj5paYhD+p6Lzd0E73aqp7Zg3UYJ9gxIe0KzAE=; b=kArAynw04O6hrIg+p5fSXcMm7T
        98e40a7ZcrsR2Vmd/MHF2mQ8Md2KT8TehACGbNJ1O83neILtP5yfv58RI+nRKQgS6nM4zH5fkSWc9
        6KRAjPhopLR+M5VJtYl34BRJBFvkuYF8xdxCM+qquvhO4dHGaG6bZuPZWvE4DGcUoVIHN0p4z56bB
        NFqK/QOLZrtNBqNlzX45FFgBtoMUfkEs6Hc0NAtEcRWyuAsVedbKvs1DrXlio1GOSw53D5hTigOWF
        e2Kj1JT2lgJ7kt3QUxazLLDUEb9iPn/FQL9S6gfAqCF3WUhLaG011YbVbLziyB/2HsiDMYk59sTPP
        yA+ZuMWA==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mua4o-002lcF-0t
        for fio@vger.kernel.org; Tue, 07 Dec 2021 13:00:10 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id A304F1BC014B; Tue,  7 Dec 2021 06:00:06 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211207130006.A304F1BC014B@kernel.dk>
Date:   Tue,  7 Dec 2021 06:00:06 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit fd1d8e0ab3dc852193037a3acebcf8b8bdbcd9c5:

  filesetup: create zbd_info before jumping to done label (2021-12-02 17:54:15 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to fab60fa78a1832c17f8bb200292ded4a8b3eb2a5:

  Merge branch 'arm-detect-pmull' of https://github.com/sitsofe/fio (2021-12-06 13:26:52 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'arm-detect-pmull' of https://github.com/sitsofe/fio

Sitsofe Wheeler (1):
      os: detect PMULL support before enabling accelerated crc32c on ARM

Vincent Fu (2):
      io_ddir: return appropriate string for DDIR_INVAL
      libfio: drop unneeded reset of rwmix_issues

 io_ddir.h     | 2 +-
 libfio.c      | 1 -
 os/os-linux.h | 6 +++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

---

Diff of recent changes:

diff --git a/io_ddir.h b/io_ddir.h
index a42da97a..296a9d04 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -24,7 +24,7 @@ static inline const char *io_ddir_name(enum fio_ddir ddir)
 					"datasync", "sync_file_range",
 					"wait", };
 
-	if (ddir < DDIR_LAST)
+	if (ddir >= 0 && ddir < DDIR_LAST)
 		return name[ddir];
 
 	return "invalid";
diff --git a/libfio.c b/libfio.c
index ed5906d4..198eaf2e 100644
--- a/libfio.c
+++ b/libfio.c
@@ -140,7 +140,6 @@ void reset_all_stats(struct thread_data *td)
 		td->io_issues[i] = 0;
 		td->ts.total_io_u[i] = 0;
 		td->ts.runtime[i] = 0;
-		td->rwmix_issues = 0;
 	}
 
 	set_epoch_time(td, td->o.log_unix_epoch);
diff --git a/os/os-linux.h b/os/os-linux.h
index 808f1d02..3001140c 100644
--- a/os/os-linux.h
+++ b/os/os-linux.h
@@ -20,6 +20,9 @@
 
 #ifdef ARCH_HAVE_CRC_CRYPTO
 #include <sys/auxv.h>
+#ifndef HWCAP_PMULL
+#define HWCAP_PMULL             (1 << 4)
+#endif /* HWCAP_PMULL */
 #ifndef HWCAP_CRC32
 #define HWCAP_CRC32             (1 << 7)
 #endif /* HWCAP_CRC32 */
@@ -405,7 +408,8 @@ static inline bool os_cpu_has(cpu_features feature)
 #ifdef ARCH_HAVE_CRC_CRYPTO
 	case CPU_ARM64_CRC32C:
 		hwcap = getauxval(AT_HWCAP);
-		have_feature = (hwcap & HWCAP_CRC32) != 0;
+		have_feature = (hwcap & (HWCAP_PMULL | HWCAP_CRC32)) ==
+			       (HWCAP_PMULL | HWCAP_CRC32);
 		break;
 #endif
 	default:
