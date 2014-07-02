Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:60393 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaGBMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 Jul 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1X2JCm-00029r-A7
	for fio@vger.kernel.org; Wed, 02 Jul 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140702120002.D099940165@lyth.info>
Date: Wed,  2 Jul 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit ae5888523480f094ce04375a45797e111273ab22:

  Add option for including byte offset for each log entry (2014-06-30 20:59:03 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 3310fcedbf11916c20aca6cffc20264a6e781e32:

  client: fix missing init of 'i' (2014-07-01 16:07:59 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      Add a typecheck for the endianness conversions
      client: fix missing pdu->log_offset endianness conversion
      client: fix missing init of 'i'

 client.c            |    6 +++---
 compiler/compiler.h |   11 +++++++++++
 iolog.h             |    4 ++--
 os/os.h             |    8 +++++++-
 4 files changed, 23 insertions(+), 6 deletions(-)

---

Diff of recent changes:

diff --git a/client.c b/client.c
index 4587824..e70a27d 100644
--- a/client.c
+++ b/client.c
@@ -1154,9 +1154,9 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 	/*
 	 * Get header first, it's not compressed
 	 */
-	nr_samples = le32_to_cpu(pdu->nr_samples);
+	nr_samples = le64_to_cpu(pdu->nr_samples);
 
-	total = nr_samples * __log_entry_sz(pdu->log_offset);
+	total = nr_samples * __log_entry_sz(le32_to_cpu(pdu->log_offset));
 	ret = malloc(total + sizeof(*pdu));
 	ret->nr_samples = nr_samples;
 
@@ -1232,7 +1232,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd)
 	ret->compressed		= le32_to_cpu(ret->compressed);
 	ret->log_offset		= le32_to_cpu(ret->log_offset);
 
-	samples = &ret->samples[i];
+	samples = &ret->samples[0];
 	for (i = 0; i < ret->nr_samples; i++) {
 		struct io_sample *s;
 
diff --git a/compiler/compiler.h b/compiler/compiler.h
index 0a0213b..e1afcb4 100644
--- a/compiler/compiler.h
+++ b/compiler/compiler.h
@@ -22,4 +22,15 @@
 
 #define fio_unlikely(x)	__builtin_expect(!!(x), 0)
 
+/*
+ * Check at compile time that something is of a particular type.
+ * Always evaluates to 1 so you may use it easily in comparisons.
+ */
+#define typecheck(type,x) \
+({	type __dummy; \
+	typeof(x) __dummy2; \
+	(void)(&__dummy == &__dummy2); \
+	1; \
+})
+
 #endif
diff --git a/iolog.h b/iolog.h
index b387f48..eed9297 100644
--- a/iolog.h
+++ b/iolog.h
@@ -48,8 +48,8 @@ struct io_log {
 	/*
 	 * Entries already logged
 	 */
-	unsigned long nr_samples;
-	unsigned long max_samples;
+	uint64_t nr_samples;
+	uint64_t max_samples;
 	void *log;
 
 	unsigned int log_type;
diff --git a/os/os.h b/os/os.h
index b8eee66..df706ab 100644
--- a/os/os.h
+++ b/os/os.h
@@ -202,23 +202,29 @@ static inline uint64_t fio_swap64(uint64_t val)
 
 #ifdef FIO_INTERNAL
 #define le16_to_cpu(val) ({			\
+	typecheck(uint16_t, val);		\
 	__le16_to_cpu(val);			\
 })
 #define le32_to_cpu(val) ({			\
+	typecheck(uint32_t, val);		\
 	__le32_to_cpu(val);			\
 })
 #define le64_to_cpu(val) ({			\
-	__le64_to_cpu(val);				\
+	typecheck(uint64_t, val);		\
+	__le64_to_cpu(val);			\
 })
 #endif
 
 #define cpu_to_le16(val) ({			\
+	typecheck(uint16_t, val);		\
 	__cpu_to_le16(val);			\
 })
 #define cpu_to_le32(val) ({			\
+	typecheck(uint32_t, val);		\
 	__cpu_to_le32(val);			\
 })
 #define cpu_to_le64(val) ({			\
+	typecheck(uint64_t, val);		\
 	__cpu_to_le64(val);			\
 })
 
