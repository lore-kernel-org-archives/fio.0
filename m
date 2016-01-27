Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbcA0NAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 27 Jan 2016 08:00:05 -0500
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aOPhc-00047O-4W
	for fio@vger.kernel.org; Wed, 27 Jan 2016 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20160127130001.EDE4D2C00E6@kernel.dk>
Date: Wed, 27 Jan 2016 06:00:01 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c5dd5d977884648f78c266e9873f667a3ed98bda:

  powerpc: fix cpus_online() to get correct max CPU number for powerpc64 (2016-01-25 08:29:50 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to a8381d78ec52d00541ddd7ef8bd7584e99361b0e:

  Fio 2.6 (2016-01-26 19:02:07 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      client: remove debug printf() for compressed iolog
      server: disable pdu length check for now
      server: split vectored commands into fragments
      Fio 2.6

 FIO-VERSION-GEN        |  2 +-
 client.c               |  1 -
 os/windows/install.wxs |  2 +-
 server.c               | 30 ++++++++++++++++++++++++------
 4 files changed, 26 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index ba75978..597e615 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.5
+DEF_VER=fio-2.6
 
 LF='
 '
diff --git a/client.c b/client.c
index 2541f46..515cbf2 100644
--- a/client.c
+++ b/client.c
@@ -1460,7 +1460,6 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		return NULL;
 #endif
 		ret = convert_iolog_gz(cmd, pdu);
-		printf("compressed iolog, %p\n", ret);
 		if (!ret) {
 			log_err("fio: failed decompressing log\n");
 			return NULL;
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index c024fb7..011c1eb 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.5">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.6">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/server.c b/server.c
index ab4069c..750717a 100644
--- a/server.c
+++ b/server.c
@@ -1062,17 +1062,35 @@ static int fio_send_cmd_ext_pdu(int sk, uint16_t opcode, const void *buf,
 {
 	struct fio_net_cmd cmd;
 	struct iovec iov[2];
+	size_t this_len;
+	int ret;
 
 	iov[0].iov_base = (void *) &cmd;
 	iov[0].iov_len = sizeof(cmd);
-	iov[1].iov_base = (void *) buf;
-	iov[1].iov_len = size;
 
-	__fio_init_net_cmd(&cmd, opcode, size, tag);
-	cmd.flags = __cpu_to_le32(flags);
-	fio_net_cmd_crc_pdu(&cmd, buf);
+	do {
+		uint32_t this_flags = flags;
+
+		this_len = size;
+		if (this_len > FIO_SERVER_MAX_FRAGMENT_PDU)
+			this_len = FIO_SERVER_MAX_FRAGMENT_PDU;
+
+		if (this_len < size)
+			this_flags |= FIO_NET_CMD_F_MORE;
 
-	return fio_sendv_data(sk, iov, 2);
+		__fio_init_net_cmd(&cmd, opcode, this_len, tag);
+		cmd.flags = __cpu_to_le32(this_flags);
+		fio_net_cmd_crc_pdu(&cmd, buf);
+
+		iov[1].iov_base = (void *) buf;
+		iov[1].iov_len = this_len;
+
+		ret = fio_sendv_data(sk, iov, 2);
+		size -= this_len;
+		buf += this_len;
+	} while (!ret && size);
+
+	return ret;
 }
 
 static void finish_entry(struct sk_entry *entry)
