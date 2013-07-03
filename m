Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:60159 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab3GCHIh (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 3 Jul 2013 03:08:37 -0400
Date: Wed, 3 Jul 2013 09:08:34 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Prevention of full device?
Message-ID: <20130703070834.GA32428@kernel.dk>
References: <27943043.31081549.1372778944376.JavaMail.root@framestore.com>
 <335085150.31083401.1372779274187.JavaMail.root@framestore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <335085150.31083401.1372779274187.JavaMail.root@framestore.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: James Vanns <james.vanns@framestore.com>
Cc: fio@vger.kernel.org

On Tue, Jul 02 2013, James Vanns wrote:
> Hi. In attempting to get a single job to create files before allowing further jobs to perform I/O on them, I cannot
> see how to restrict the sum total of all the files on the device. I wish to create n files ranging in size from i-j
> with a cap of m in total (so the sum of n does not exceed m). For example;
> 
> [file-generator]
> numjobs=1
> create_only=1
> create_on_open=0
> time_based=0
> fill_fs=0
> fill_device=0
> filesize=4k-20m
> size=512m
> nrfiles=256
> fallocate=posix
> fadvise_hint=1
> filename_format=\$filenum.dat
> directory=/tmp/fio
> 
> I'd expect the above to create 256 files ranging from 4k to 20m and a 'du -sh' on /tmp/fio to result in
> 512m. However, it always seems to fill the device! How can I stop this?

It might be a little confusing, but it's actually documented behaviour.
If you set filesize and nrfiles, that dictates the workload size and not
the size= setting. So with the above, you could expect anywhere from 4k
* 256 to 20m * 256 of bytes used. For a normal random distribution of
sizes, you should see around ~2.5GB of data used.

-- 
Jens Axboe

