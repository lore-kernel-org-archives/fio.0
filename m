Return-Path: <rjones@redhat.com>
Date: Thu, 25 Apr 2019 21:22:14 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: Is the libiscsi engine patch applied correctly?
Message-ID: <20190425202214.GL3926@redhat.com>
References: <20190425155203.GA11294@redhat.com>
 <035ceaed-70a7-da29-8677-f1669f7f09db@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <035ceaed-70a7-da29-8677-f1669f7f09db@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Thu, Apr 25, 2019 at 10:10:40AM -0600, Jens Axboe wrote:
> On 4/25/19 9:52 AM, Richard W.M. Jones wrote:
> > It seems like these two lines might be in the wrong order? (and the
> > same thing later in the file too)
> > 
> > https://github.com/axboe/fio/blob/afc22c98609ee80a99fbed24231181bdab2bc659/optgroup.h#L65-L66
> 
> They are, that's a bug. Thanks for letting me know, I've fixed it up.

Thanks.  I think also these lines later in the same file -- although
not technically a bug -- should also be swapped around:

	    FIO_OPT_G_INVALID	 = (1ULL << __FIO_OPT_G_NR),
	    FIO_OPT_G_ISCSI         = (1ULL << __FIO_OPT_G_ISCSI),

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/

