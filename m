Return-Path: <axboe@kernel.dk>
Message-ID: <534EB748.70207@kernel.dk>
Date: Wed, 16 Apr 2014 11:00:56 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio laying out file question
References: <CANyhEAtZQdnzCiQj77u+WbGkk1d6yXBnrHE0pKypbX0mDPNeeQ@mail.gmail.com>
In-Reply-To: <CANyhEAtZQdnzCiQj77u+WbGkk1d6yXBnrHE0pKypbX0mDPNeeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Yuyang Wang <yyalex.wang@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/16/2014 08:21 AM, Yuyang Wang wrote:
> hi all
> 
> I am using fio (2.1.7) for a simple sequential write test (see command
> below). It seems the process will get stuck on "Laying out IO file" for a
> long long time ...  Of course, smaller size take less time for layout,  I
> am curious as to, is FIO trying to precreate the file before doing write,
> what's going on there?
> 
> ./fio --rw=write --size=128g --bs=8m --filename=/test/$RANDOM
> --ioengine=posixaio --iodepth=16 --name=mytest

For a pure write, it wont layout the file completely first. I'm guessing
you are stuck in fallocate - depending on the file system, that will
fill out blocks. You can try and add fallocate=none, that should get rid
of it.

-- 
Jens Axboe


