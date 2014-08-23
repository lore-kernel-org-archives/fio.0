Return-Path: <mark.a.nelson@gmail.com>
Return-Path: <mark.a.nelson@gmail.com>
Message-ID: <53F7F22B.1090904@gmail.com>
Date: Fri, 22 Aug 2014 20:45:15 -0500
From: Mark Nelson <mark.a.nelson@gmail.com>
MIME-Version: 1.0
Subject: Re: multiple --name parameters with non-file engine?
References: <53F29D76.9080108@gmail.com> <53F7C2C6.7000703@kernel.dk>
In-Reply-To: <53F7C2C6.7000703@kernel.dk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/22/2014 05:23 PM, Jens Axboe wrote:
> On 2014-08-18 19:42, Mark Nelson wrote:
>> Hi Guys,
>>
>> I'm using the librbd engine and trying to determine what exactly happens
>> when multiple --name parameters are passed.  Primarily, I'm wondering if
>> each fio process ends up writing to the same blocks on the rbd volume
>> during sequential writes.  Looking at the code, I see a note that we
>> pretend to deal with files even if the engine doesn't understand the
>> concept of files:
>>
>> https://github.com/axboe/fio/blob/master/engines/rbd.c#L405
>> https://github.com/axboe/fio/blob/master/filesetup.c#L1239
>>
>> I'm not seeing anything (might be missing it) in the rbd engine or there
>> that would partition the volume based on the process though.  Am I
>> missing anything?
>
> The same thing will happen as if you ran two instances of fio with the
> same options. For rbd, each job will create/connect/open and rbd
> instance. For each of these, you can set the rbd pool and clientname.
>

Thanks Jens.  What I'd like to be able to do is start multiple fio 
processes but have each one only write to a non-overlapping portion of 
the block device.  Preferably I wouldn't have to manually figure out the 
ranges myself.  Any way to do something like that?

For now if we are interested in 4MB IOs to RBD we can just do 4MB random 
as that more or less translates into the same thing behind the scenes in 
Ceph anyway.

Mark

