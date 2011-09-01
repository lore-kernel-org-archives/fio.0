Return-Path: <fio-owner@vger.kernel.org>
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:42218
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab1IAQGs (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 1 Sep 2011 12:06:48 -0400
Message-ID: <4E5FAD90.80405@kernel.dk>
Date: Thu, 01 Sep 2011 10:06:40 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio file test patterns
References: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com> <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com> <4E5E91D9.4000702@fusionio.com> <CAOYTo+3JyNsxMf+UO5C3N=rrtkGR999XM9Guo5-0TXFqSuUr+Q@mail.gmail.com> <4E5EA5DF.5040609@fusionio.com> <4E5EA9D0.10109@kernel.dk> <CAOYTo+2pBwxmX-nhf6MP=Szvm3EoEFjGWapqbtC5JVSQskS4hQ@mail.gmail.com>
In-Reply-To: <CAOYTo+2pBwxmX-nhf6MP=Szvm3EoEFjGWapqbtC5JVSQskS4hQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Brian Fallik <bfallik@bamboom.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-09-01 08:18, Brian Fallik wrote:
> Perhaps I should describe what I'm seeing.  I have two terminals open.
>  In one, I launch:
>   $ watch "ls -l foo* | head -n 20"
> In the other terminal I kick off fio.  fio first spits out the "Laying
> out" messages, one per job.  Immediately the full 4MB files appear in
> the directory listing.  *Then* fio starts writing to the files, as
> indicated by the fio output.  The size of each file never changes
> during the test.
> 
> I wasn't expecting the full 4Mb files to be created before the
> sequential writes.  I expected to not see any files initially, and
> then a file for each job growing at a rate of 200Kbs throughout the
> test until reaching the 4MB limit.
> 
> Perhaps I'm just configuring fio incorrectly?

That you see them there does not mean they are actually written. Fio
will use truncate to setup the files, but only actually fill them with
data if you are going to be reading them (or requested overwrite).

BTW, please don't top-post. Reply beneath the original text, like a
normal flow of conversation.

-- 
Jens Axboe

