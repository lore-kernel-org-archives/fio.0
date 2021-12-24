Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B420CC433EF
	for <fio@archiver.kernel.org>; Fri, 24 Dec 2021 13:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352686AbhLXNAI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 24 Dec 2021 08:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbhLXNAI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 24 Dec 2021 08:00:08 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6418EC061401
        for <fio@vger.kernel.org>; Fri, 24 Dec 2021 05:00:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Date:Message-Id:To:From:Subject:Sender
        :Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=CRFPwbi59Tj033f7XBT8JwxudJW60BRzbQ8FYPpWZAE=; b=ZjAy/tm19QY7OgiJ+jbjG1l263
        ExU/e6T1yjYzD6pBIM9kpbHiJ+CAUWWP3DRpscLloznYalUIppHGvN+dZG8nhpoJAYT11ku5WDsT6
        iDdaDmwn+JumC0xj0ppfu/GUIIbbITzSrvrIF62jUHwZeRjduMHJDVPdX/8OQvRkEuoM653eORHRT
        4Y6qxyfMrpS1I9B5Vh8iP5lBkUhDGBLQsBzR/oiy0nsajjGccnWtyAgcqHD5dbuTDVP4UWIqxcyr9
        Gqct3A0DuPxRqhgWMF4Ij1ZfYl7x6ystPArruDurwK1v8hLS5ItUN13gqxDmEcj1VCj+S/HfTDdmX
        KECXuL3w==;
Received: from [207.135.234.126] (helo=kernel.dk)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1n0kB3-003I1Y-07
        for fio@vger.kernel.org; Fri, 24 Dec 2021 13:00:05 +0000
Received: by kernel.dk (Postfix, from userid 1000)
        id D3A401BC011B; Fri, 24 Dec 2021 06:00:01 -0700 (MST)
Subject: Recent changes (master)
From:   Jens Axboe <axboe@kernel.dk>
To:     <fio@vger.kernel.org>
X-Mailer: mail (GNU Mailutils 3.7)
Message-Id: <20211224130001.D3A401BC011B@kernel.dk>
Date:   Fri, 24 Dec 2021 06:00:01 -0700 (MST)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

The following changes since commit 9b46661c289d01dbfe5182189a7abea9ce2f9e04:

  Fio 3.29 (2021-12-18 07:09:32 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a3e33e2fc06582e4170f90ae6e62d6225d52dc7c:

  Merge branch 'github-actions-i686' of https://github.com/vincentkfu/fio (2021-12-23 16:27:33 -0700)

----------------------------------------------------------------
Jens Axboe (1):
      Merge branch 'github-actions-i686' of https://github.com/vincentkfu/fio

Vincent Fu (4):
      ci: workaround for problem with i686 builds
      Revert "ci: temporarily remove linux-i686-gcc build"
      t/io_uring: fix 32-bit build warnings
      t/io_uring: fix help defaults for aio and random_io

 .github/workflows/ci.yml | 4 ++++
 ci/actions-install.sh    | 5 ++++-
 t/io_uring.c             | 9 +++++----
 3 files changed, 13 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 8167e3d1..cd8ce142 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -14,6 +14,7 @@ jobs:
         - linux-gcc
         - linux-clang
         - macos
+        - linux-i686-gcc
         include:
         - build: linux-gcc
           os: ubuntu-20.04
@@ -23,6 +24,9 @@ jobs:
           cc: clang
         - build: macos
           os: macos-11
+        - build: linux-i686-gcc
+          os: ubuntu-20.04
+          arch: i686
 
     env:
       CI_TARGET_ARCH: ${{ matrix.arch }}
diff --git a/ci/actions-install.sh b/ci/actions-install.sh
index 7408ccb4..b3486a47 100755
--- a/ci/actions-install.sh
+++ b/ci/actions-install.sh
@@ -31,14 +31,17 @@ DPKGCFG
     case "${CI_TARGET_ARCH}" in
         "i686")
             sudo dpkg --add-architecture i386
+            opts="--allow-downgrades"
             pkgs=("${pkgs[@]/%/:i386}")
             pkgs+=(
                 gcc-multilib
                 pkg-config:i386
                 zlib1g-dev:i386
+		libpcre2-8-0=10.34-7
             )
             ;;
         "x86_64")
+            opts=""
             pkgs+=(
                 libglusterfs-dev
                 libgoogle-perftools-dev
@@ -62,7 +65,7 @@ DPKGCFG
     echo "Updating APT..."
     sudo apt-get -qq update
     echo "Installing packages..."
-    sudo apt-get install -o APT::Immediate-Configure=false --no-install-recommends -qq -y "${pkgs[@]}"
+    sudo apt-get install "$opts" -o APT::Immediate-Configure=false --no-install-recommends -qq -y "${pkgs[@]}"
 }
 
 install_linux() {
diff --git a/t/io_uring.c b/t/io_uring.c
index a98f78fd..e8365a79 100644
--- a/t/io_uring.c
+++ b/t/io_uring.c
@@ -634,7 +634,8 @@ static int submitter_init(struct submitter *s)
 #ifdef CONFIG_LIBAIO
 static int prep_more_ios_aio(struct submitter *s, int max_ios, struct iocb *iocbs)
 {
-	unsigned long offset, data;
+	uint64_t data;
+	long long offset;
 	struct file *f;
 	unsigned index;
 	long r;
@@ -663,7 +664,7 @@ static int prep_more_ios_aio(struct submitter *s, int max_ios, struct iocb *iocb
 
 		data = f->fileno;
 		if (stats && stats_running)
-			data |= ((unsigned long) s->clock_index << 32);
+			data |= (((uint64_t) s->clock_index) << 32);
 		iocb->data = (void *) (uintptr_t) data;
 		index++;
 	}
@@ -676,7 +677,7 @@ static int reap_events_aio(struct submitter *s, struct io_event *events, int evs
 	int reaped = 0;
 
 	while (evs) {
-		unsigned long data = (uintptr_t) events[reaped].data;
+		uint64_t data = (uintptr_t) events[reaped].data;
 		struct file *f = &s->files[data & 0xffffffff];
 
 		f->pending_ios--;
@@ -1094,7 +1095,7 @@ static void usage(char *argv, int status)
 		" -a <bool> : Use legacy aio, default %d\n",
 		argv, DEPTH, BATCH_SUBMIT, BATCH_COMPLETE, BS, polled,
 		fixedbufs, dma_map, register_files, nthreads, !buffered, do_nop,
-		stats, runtime == 0 ? "unlimited" : runtime_str, aio, random_io);
+		stats, runtime == 0 ? "unlimited" : runtime_str, random_io, aio);
 	exit(status);
 }
 
