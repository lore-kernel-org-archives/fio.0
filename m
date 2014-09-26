Return-Path: <axboe@kernel.dk>
Message-ID: <5425C0C7.8080303@kernel.dk>
Date: Fri, 26 Sep 2014 13:38:47 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: dedupe and replay
References: <CA+BkS8NvVNyj3KDy3UjtD2G0q-B3Ai7sdbqwRu_DafLQmKk37Q@mail.gmail.com> <5425B9B7.2080003@kernel.dk>
In-Reply-To: <5425B9B7.2080003@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------070402030900060101000007"
To: Alket Memushaj <amemushaj@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------070402030900060101000007
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 09/26/2014 01:08 PM, Jens Axboe wrote:
> On 09/26/2014 12:30 PM, Alket Memushaj wrote:
>> Hi,
>>
>> I am playing with the dedupe option and while it works well under
>> synthetic tests, it doesn't seem to work when replaying a trace.
>>
>> My test jobs are simple:
>>
>> fio --name=replay --ioengine=libaio --direct=1 --iodepth=32
>> --read_iolog=/path/to/trace --dedupe_percentage=80
> 
> That should work, as far as I can tell, since we do the buffer fill
> after the iolog retrieval has filled out an IO unit for us. Can you say
> more about what doesn't appear to work?
> 
>> I understand that block sizes would be variable during a trace replay,
>> but is it possible to specify a base block size and calculate dedupe
>> based on that for blocks that are multiples of the base size?
> 
> Ah, that might be the key element here. Yes, the dedupe part might not
> really work well for multiple write sizes. Nothing that inherently
> prevents that from working, just didn't add that bit yet. Will do that.

Does it work better with this patch?

-- 
Jens Axboe


--------------070402030900060101000007
Content-Type: text/x-patch;
 name="dedupe-multiple.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dedupe-multiple.patch"

diff --git a/io_u.c b/io_u.c
index eac871bfe9d9..db0695817b94 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1485,9 +1485,13 @@ struct io_u *get_io_u(struct thread_data *td)
 		f->last_pos = io_u->offset + io_u->buflen;
 
 		if (io_u->ddir == DDIR_WRITE) {
+			unsigned int min_write;
+
+			min_write = td->o.min_bs[DDIR_WRITE];
+
 			if (td->flags & TD_F_REFILL_BUFFERS) {
-				io_u_fill_buffer(td, io_u,
-					io_u->xfer_buflen, io_u->xfer_buflen);
+				io_u_fill_buffer(td, io_u, min_write,
+							io_u->xfer_buflen);
 			} else if ((td->flags & TD_F_SCRAMBLE_BUFFERS) &&
 				   !(td->flags & TD_F_COMPRESS))
 				do_scramble = 1;
@@ -1864,22 +1868,29 @@ void fill_io_buffer(struct thread_data *td, void *buf, unsigned int min_write,
 	else if (!td->o.zero_buffers) {
 		unsigned int perc = td->o.compress_percentage;
 		struct frand_state *rs;
+		unsigned int left = max_bs;
 
-		rs = get_buf_state(td);
+		do {
+			rs = get_buf_state(td);
 
-		if (perc) {
-			unsigned int seg = min_write;
+			min_write = min(min_write, left);
 
-			seg = min(min_write, td->o.compress_chunk);
-			if (!seg)
-				seg = min_write;
+			if (perc) {
+				unsigned int seg = min_write;
 
-			fill_random_buf_percentage(rs, buf, perc, seg,max_bs);
-			save_buf_state(td, rs);
-		} else {
-			fill_random_buf(rs, buf, max_bs);
+				seg = min(min_write, td->o.compress_chunk);
+				if (!seg)
+					seg = min_write;
+
+				fill_random_buf_percentage(rs, buf, perc, seg,
+								min_write);
+			} else
+				fill_random_buf(rs, buf, min_write);
+
+			buf += min_write;
+			left -= min_write;
 			save_buf_state(td, rs);
-		}
+		} while (left);
 	} else
 		memset(buf, 0, max_bs);
 }

--------------070402030900060101000007--

