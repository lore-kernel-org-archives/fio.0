Return-Path: <rjones@redhat.com>
Date: Sat, 3 Aug 2019 16:32:06 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH v4] engines: Add Network Block Device (NBD) support using
 libnbd.
Message-ID: <20190803153206.GY3888@redhat.com>
References: <20190802153225.11480-1-rjones@redhat.com>
 <20190802153225.11480-2-rjones@redhat.com>
 <CALjAwxgdf_XNwquVDJtSTKRjD9kcXcdM9MoDCZUY2qh9bxwwNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjAwxgdf_XNwquVDJtSTKRjD9kcXcdM9MoDCZUY2qh9bxwwNg@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, eblake@redhat.com, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On Sat, Aug 03, 2019 at 04:10:07PM +0100, Sitsofe Wheeler wrote:
> On Sat, 3 Aug 2019 at 15:38, Richard W.M. Jones <rjones@redhat.com> wrote:
> > +               **nbd**
> > +                       Synchronous read and write a Network Block Device (NBD).
> 
> I wonder if the engine should be called nbdkit as that's what it uses
> under hood to talk NBD...

libnbd (nbdkit is a server).  libnbd is supposed to be "the" NBD
client library however.  I'm not sure what other NBD engines would be
useful here.

> > +  --enable-libnbd) libnbd="yes"
> > +  ;;
> 
> Why not enable by default if available and then do a probe to see if
> it can be enabled?

Yes, we can do this.  I disabled it out of an abundance of caution, so
that no one's build could be broken if I got it wrong.

> > +       .io_u_free              = nbd_io_u_free,
> > +
> > +       .open_file              = nbd_open_file,
> > +       .invalidate             = nbd_invalidate,
> 
> Do you have to register functions for things that you don't do
> anything (e.g. nbd_io_u_free)?

I think io_u_free is the only one which is an actual no-op (but it
balances the corresponding init function).  I'm not really sure of the
purpose of open_file and invalidate except that other engines also did
the same thing.

> > +offset=064m
> 
> I'd drop the leading 0.

This is a bug, I'll send a follow-up patch to fix it.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-builder quickly builds VMs from scratch
http://libguestfs.org/virt-builder.1.html

