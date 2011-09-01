Return-Path: <bfallik@bamboom.com>
MIME-Version: 1.0
In-Reply-To: <4E5EA9D0.10109@kernel.dk>
References: <CAOYTo+2Xh=JuLi1rx_LGjfEHheRhp2RE=tT-RZ8arT7ULYziTA@mail.gmail.com>
 <x49ippd5t7y.fsf@segfault.boston.devel.redhat.com> <4E5E91D9.4000702@fusionio.com>
 <CAOYTo+3JyNsxMf+UO5C3N=rrtkGR999XM9Guo5-0TXFqSuUr+Q@mail.gmail.com>
 <4E5EA5DF.5040609@fusionio.com> <4E5EA9D0.10109@kernel.dk>
From: Brian Fallik <bfallik@bamboom.com>
Date: Thu, 1 Sep 2011 10:18:08 -0400
Message-ID: <CAOYTo+2pBwxmX-nhf6MP=Szvm3EoEFjGWapqbtC5JVSQskS4hQ@mail.gmail.com>
Subject: Re: fio file test patterns
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Perhaps I should describe what I'm seeing.  I have two terminals open.
 In one, I launch:
  $ watch "ls -l foo* | head -n 20"
In the other terminal I kick off fio.  fio first spits out the "Laying
out" messages, one per job.  Immediately the full 4MB files appear in
the directory listing.  *Then* fio starts writing to the files, as
indicated by the fio output.  The size of each file never changes
during the test.

I wasn't expecting the full 4Mb files to be created before the
sequential writes.  I expected to not see any files initially, and
then a file for each job growing at a rate of 200Kbs throughout the
test until reaching the 4MB limit.

Perhaps I'm just configuring fio incorrectly?

brian


On Wed, Aug 31, 2011 at 5:38 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-08-31 15:21, Jens Axboe wrote:
>>> I also have another (maybe related?) question. =A0Apologies if this
>>> belongs in a separate thread, but are there any notes explaining why
>>> fio lays out the files before starting sequential writes? =A0The
>>> workload I was hoping to simulate is sustained, sequential writes to
>>> disk. =A0I'm trying to answer the question "How many simultaneous
>>> 200kBps writers can we support?" =A0Using my current jobs file, fio
>>> starts by creating the files (e.g "foo0: Laying out IO file(s) (1
>>> file(s) / 4MB)") before it starts processing. =A0However, creating the
>>> files in advance accounts for a chunk of performance that doesn't seem
>>> to be measured by fio. =A0Am I misunderstanding how to configure fio or
>>> its intended usage?
>>
>> You should be able to set overwrite=3D0 to avoid that. Are they random
>> writes?
>
> overwrite=3D0 is even default. I'm thinking the "Laying out IO file"
> message is confusing, it wont actually write contents first unless you
> ask it to (with eg overwrite=3D1).
>
>
> --
> Jens Axboe
>
>

