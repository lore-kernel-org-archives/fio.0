Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60046 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfBINAG (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 9 Feb 2019 08:00:06 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gsSEn-0002il-OB
        for fio@vger.kernel.org; Sat, 09 Feb 2019 13:00:05 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20190209130002.12BBD2C00B5@kernel.dk>
Date: Sat,  9 Feb 2019 06:00:02 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e5eb6fbf91617be0c7d74147165909a493c90136:

  stat: put 'percentiles' object in appropriate 'clat_ns' or 'lat_ns' parent (2019-02-07 09:48:46 -0700)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 2f75f022393e432210d01b15088f425ee5260340:

  client/server: inflate error handling (2019-02-08 16:33:34 -0700)

----------------------------------------------------------------
Jeff Furlong (1):
      client/server: inflate error handling

Jens Axboe (1):
      Fio 3.13

 FIO-VERSION-GEN | 2 +-
 client.c        | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index ea5be1a9..37fb1a7a 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-3.12
+DEF_VER=fio-3.13
 
 LF='
 '
diff --git a/client.c b/client.c
index 480425f6..8d7c0331 100644
--- a/client.c
+++ b/client.c
@@ -1598,6 +1598,11 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 		err = inflate(&stream, Z_NO_FLUSH);
 		/* may be Z_OK, or Z_STREAM_END */
 		if (err < 0) {
+			/*
+			 * Z_STREAM_ERROR and Z_BUF_ERROR can safely be
+			 * ignored */
+			if (err == Z_STREAM_ERROR || err == Z_BUF_ERROR)
+				break;
 			log_err("fio: inflate error %d\n", err);
 			free(ret);
 			ret = NULL;

