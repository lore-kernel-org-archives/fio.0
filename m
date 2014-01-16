Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:57207 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaAPEzL (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 15 Jan 2014 23:55:11 -0500
Received: from kernel.dk ([54.225.238.116])
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1W3eyz-0004ru-GM
	for fio@vger.kernel.org; Thu, 16 Jan 2014 04:55:09 +0000
Subject: Recent changes (master)
From: Jens Axboe <jaxboe@fusionio.com>
Message-Id: <20140116050002.C6EFD231CE@kernel.dk>
Date: Thu, 16 Jan 2014 06:00:02 +0100 (CET)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ce35b1ece06ce27ebff111e47c2a6610c311a92b:

  Add option for specifically setting buffer contents (2014-01-14 15:35:58 -0700)

are available in the git repository at:
  git://git.kernel.dk/fio.git master

Jens Axboe (1):
      server: convert buffer pattern settings across client/server

 cconv.c  |    4 ++++
 server.h |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

---

Diff of recent changes:

diff --git a/cconv.c b/cconv.c
index 3a6880a..3f41ae4 100644
--- a/cconv.c
+++ b/cconv.c
@@ -107,6 +107,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->verify_offset = le32_to_cpu(top->verify_offset);
 
 	memcpy(o->verify_pattern, top->verify_pattern, MAX_PATTERN_SIZE);
+	memcpy(o->buffer_pattern, top->buffer_pattern, MAX_PATTERN_SIZE);
 
 	o->verify_pattern_bytes = le32_to_cpu(top->verify_pattern_bytes);
 	o->verify_fatal = le32_to_cpu(top->verify_fatal);
@@ -174,6 +175,7 @@ void convert_thread_options_to_cpu(struct thread_options *o,
 	o->zero_buffers = le32_to_cpu(top->zero_buffers);
 	o->refill_buffers = le32_to_cpu(top->refill_buffers);
 	o->scramble_buffers = le32_to_cpu(top->scramble_buffers);
+	o->buffer_pattern_bytes = le32_to_cpu(top->buffer_pattern_bytes);
 	o->time_based = le32_to_cpu(top->time_based);
 	o->disable_lat = le32_to_cpu(top->disable_lat);
 	o->disable_clat = le32_to_cpu(top->disable_clat);
@@ -327,6 +329,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	top->zero_buffers = cpu_to_le32(o->zero_buffers);
 	top->refill_buffers = cpu_to_le32(o->refill_buffers);
 	top->scramble_buffers = cpu_to_le32(o->scramble_buffers);
+	top->buffer_pattern_bytes = cpu_to_le32(o->buffer_pattern_bytes);
 	top->time_based = cpu_to_le32(o->time_based);
 	top->disable_lat = cpu_to_le32(o->disable_lat);
 	top->disable_clat = cpu_to_le32(o->disable_clat);
@@ -389,6 +392,7 @@ void convert_thread_options_to_net(struct thread_options_pack *top,
 	}
 
 	memcpy(top->verify_pattern, o->verify_pattern, MAX_PATTERN_SIZE);
+	memcpy(top->buffer_pattern, o->buffer_pattern, MAX_PATTERN_SIZE);
 
 	top->size = __cpu_to_le64(o->size);
 	top->verify_backlog = __cpu_to_le64(o->verify_backlog);
diff --git a/server.h b/server.h
index 0416fd7..57e15d7 100644
--- a/server.h
+++ b/server.h
@@ -38,7 +38,7 @@ struct fio_net_cmd_reply {
 };
 
 enum {
-	FIO_SERVER_VER			= 29,
+	FIO_SERVER_VER			= 30,
 
 	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
 
