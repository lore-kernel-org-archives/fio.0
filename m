Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53981 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934700AbcIPMAH (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 16 Sep 2016 08:00:07 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1bkroM-0002Qi-DF
        for fio@vger.kernel.org; Fri, 16 Sep 2016 12:00:06 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160916120005.0B93E2C18F3@kernel.dk>
Date: Fri, 16 Sep 2016 06:00:05 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 308d69b5d340577b7886696f39753b7ba5ae9e11:

  client: ignore SEND_ETA, if we can't fin a reply command (2016-09-13 09:08:00 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7903bf87725b18495a06f7199342f167147712eb:

  Merge branch 'master' of https://github.com/jan--f/fio (2016-09-15 07:57:38 -0600)

----------------------------------------------------------------
Jan Fajerski (1):
      add simple fio.service to start fio server with systemd

Jens Axboe (1):
      Merge branch 'master' of https://github.com/jan--f/fio

 tools/fio.service | 10 ++++++++++
 1 file changed, 10 insertions(+)
 create mode 100644 tools/fio.service

---

Diff of recent changes:

diff --git a/tools/fio.service b/tools/fio.service
new file mode 100644
index 0000000..21de0b7
--- /dev/null
+++ b/tools/fio.service
@@ -0,0 +1,10 @@
+[Unit]
+
+Description=flexible I/O tester server
+After=network.target
+
+[Service]
+
+Type=simple
+PIDFile=/run/fio.pid
+ExecStart=/usr/bin/fio --server
