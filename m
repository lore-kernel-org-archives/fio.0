Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:39345 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760354Ab3ECKI6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 3 May 2013 06:08:58 -0400
Date: Fri, 3 May 2013 12:08:39 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: random read generates zero filled file
Message-ID: <20130503100839.GI7800@kernel.dk>
References: <82C5A0D6-2960-41B7-89B6-1D8C72D011C0@ulb.ac.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82C5A0D6-2960-41B7-89B6-1D8C72D011C0@ulb.ac.be>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Michel Jansens <michel.jansens@ulb.ac.be>
Cc: fio@vger.kernel.org

On Fri, May 03 2013, Michel Jansens wrote:
> Hi,
> 
> I'm trying out FIO, and rand a random read job with a 12GB file.  It
> seems that the "Laying out IO file(s) " process generates a
> zero-filled file. This means that when compression is activated (on
> ZFS), no reads actually happens.
> 
> I tried adding a "buffer_compress_percentage=10" section to tell
> generated data should compress from only "10%" but this seems to apply
> only to actual benchmark job, not the 'laying out file's.
> 
> Am I missing something?

No, it currently just fills zeroes. It's trivial to make it honor the
usual buffer fill logic, though. With the below patch, it'll do what fio
otherwise would have done to IO buffers during the benchmark run.


diff --git a/filesetup.c b/filesetup.c
index 9f186fb..1b1c7d3 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -127,7 +127,6 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 	}
 
 	b = malloc(td->o.max_bs[DDIR_WRITE]);
-	memset(b, 0, td->o.max_bs[DDIR_WRITE]);
 
 	left = f->real_file_size;
 	while (left && !td->terminate) {
@@ -135,6 +134,8 @@ static int extend_file(struct thread_data *td, struct fio_file *f)
 		if (bs > left)
 			bs = left;
 
+		fill_io_buffer(td, b, bs, td->o.max_bs[DDIR_WRITE]);
+
 		r = write(f->fd, b, bs);
 
 		if (r > 0) {
diff --git a/io_u.c b/io_u.c
index d03049e..a9c67ce 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1602,14 +1602,9 @@ void io_u_queued(struct thread_data *td, struct io_u *io_u)
 	}
 }
 
-/*
- * "randomly" fill the buffer contents
- */
-void io_u_fill_buffer(struct thread_data *td, struct io_u *io_u,
-		      unsigned int min_write, unsigned int max_bs)
+void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
+		    unsigned int max_bs)
 {
-	io_u->buf_filled_len = 0;
-
 	if (!td->o.zero_buffers) {
 		unsigned int perc = td->o.compress_percentage;
 
@@ -1617,10 +1612,20 @@ void io_u_fill_buffer(struct thread_data *td, struct io_u *io_u,
 			unsigned int seg = min_write;
 
 			seg = min(min_write, td->o.compress_chunk);
-			fill_random_buf_percentage(&td->buf_state, io_u->buf,
+			fill_random_buf_percentage(&td->buf_state, buf,
 						perc, seg, max_bs);
 		} else
-			fill_random_buf(&td->buf_state, io_u->buf, max_bs);
+			fill_random_buf(&td->buf_state, buf, max_bs);
 	} else
-		memset(io_u->buf, 0, max_bs);
+		memset(buf, 0, max_bs);
+}
+
+/*
+ * "randomly" fill the buffer contents
+ */
+void io_u_fill_buffer(struct thread_data *td, struct io_u *io_u,
+		      unsigned int min_write, unsigned int max_bs)
+{
+	io_u->buf_filled_len = 0;
+	fill_io_buffer(td, io_u->buf, min_write, max_bs);
 }
diff --git a/ioengine.h b/ioengine.h
index d52b2b9..362ab3e 100644
--- a/ioengine.h
+++ b/ioengine.h
@@ -198,6 +198,7 @@ extern int __must_check io_u_queued_complete(struct thread_data *, int, uint64_t
 extern void io_u_queued(struct thread_data *, struct io_u *);
 extern void io_u_log_error(struct thread_data *, struct io_u *);
 extern void io_u_mark_depth(struct thread_data *, unsigned int);
+extern void fill_io_buffer(struct thread_data *, void *, unsigned int, unsigned int);
 extern void io_u_fill_buffer(struct thread_data *td, struct io_u *, unsigned int, unsigned int);
 void io_u_mark_complete(struct thread_data *, unsigned int);
 void io_u_mark_submit(struct thread_data *, unsigned int);

-- 
Jens Axboe

