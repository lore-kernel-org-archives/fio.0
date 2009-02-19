Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:8486 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZBSS2j (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 19 Feb 2009 13:28:39 -0500
Date: Thu, 19 Feb 2009 19:26:12 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Disabling verify when norandommap is given
Message-ID: <20090219182611.GG29783@kernel.dk>
References: <66dfd3fe0902181512o5a88da43waaf09834bd6d37ac@mail.gmail.com> <20090219074712.GD30821@kernel.dk> <66dfd3fe0902191010l64a2d915o973c0a3b486e0143@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0902191010l64a2d915o973c0a3b486e0143@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Thu, Feb 19 2009, Radha Ramachandran wrote:
> Yes, that makes sense for a randwrite operation.
> But is it acceptable to allow norandommap with verify for
> read/randomread only operations with no writes involved. The case Iam
> specifically interested in is doing sequential writes followed by
> sequential reads (with verify) and then randomaccess reads (with
> verify). For a small enough block size on a large enough drive the
> norandommap takes up too much memory.

The memory usage is indeed problematic, that is why the option exists.
I'd be very happy to slim that down...

What you suggest will work, but only for fixed size blocks. Once you
have varying block sizes, a given random minimum block offset may be
inside a verify block, not at the start of it.

So I guess the 'norandommap disables verify' can be relaxed to
'norandommap disables verify IFF non-fixed block sizes are used'. I'm
assuming that would work for you? Please try the below patch. If
succesful, I'll augment it with an updated HOWTO description.

diff --git a/init.c b/init.c
index 95c282a..001e5c4 100644
--- a/init.c
+++ b/init.c
@@ -206,6 +206,13 @@ static int setup_rate(struct thread_data *td)
 	return 0;
 }
 
+static int fixed_block_size(struct thread_options *o)
+{
+	return o->min_bs[DDIR_READ] == o->max_bs[DDIR_READ] &&
+		o->min_bs[DDIR_WRITE] == o->max_bs[DDIR_WRITE] &&
+		o->min_bs[DDIR_READ] == o->min_bs[DDIR_WRITE];
+}
+
 /*
  * Lazy way of fixing up options that depend on each other. We could also
  * define option callback handlers, but this is easier.
@@ -269,8 +276,10 @@ static int fixup_options(struct thread_data *td)
 	if (!o->file_size_high)
 		o->file_size_high = o->file_size_low;
 
-	if (o->norandommap && o->verify != VERIFY_NONE) {
-		log_err("fio: norandommap given, verify disabled\n");
+	if (o->norandommap && o->verify != VERIFY_NONE
+	    && !fixed_block_size(o))  {
+		log_err("fio: norandommap given for variable block sizes, "
+			"verify disabled\n");
 		o->verify = VERIFY_NONE;
 	}
 	if (o->bs_unaligned && (o->odirect || td->io_ops->flags & FIO_RAWIO))

-- 
Jens Axboe

