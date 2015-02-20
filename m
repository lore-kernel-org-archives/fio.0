Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51843 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbbBTNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 20 Feb 2015 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YOnBc-0007or-DD
	for fio@vger.kernel.org; Fri, 20 Feb 2015 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150220130003.5D54340182@lyth.info>
Date: Fri, 20 Feb 2015 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 83da8fbfa3cdcd16bef7276af6aec0eea4a4566b:

  Allow verify w/norandommap and bsrange (2015-02-18 10:38:37 -0800)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to bb1116fe9a53154447bb4305ed9d9fd42d2a6aa1:

  Fixup whitespace damage in the two previous commits (2015-02-19 08:47:34 -0800)

----------------------------------------------------------------
Erwan Velu (2):
      iolog: Don't leak memory if fread fails in iolog_file_inflate
      axmap: Avoid memory leak if axmap_new() failed

Jens Axboe (1):
      Fixup whitespace damage in the two previous commits

 iolog.c     |    2 ++
 lib/axmap.c |    1 +
 2 files changed, 3 insertions(+)

---

Diff of recent changes:

diff --git a/iolog.c b/iolog.c
index b867583..dfa329f 100644
--- a/iolog.c
+++ b/iolog.c
@@ -876,10 +876,12 @@ int iolog_file_inflate(const char *file)
 	if (ret < 0) {
 		perror("fread");
 		fclose(f);
+		free(buf);
 		return 1;
 	} else if (ret != 1) {
 		log_err("fio: short read on reading log\n");
 		fclose(f);
+		free(buf);
 		return 1;
 	}
 
diff --git a/lib/axmap.c b/lib/axmap.c
index 164300f..9153df5 100644
--- a/lib/axmap.c
+++ b/lib/axmap.c
@@ -125,6 +125,7 @@ err:
 			free(axmap->levels[i].map);
 
 	free(axmap->levels);
+	free(axmap);
 	return NULL;
 }
 
