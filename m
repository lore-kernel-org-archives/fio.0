Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbbEWMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 23 May 2015 08:00:06 -0400
Received: from [216.160.245.99] (helo=kernel.dk)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Yw860-00050K-Q6
	for fio@vger.kernel.org; Sat, 23 May 2015 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150523120001.E468F2C107E@kernel.dk>
Date: Sat, 23 May 2015 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e81ecca33755eae1118b009d0d7b4d3c740ffb5f:

  Add 'allow_mounted_write' option (2015-05-21 21:43:48 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 8e093781f7995bb77ba0dca2835567a8a88972ec:

  cconv: add allow_mounted_write (2015-05-22 09:09:49 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      cconv: add allow_mounted_write

 cconv.c  | 2 ++
 server.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index b0becb8..44f17da 100644
--- a/cconv.c
+++ b/cconv.c
@@ -73,6 +73,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	string_to_cpu(&o->cgroup, top->cgroup);
 
 	o->allow_create = le32_to_cpu(top->allow_create);
+	o->allow_mounted_write = le32_to_cpu(top->allow_mounted_write);
 	o->td_ddir = le32_to_cpu(top->td_ddir);
 	o->rw_seq = le32_to_cpu(top->rw_seq);
 	o->kb_base = le32_to_cpu(top->kb_base);
@@ -290,6 +291,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	string_to_net(top->cgroup, o->cgroup);
 
 	top->allow_create = cpu_to_le32(o->allow_create);
+	top->allow_mounted_write = cpu_to_le32(o->allow_mounted_write);
 	top->td_ddir = cpu_to_le32(o->td_ddir);
 	top->rw_seq = cpu_to_le32(o->rw_seq);
 	top->kb_base = cpu_to_le32(o->kb_base);
diff --git a/server.h b/server.h
index b94c221..9944719 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 45,
+	FIO_SERVER_VER			= 46,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 	FIO_SERVER_MAX_CMD_MB		= 2048,
