Return-Path: <sbates@raithlin.com>
From: sbates@raithlin.com
Subject: [PATCH] Add option to keep memory-mapped files
Date: Fri, 28 Jul 2017 21:03:11 -0600
Message-Id: <1501297391-1880-1-git-send-email-sbates@raithlin.com>
MIME-Version: 1.0
Content-Type: text/plain
Return-Path: sbates@raithlin.com
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: logang@deltatee.com, Stephen Bates <sbates@raithlin.com>
List-ID: <fio@vger.kernel.org>

From: Stephen Bates <sbates@raithlin.com>

By default file backed memory mappings are unlink()'ed after use. This
flag allows us to optionally keep them around.

Discovered this when doing p2pmem testing and fio kept deleting the
/dev/p2pmem0 files...

Signed-off-by: Stephen Bates <sbates@raithlin.com>
---
 HOWTO            |  8 ++++++++
 fio.1            |  6 ++++++
 memory.c         |  5 +++--
 options.c        | 12 ++++++++++++
 thread_options.h |  1 +
 5 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/HOWTO b/HOWTO
index caf6591a..f9044e19 100644
--- a/HOWTO
+++ b/HOWTO
@@ -1548,6 +1548,14 @@ Buffers and memory
 	should point there. So if it's mounted in :file:`/huge`, you would use
 	`mem=mmaphuge:/huge/somefile`.
 
+.. option:: mem_keep=bool, iomem_keep=bool
+
+	When the I/O memory buffers used by fio are file-backed the default
+	behaviour is to delete (unlink()) the file when it is no
+	longer needed. That is problematic when we'd prefer to keep
+	that file. Set this flag to indicate to you wish to keep the
+	file after use.
+
 .. option:: iomem_align=int
 
 	This indicates the memory alignment of the I/O memory buffers.  Note that
diff --git a/fio.1 b/fio.1
index a5ec1999..ad2c4ddb 100644
--- a/fio.1
+++ b/fio.1
@@ -1448,6 +1448,12 @@ number, eg echoing 8 will ensure that the OS has 8 huge pages ready for
 use.
 .RE
 .TP
+.BI mem_keep \fR=\fPint "\fR,\fP iomem_keep" \fR=\fPbool
+When the I/O memory buffers used by fio are file-backed the default behaviour
+is to delete (unlink()) the file when it is no longer needed. That is
+problematic when we'd prefer to keep that file. Set this flag to indicate to
+you wish to keep the file after use.
+.TP
 .BI iomem_align \fR=\fPint "\fR,\fP mem_align" \fR=\fPint
 This indicates the memory alignment of the IO memory buffers. Note that the
 given alignment is applied to the first IO unit buffer, if using \fBiodepth\fR
diff --git a/memory.c b/memory.c
index 22a7f5dd..20252e70 100644
--- a/memory.c
+++ b/memory.c
@@ -169,7 +169,7 @@ static int alloc_mem_mmap(struct thread_data *td, size_t total_mem)
 		td->orig_buffer = NULL;
 		if (td->mmapfd != 1 && td->mmapfd != -1) {
 			close(td->mmapfd);
-			if (td->o.mmapfile)
+			if (td->o.mmapfile && !td->o.mem_keep)
 				unlink(td->o.mmapfile);
 		}
 
@@ -187,7 +187,8 @@ static void free_mem_mmap(struct thread_data *td, size_t total_mem)
 	if (td->o.mmapfile) {
 		if (td->mmapfd != -1)
 			close(td->mmapfd);
-		unlink(td->o.mmapfile);
+		if (!td->o.mem_keep)
+			unlink(td->o.mmapfile);
 		free(td->o.mmapfile);
 	}
 }
diff --git a/options.c b/options.c
index 5a2ab57c..ee097fe0 100644
--- a/options.c
+++ b/options.c
@@ -2640,6 +2640,18 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		  },
 	},
 	{
+		.name	= "mem_keep",
+		.alias	= "iomem_keep",
+		.lname	= "Keep I/O memory file if appropriate",
+		.type	= FIO_OPT_STR_SET,
+		.off1	= offsetof(struct thread_options, mem_keep),
+		.help	= "Keep IO memory buffer file if appropriate",
+		.parent	= "mem",
+		.hide	= 1,
+		.category = FIO_OPT_C_IO,
+		.group	= FIO_OPT_G_INVALID,
+	},
+	{
 		.name	= "iomem_align",
 		.alias	= "mem_align",
 		.lname	= "I/O memory alignment",
diff --git a/thread_options.h b/thread_options.h
index 72d86cfe..c883d042 100644
--- a/thread_options.h
+++ b/thread_options.h
@@ -185,6 +185,7 @@ struct thread_options {
 	unsigned long long zone_skip;
 	unsigned long long lockmem;
 	enum fio_memtype mem_type;
+	unsigned int mem_keep;
 	unsigned int mem_align;
 
 	unsigned int max_latency;
-- 
2.11.0


