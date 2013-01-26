Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:37934 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3AZQ23 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 26 Jan 2013 11:28:29 -0500
Date: Sat, 26 Jan 2013 09:28:19 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Why does 'direct' influence 'fsync'?
Message-ID: <20130126162818.GF15635@kernel.dk>
References: <20130125114236.GA26765@stefanha-thinkpad.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125114236.GA26765@stefanha-thinkpad.redhat.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: fio@vger.kernel.org, Asias He <asias@redhat.com>

On Fri, Jan 25 2013, Stefan Hajnoczi wrote:
> Is there a way to flush the disk write cache when O_DIRECT is in use?
> 
> It seems that direct=1 causes the fsync setting to be ignored.  Asias
> writes:
> 
> > The O_DIRECT do affect the flush behaviour. e.g
> > 
> > guest$ fio --fsync=100 --direct=1
> > No virtio_blk_handle_flush is observed on host side every 100 IOs
> > 
> > guest$ fio --fsync=100 --direct=0
> > virtio_blk_handle_flush is observed on host side every 100 IOs
> 
> Am I missing a reason for this behavior?  To me it seems weird since you
> could already use --fsync=0 --direct=1 if you want to guarantee that
> fsync is not called.  I don't see a need to override the fsync setting.

You are right, fio should not be double guessing options like that. If
you ask for fsync, you should get fsync.

Does the below work for you?

diff --git a/fio.h b/fio.h
index 3a26335..9e20299 100644
--- a/fio.h
+++ b/fio.h
@@ -655,8 +655,6 @@ static inline int should_fsync(struct thread_data *td)
 {
 	if (td->last_was_sync)
 		return 0;
-	if (td->o.odirect)
-		return 0;
 	if (td_write(td) || td_rw(td) || td->o.override_sync)
 		return 1;
 

-- 
Jens Axboe

