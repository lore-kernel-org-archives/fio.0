Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36940 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166Ab3E0IWP (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 May 2013 04:22:15 -0400
Date: Mon, 27 May 2013 10:21:47 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Question on --buffer_compress_percentage
Message-ID: <20130527082147.GC29680@kernel.dk>
References: <CAF+0mvnU7GMsKrbArcECaD5Z0YtLxA6GtghQjOJtOxZHb=cxjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+0mvnU7GMsKrbArcECaD5Z0YtLxA6GtghQjOJtOxZHb=cxjQ@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: fio@vger.kernel.org

On Fri, May 24 2013, Matthew Eaton wrote:
> Hello fio group,
> 
> Can anyone tell me if --buffer_compress_percentage fills the buffer
> with random data and reuses that data or if it refills with random
> data for each submit?  If you want the latter behavior should you
> combine with --refill_buffers?

That is actually explained in the man page / HOWTO:

buffer_compress_percentage=int  If this is set, then fio will attempt to
                provide IO buffer content (on WRITEs) that compress to
                the specified level. Fio does this by providing a mix of
                random data and zeroes. Note that this is per block size
                unit, for file/disk wide compression level that matches
                this setting, you'll also want to set refill_buffers.

So the answer to your question is yes. Fio will reuse IO buffers, unless
--refill_buffers is set. If you do not set refill_buffers with
buffer_compress_percentage, then you will have identically compressible
blocks written. And that would only give you the per-block compression
ratio specified, on a broader scale it would compress more.

-- 
Jens Axboe

