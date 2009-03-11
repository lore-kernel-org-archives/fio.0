Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:57235 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbZCKJ55 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 11 Mar 2009 05:57:57 -0400
Date: Wed, 11 Mar 2009 10:57:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: I/O alignment
Message-ID: <20090311095754.GL11787@kernel.dk>
References: <499e38d2.fWWZqp8SkMl4HRX/%jens.axboe@oracle.com> <4C6CAE54C846144981BCE6F26B203FFA1CB3F68AE8@GVW1098EXB.americas.hpqcorp.net> <20090310195408.GJ11787@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310195408.GJ11787@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Jenkins, Lee" <Lee.Jenkins@hp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, Mar 10 2009, Jens Axboe wrote:
> On Tue, Mar 10 2009, Jenkins, Lee wrote:
> > Is there a way to control the alignment of I/O offsets? The HOWTO
> > shows bsrange= and bs_unaligned=, but these seem to be related to the
> > size of the I/O, not the offset.
> > 
> > In our lab testing it appears from blktrace dumps that I/Os are
> > boundary-aligned based on the size of the I/O. For example, in a test
> > of 64KB Random Reads all the I/O addresses were multiples of 64KB (128
> > sectors). This alignment has a profound impact on I/O performance for
> > certain disk array configurations. Ideally we'd like to be able to
> > control the alignment to match our customers' run-time environment.
> 
> That is correct, fio will use your minimum block size as the alignment
> block as well. This is needed for the random map and doing verifies, for
> instance. But I see your point, being able to specifically set your
> minimum alignment is indeed useful. It would have to be with the
> 'norandommap' option, at least that would be the easiest.
> 
> I'll add such an option for you tomorrow. Suggestions for option name
> would be appreciated, I'm not very good with coming up with good names
> :-)

This should work, I hope. It adds a blockalign/ba option (thanks Lee :-)
and will align random offsets to that boundary. You need to use
norandommap for this feature, fio will complain if you do not. So if you
use bs=64k and ba=4k for your test, you will get 4k alignment on offsets
with ios of 64k in size.

I have committed the patch, so you can also just update to the latest
version instead of applying this one manually.

diff --git a/HOWTO b/HOWTO
index 4e52e65..999f777 100644
--- a/HOWTO
+++ b/HOWTO
@@ -327,6 +327,14 @@ bs=int		The block size used for the io units. Defaults to 4k. Values
 		can do so by passing an empty read size - bs=,8k will set
 		8k for writes and leave the read default value.
 
+blockalign=int
+ba=int		At what boundary to align random IO offsets. Defaults to
+		the same as 'blocksize' the minimum blocksize given.
+		Minimum alignment is typically 512b for using direct IO,
+		though it usually depends on the hardware block size. This
+		option is mutually exclusive with using a random map for
+		files, so it will turn off that option.
+
 blocksize_range=irange
 bsrange=irange	Instead of giving a single block size, specify a range
 		and fio will mix the issued io block sizes. The issued
diff --git a/fio.h b/fio.h
index b6ffe60..a9e2e3b 100644
--- a/fio.h
+++ b/fio.h
@@ -429,6 +429,7 @@ struct thread_options {
 	unsigned long long start_offset;
 
 	unsigned int bs[2];
+	unsigned int ba[2];
 	unsigned int min_bs[2];
 	unsigned int max_bs[2];
 	struct bssplit *bssplit;
diff --git a/init.c b/init.c
index 4ae3baf..80d098d 100644
--- a/init.c
+++ b/init.c
@@ -273,6 +273,21 @@ static int fixup_options(struct thread_data *td)
 
 	o->rw_min_bs = min(o->min_bs[DDIR_READ], o->min_bs[DDIR_WRITE]);
 
+	/*
+	 * For random IO, allow blockalign offset other than min_bs.
+	 */
+	if (!o->ba[DDIR_READ] || !td_random(td))
+		o->ba[DDIR_READ] = o->min_bs[DDIR_READ];
+	if (!o->ba[DDIR_WRITE] || !td_random(td))
+		o->ba[DDIR_WRITE] = o->min_bs[DDIR_WRITE];
+
+	if ((o->ba[DDIR_READ] != o->min_bs[DDIR_READ] ||
+	    o->ba[DDIR_WRITE] != o->min_bs[DDIR_WRITE]) &&
+	    !td->o.norandommap) {
+		log_err("fio: Any use of blockalign= turns off randommap\n");
+		td->o.norandommap = 1;
+	}
+
 	if (!o->file_size_high)
 		o->file_size_high = o->file_size_low;
 
diff --git a/io_u.c b/io_u.c
index 27014c8..476658e 100644
--- a/io_u.c
+++ b/io_u.c
@@ -95,7 +95,7 @@ static unsigned long long last_block(struct thread_data *td, struct fio_file *f,
 	if (max_size > f->real_file_size)
 		max_size = f->real_file_size;
 
-	max_blocks = max_size / (unsigned long long) td->o.min_bs[ddir];
+	max_blocks = max_size / (unsigned long long) td->o.ba[ddir];
 	if (!max_blocks)
 		return 0;
 
@@ -212,7 +212,7 @@ static int get_next_offset(struct thread_data *td, struct io_u *io_u)
 			b = (f->last_pos - f->file_offset) / td->o.min_bs[ddir];
 	}
 
-	io_u->offset = b * td->o.min_bs[ddir];
+	io_u->offset = b * td->o.ba[ddir];
 	if (io_u->offset >= f->io_size) {
 		dprint(FD_IO, "get_next_offset: offset %llu >= io_size %llu\n",
 					io_u->offset, f->io_size);
diff --git a/options.c b/options.c
index 73815bb..9700110 100644
--- a/options.c
+++ b/options.c
@@ -793,6 +793,16 @@ static struct fio_option options[] = {
 		.parent = "rw",
 	},
 	{
+		.name	= "ba",
+		.alias	= "blockalign",
+		.type	= FIO_OPT_STR_VAL_INT,
+		.off1	= td_var_offset(ba[DDIR_READ]),
+		.off2	= td_var_offset(ba[DDIR_WRITE]),
+		.minval	= 1,
+		.help	= "IO block offset alignment",
+		.parent	= "rw",
+	},
+	{
 		.name	= "bsrange",
 		.alias	= "blocksize_range",
 		.type	= FIO_OPT_RANGE,

-- 
Jens Axboe

