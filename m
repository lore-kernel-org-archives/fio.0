Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42056 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbfDSSeu (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 19 Apr 2019 14:34:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id g3so7848575wrx.9
        for <fio@vger.kernel.org>; Fri, 19 Apr 2019 11:34:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190418140938.15527-1-rjones@redhat.com>
In-Reply-To: <20190418140938.15527-1-rjones@redhat.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Fri, 19 Apr 2019 10:27:49 +0100
Message-ID: <CALjAwxgWho3m5V+xgSH0U8uEe=z9icHo8VXT4U3V3njOvCuT7Q@mail.gmail.com>
Subject: Re: [PATCH fio] engines: Add Network Block Device (NBD) support.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Cc: fio <fio@vger.kernel.org>, eblake@redhat.com, nbd@other.debian.org

Hello Richard!

(Thanks for all your NBD work over the years)

On Thu, 18 Apr 2019 at 15:10, Richard W.M. Jones <rjones@redhat.com> wrote:

<snip>

> NBD servers (generally, not always) expose a single block device per
> server.  You can usually make multiple connections to the server, and
> all connections will see a single view of the device.  There is of
> course no concept of files.
>
> I'm having some problems understanding the execution model of fio: in
> what order do engine methods get called?  how do threads correspond to
> files?  are "jobs" the same as "files"?

The order of method calls for a synchronous engine (IF they are
defined) is roughly:

->load (engines are all loaded together)

->file_size
->init
->open

(per I/O)
->prep
->queue

->close
->cleanup
->free
<-close

It's possible to define more functions than this though.

A thread may have one or more files associated with it depending on
what the engine can cope with and what the user requested (see
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-filename
). A "job" is the definition of an fio workload and via filename it
may define multiple files to work with. A filename may be auto
generated but this may not make sense with a diskless ioengine such as
the one you're writing.

> Nevertheless I think I have mapped a single job to the NBD block
> device.  You can test it using nbdkit plus a ramdisk like this:
>
>   $ rm /tmp/socket
>   $ nbdkit -U /tmp/socket memory size=1G --run './fio examples/nbd.fio'
>
> If there are multiple jobs (files?) should these be striped over the
> block device?

It depends on how you define the job. If you were to just copy the job
and give it a new name it would likely just overlap the first job
(because it's just going to do the same thing at the same time). You
would need to use something like numjobs
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-numjobs
) offset_increment
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset-increment
) and a workload that skipped (e.g. rw=write:12k -
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-readwrite
) to achieve striping.

>
> For some reason fio doesn't recognize the new --sockname parameter:
>
>   $ ./fio examples/nbd.fio --sockname=foo
>   ./fio: unrecognized option '--sockname=foo'
>   ./fio: unrecognized option '--sockname=foo'

We'd have to debug this by looking at the code to see that the new
option was registered correctly.

> If this was fixed then you could use an implicit socket:
>
>   $ nbdkit -U - memory size=1G \
>            --run './fio examples/nbd.fio --sockname=$unixsocket'
>
> The .queue method in this engine is synchronous.  It's possible for
> multiple requests to be issued asynchronously on a single TCP socket,
> but I don't know if it is worth doing this.
>
> Although I said above that all connections to an NBD server see the
> "same" view of the device, the view is not guaranteed to be consistent
> *unless* the server returns the NBD_FLAG_CAN_MULTI_CONN export flag.
> We do not check this currently (mainly because qemu-nbd does not set it).
>
> Another problem is that we don't read the export size from the NBD
> server until it's "too late" to use it to determine the file size.
> Therefore users must take care to set a file size which is smaller
> than the NBD export, although this isn't much of a problem in
> practice.  I notice that the RBD engine works around this by
> connecting to their server early (during .setup).

Yeah - I think I had to do something similar in my never submitted
libiscsi engine. I think there I stash some information whenever the
file is opened and then make use of that information in getsize
(https://github.com/sitsofe/fio/blob/libiscsi/engines/libiscsi.c#L869
).

--
Sitsofe | http://sucs.org/~sits/

