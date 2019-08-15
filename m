Return-Path: <rjones@redhat.com>
Date: Thu, 15 Aug 2019 17:57:35 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH fio] nbd: Update for libnbd 0.9.8.
Message-ID: <20190815165735.GI3888@redhat.com>
References: <20190815153040.4511-1-rjones@redhat.com>
 <3df9429c-caf0-6913-5fdf-a5aae85b9765@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3df9429c-caf0-6913-5fdf-a5aae85b9765@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, eblake@redhat.com
List-ID: <fio@vger.kernel.org>

On Thu, Aug 15, 2019 at 10:42:17AM -0600, Jens Axboe wrote:
> On 8/15/19 9:30 AM, Richard W.M. Jones wrote:
> > As the libnbd API isn't permanently stable until we reach the 1.0
> > release (expected soon), some code changes are needed to cope with API
> > changes between 0.9.6 and 0.9.8.  In this case we made changes to
> > completion handlers after feedback from reviewers.  This fix for fio
> > incorporates all the changes needed and bumps the minimum version to
> > libnbd >= 0.9.8.
> 
> Applied, thanks.

Thanks - we're really hoping this will be the last time (forever)
that the API changes.  Fingers crossed ...

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
libguestfs lets you edit virtual machines.  Supports shell scripting,
bindings from many languages.  http://libguestfs.org

