Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728919AbfDSTJa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Apr 2019 15:09:30 -0400
Date: Fri, 19 Apr 2019 10:40:34 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: [PATCH fio] engines: Add Network Block Device (NBD) support.
Message-ID: <20190419094034.GB3926@redhat.com>
References: <20190418140938.15527-1-rjones@redhat.com>
 <CALjAwxgWho3m5V+xgSH0U8uEe=z9icHo8VXT4U3V3njOvCuT7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjAwxgWho3m5V+xgSH0U8uEe=z9icHo8VXT4U3V3njOvCuT7Q@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>, eblake@redhat.com, nbd@other.debian.org

On Fri, Apr 19, 2019 at 10:27:49AM +0100, Sitsofe Wheeler wrote:
> On Thu, 18 Apr 2019 at 15:10, Richard W.M. Jones <rjones@redhat.com> wrote:
> > If there are multiple jobs (files?) should these be striped over the
> > block device?
> 
> It depends on how you define the job. If you were to just copy the job
> and give it a new name it would likely just overlap the first job
> (because it's just going to do the same thing at the same time). You
> would need to use something like numjobs
> (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-numjobs
> ) offset_increment
> (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset-increment
> ) and a workload that skipped (e.g. rw=write:12k -
> https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite
> ) to achieve striping.

I meant should the NBD engine stripe the jobs.  Something like: job 0
gets to use the first <size> bytes of the NBD device, job 1 gets to us
the next <size> bytes, etc.  (Or actually striped/interleaved using a
smaller block size).  In other words it would be something hidden
inside the NBD engine and not "visible" to fio.

Thanks for the rest of the email - very helpful.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/

