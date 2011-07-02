Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:58856 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1GBBMK (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 1 Jul 2011 21:12:10 -0400
Received: from hpaq12.eem.corp.google.com (hpaq12.eem.corp.google.com [172.25.149.12])
	by smtp-out.google.com with ESMTP id p621C8so030343
	for <fio@vger.kernel.org>; Fri, 1 Jul 2011 18:12:08 -0700
Received: from ywf9 (ywf9.prod.google.com [10.192.6.9])
	by hpaq12.eem.corp.google.com with ESMTP id p621C6vh028877
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Fri, 1 Jul 2011 18:12:07 -0700
Received: by ywf9 with SMTP id 9so1777471ywf.8
        for <fio@vger.kernel.org>; Fri, 01 Jul 2011 18:12:06 -0700 (PDT)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Fri, 1 Jul 2011 18:11:46 -0700
Message-ID: <CAAUT-yO47O=7fqVybxTzyra0RL0i_+q5vtyTj8KSd5RPvNZZ1Q@mail.gmail.com>
Subject: IO engine flags: FIO_RAWIO vs FIO_MEMALIGN
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

What is the intended difference between these two flags?  The former
seems to carry some specific semantic meaning while the latter seems
like it is merely a statement of requirement.  However, within the
code they seem to be used synonymously, to the point that if an IO
engine uses FIO_RAWIO and not FIO_MEMALIGN it would potentially crash.

From memory.c:196
        if (td->o.odirect || td->o.mem_align ||
            (td->io_ops->flags & FIO_MEMALIGN)) {
                total_mem += page_mask;
                if (td->o.mem_align && td->o.mem_align > page_size)
                        total_mem += td->o.mem_align - page_size;
        }

From fio.c:830
        if (td->o.odirect || td->o.mem_align ||
            (td->io_ops->flags & FIO_RAWIO))
                p = PAGE_ALIGN(td->orig_buffer) + td->o.mem_align;

These two pieces of code seem like they are a pair that should always
execute together, yet they have slightly different conditions.  The
result seems like if FIO_RAWIO is used without FIO_MEMALIGN, it will
try to page align the buffer (Which of course involves just padding it
to the next alignment) without the actual memory available to do so,
resulting in the IO buffer overwriting other parts of the heap.

If this is changed one way or the other, however, it would result in
an unused flag.  The condition in memory.c is the only place
FIO_MEMALIGN appears, and FIO_RAWIO only makes two other
appearances...

From init.c:320
        if (o->bs_unaligned && (o->odirect || td->io_ops->flags & FIO_RAWIO))
                log_err("fio: bs_unaligned may not work with raw io\n");
From init.c:585
        if (td->o.odirect)
                td->io_ops->flags |= FIO_RAWIO;

The former doesn't actually do anything but print a message and run
anyway (And should probably use the same form of the flag as the other
two anyway), and the latter is redundant since the same check for
FIO_RAWIO/FIO_MEMALIGN also checks for o.direct.

- Steven
