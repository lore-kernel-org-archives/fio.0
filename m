Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54574 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbfDSUND (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Apr 2019 16:13:03 -0400
Received: by mail-wm1-f68.google.com with SMTP id c1so7250588wml.4
        for <fio@vger.kernel.org>; Fri, 19 Apr 2019 13:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190418140938.15527-1-rjones@redhat.com> <CALjAwxgWho3m5V+xgSH0U8uEe=z9icHo8VXT4U3V3njOvCuT7Q@mail.gmail.com>
 <20190419094034.GB3926@redhat.com>
In-Reply-To: <20190419094034.GB3926@redhat.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 19 Apr 2019 10:51:17 +0100
Message-ID: <CALjAwxi97mf3QSra55DYQGX9brWUn1eYL1231upiesD+-byO1w@mail.gmail.com>
Subject: Re: [PATCH fio] engines: Add Network Block Device (NBD) support.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: fio <fio@vger.kernel.org>, eblake@redhat.com, nbd@other.debian.org

On Fri, 19 Apr 2019 at 10:40, Richard W.M. Jones <rjones@redhat.com> wrote:
>
> On Fri, Apr 19, 2019 at 10:27:49AM +0100, Sitsofe Wheeler wrote:
> > On Thu, 18 Apr 2019 at 15:10, Richard W.M. Jones <rjones@redhat.com> wrote:
> > > If there are multiple jobs (files?) should these be striped over the
> > > block device?
> >
> > It depends on how you define the job. If you were to just copy the job
> > and give it a new name it would likely just overlap the first job
> > (because it's just going to do the same thing at the same time). You
> > would need to use something like numjobs
> > (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-numjobs
> > ) offset_increment
> > (https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset-increment
> > ) and a workload that skipped (e.g. rw=write:12k -
> > https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite
> > ) to achieve striping.
>
> I meant should the NBD engine stripe the jobs.  Something like: job 0
> gets to use the first <size> bytes of the NBD device, job 1 gets to us
> the next <size> bytes, etc.  (Or actually striped/interleaved using a
> smaller block size).  In other words it would be something hidden
> inside the NBD engine and not "visible" to fio.

I would leave this to the fio job definition - someone can always
build the filename and the job file programmatically...

-- 
Sitsofe | http://sucs.org/~sits/

