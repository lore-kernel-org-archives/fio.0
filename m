Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbbCRMAE (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 18 Mar 2015 08:00:04 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1YYCdo-00029B-4o
	for fio@vger.kernel.org; Wed, 18 Mar 2015 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20150318120002.BFCFF4016A@lyth.info>
Date: Wed, 18 Mar 2015 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 95e564523d502e5a682ae7f6ee793ca4c9ca76ca:

  rate: remove redundant code in rate_ddir() (2015-03-12 10:05:25 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 7d1bb70f3d85d041b4b7dd926e98054fea980bdc:

  Scramble IO buffers unless explicitly told not (2015-03-17 18:11:07 -0600)

----------------------------------------------------------------
Jens Axboe (3):
      smalloc: don't crash on being passed a bad pointer
      io_u: fix refill, should be random content
      Scramble IO buffers unless explicitly told not

Zev Weiss (1):
      init: fix exit status with bogus arguments

 init.c    |    3 +++
 io_u.c    |    7 +++++--
 smalloc.c |    8 ++++++--
 3 files changed, 14 insertions(+), 4 deletions(-)

---

Diff of recent changes:

diff --git a/init.c b/init.c
index 7aedf2b..95e26b8 100644
--- a/init.c
+++ b/init.c
@@ -2135,6 +2135,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 						td = NULL;
 					}
 					do_exit++;
+					exit_val = 1;
 					break;
 				}
 				fio_options_set_ioengine_opts(l_opts, td);
@@ -2153,6 +2154,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 					td = NULL;
 				}
 				do_exit++;
+				exit_val = 1;
 			}
 
 			if (!ret && !strcmp(opt, "ioengine")) {
@@ -2161,6 +2163,7 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 					put_job(td);
 					td = NULL;
 					do_exit++;
+					exit_val = 1;
 					break;
 				}
 				fio_options_set_ioengine_opts(l_opts, td);
diff --git a/io_u.c b/io_u.c
index 6567e10..a45dd40 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1484,7 +1484,8 @@ struct io_u *get_io_u(struct thread_data *td)
 				io_u_fill_buffer(td, io_u,
 					td->o.min_bs[DDIR_WRITE],
 					io_u->xfer_buflen);
-			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
+			}
+			if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
 				   !(td->flags & TD_F_COMPRESS))
 				do_scramble = 1;
 			if (td->flags & TD_F_VER_NONE) {
@@ -1895,8 +1896,10 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 		} while (left);
 	} else if (o->buffer_pattern_bytes)
 		fill_buffer_pattern(td, buf, max_bs);
-	else
+	else if (o->zero_buffers)
 		memset(buf, 0, max_bs);
+	else
+		fill_random_buf(get_buf_state(td), buf, max_bs);
 }
 
 /*
diff --git a/smalloc.c b/smalloc.c
index b460d65..447d5c5 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -363,8 +363,12 @@ void sfree(void *ptr)
 
 	global_read_unlock();
 
-	assert(pool);
-	sfree_pool(pool, ptr);
+	if (pool) {
+		sfree_pool(pool, ptr);
+		return;
+	}
+
+	log_err("smalloc: ptr %p not from smalloc pool\n", ptr);
 }
 
 static void *__smalloc_pool(struct pool *pool, size_t size)
