Return-Path: <kusumi.tomohiro@gmail.com>
Return-Path: <kusumi.tomohiro@gmail.com>
From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/8] client: don't use void* for pointer arithmetic (gcc)
Date: Sat, 24 Jun 2017 01:07:59 +0300
Message-Id: <20170623220801.38178-7-tkusumi@tuxera.com>
In-Reply-To: <20170623220801.38178-1-tkusumi@tuxera.com>
References: <20170623220801.38178-1-tkusumi@tuxera.com>
To: axboe@kernel.dk, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

I think gcc extension should be avoided when it can be done by
just changing a pointer type.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 client.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/client.c b/client.c
index 7a986aa..960c795 100644
--- a/client.c
+++ b/client.c
@@ -1452,7 +1452,7 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 	z_stream stream;
 	uint32_t nr_samples;
 	size_t total;
-	void *p;
+	char *p;
 
 	stream.zalloc = Z_NULL;
 	stream.zfree = Z_NULL;
@@ -1478,10 +1478,10 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 
 	memcpy(ret, pdu, sizeof(*pdu));
 
-	p = (void *) ret + sizeof(*pdu);
+	p = (char *) ret + sizeof(*pdu);
 
 	stream.avail_in = cmd->pdu_len - sizeof(*pdu);
-	stream.next_in = (void *) pdu + sizeof(*pdu);
+	stream.next_in = (void *)((char *) pdu + sizeof(*pdu));
 	while (stream.avail_in) {
 		unsigned int this_chunk = 65536;
 		unsigned int this_len;
@@ -1491,7 +1491,7 @@ static struct cmd_iolog_pdu *convert_iolog_gz(struct fio_net_cmd *cmd,
 			this_chunk = total;
 
 		stream.avail_out = this_chunk;
-		stream.next_out = p;
+		stream.next_out = (void *)p;
 		err = inflate(&stream, Z_NO_FLUSH);
 		/* may be Z_OK, or Z_STREAM_END */
 		if (err < 0) {
@@ -1566,7 +1566,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 
 		s = __get_sample(samples, ret->log_offset, i);
 		if (ret->log_type == IO_LOG_TYPE_HIST)
-			s = (struct io_sample *)((void *)s + sizeof(struct io_u_plat_entry) * i);
+			s = (struct io_sample *)((char *)s + sizeof(struct io_u_plat_entry) * i);
 
 		s->time		= le64_to_cpu(s->time);
 		s->data.val	= le64_to_cpu(s->data.val);
@@ -1580,7 +1580,7 @@ static struct cmd_iolog_pdu *convert_iolog(struct fio_net_cmd *cmd,
 		}
 
 		if (ret->log_type == IO_LOG_TYPE_HIST) {
-			s->data.plat_entry = (struct io_u_plat_entry *)(((void *)s) + sizeof(*s));
+			s->data.plat_entry = (struct io_u_plat_entry *)(((char *)s) + sizeof(*s));
 			s->data.plat_entry->list.next = NULL;
 			s->data.plat_entry->list.prev = NULL;
 		}
-- 
2.9.4


