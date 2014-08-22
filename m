Return-Path: <axboe@kernel.dk>
Message-ID: <53F7C2C6.7000703@kernel.dk>
Date: Fri, 22 Aug 2014 17:23:02 -0500
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: multiple --name parameters with non-file engine?
References: <53F29D76.9080108@gmail.com>
In-Reply-To: <53F29D76.9080108@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Mark Nelson <mark.a.nelson@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-08-18 19:42, Mark Nelson wrote:
> Hi Guys,
>
> I'm using the librbd engine and trying to determine what exactly happens
> when multiple --name parameters are passed.  Primarily, I'm wondering if
> each fio process ends up writing to the same blocks on the rbd volume
> during sequential writes.  Looking at the code, I see a note that we
> pretend to deal with files even if the engine doesn't understand the
> concept of files:
>
> https://github.com/axboe/fio/blob/master/engines/rbd.c#L405
> https://github.com/axboe/fio/blob/master/filesetup.c#L1239
>
> I'm not seeing anything (might be missing it) in the rbd engine or there
> that would partition the volume based on the process though.  Am I
> missing anything?

The same thing will happen as if you ran two instances of fio with the 
same options. For rbd, each job will create/connect/open and rbd 
instance. For each of these, you can set the rbd pool and clientname.

-- 
Jens Axboe


