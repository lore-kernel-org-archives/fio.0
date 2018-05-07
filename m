Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbeEGOVp (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 May 2018 10:21:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: Can buffer passed to io_prep_pwrite/io_submit be reused before io_getevents is called?
References: <50E2CC01-D24A-49D0-9FCD-047AE98E1F51@cisco.com>
Date: Mon, 07 May 2018 10:21:44 -0400
In-Reply-To: <50E2CC01-D24A-49D0-9FCD-047AE98E1F51@cisco.com> (Scott Forman's
        message of "Fri, 4 May 2018 17:11:32 +0000")
Message-ID: <x49603zo8av.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Scott Forman (scforman)" <scforman@cisco.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi, Scott,

I'll note that this question is probably better suited to
linux-aio@vger.kernel.org.  Response below.

"Scott Forman (scforman)" <scforman@cisco.com> writes:

> Hi,
>
> I have an application where I will call io_prep_pwrite and io_submit
> in a loop, each time passing the same buffer to io_prep_pwrite, but
> with different contents.
>
> Then after a certain number of  loops, I will call io_getevents before
> going on to the next file.
>
> Is this safe to do, or is there a race condition between the buffer
> being written to file and being reused for the next call to
> io_prep_pwrite?
>
> Below is some code to illustrate my question (absent any error
> handling).
>
> Thanks for any input you can provide.
>
> Scott
>
> int main() {
> 	struct iocb iocb;
> 	struct iocb * iocbs[1];
> 	iocbs[0] = &iocb;
> 	
> 	int fd = open("/tmp/test", O_WRONLY | O_CREAT);
>
> 	io_context_t ctx;
> 	memset(&ctx, 0, sizeof(ctx));
> 	io_setup(10, &ctx);
>
> 	char msg [128];
>           int loopCnt = 0;
> 	int fileOffset = 0;
> 	
>       	for (; loopCnt < 10; ++loopCnt) {
> 		int len = snprintf(msg, sizeof(msg), "message number %d\n", loopCnt);
> 		
> 		io_prep_pwrite(&iocb, fd, (void *)msg, len, fileOffset);
> 		fileOffset += len;
> 			
> 		io_submit(ctx, 1, iocbs);
> 	}
>
> 	struct io_event events[10];
> 	io_getevents(ctx, 10, 10, events, NULL);
> 	close(fd);
> 	io_destroy(ctx);
>
> 	return 0;
> }

What you did will work today, but probably only by accident (on your
part).  Linux native asynchronous I/O is only asynchronous when the file
is opened with O_DIRECT.  In the code above, when the io_submit call
returns, the data transfer is complete.

If you had used direct I/O, you would instead be modifying the contents
of a buffer that is queued for I/O (or in the middle of a DMA).  That
will result in data corruption.

Cheers,
Jeff
