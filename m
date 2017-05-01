Return-Path: <kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5a084345-a8bf-3373-cc78-3d5d50acb13b@kernel.dk>
References: <20170501184820.31025-1-tkusumi@tuxera.com> <20170501204421.GA13925@kernel.dk>
 <CAHndrBmB7X6rzNtB8n+eK_qxOFpYkbPf+vegKFVcOCQFinG1Yw@mail.gmail.com> <5a084345-a8bf-3373-cc78-3d5d50acb13b@kernel.dk>
From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Date: Tue, 2 May 2017 00:10:55 +0300
Message-ID: <CAHndrB=ZVvQ7xjM2w2wg4UJFT84RQNAm-sXBRfEk8hmR8ywp7A@mail.gmail.com>
Subject: Re: [PATCH 01/11] configure: Disable CONFIG_POSIX_FALLOCATE on NetBSD
 even if posix_fallocate(3) compiles
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

2017-05-01 23:57 GMT+03:00 Jens Axboe <axboe@kernel.dk>:
> On 05/01/2017 02:54 PM, Tomohiro Kusumi wrote:
>> Hi
>>
>> 2017-05-01 23:44 GMT+03:00 Jens Axboe <axboe@kernel.dk>:
>>> On Mon, May 01 2017, kusumi.tomohiro@gmail.com wrote:
>>>> From: Tomohiro Kusumi <tkusumi@tuxera.com>
>>>>
>>>> fio on NetBSD may have CONFIG_POSIX_FALLOCATE configuration enabled
>>>> since posix_fallocate(3) compiles (at least on recent versions),
>>>> but this is actually not supported on UFS as mentioned in below wiki
>>>> and fio result.
>>>>
>>>> https://wiki.netbsd.org/projects/project/ffs-fallocate/
>>>>> This functionality is not currently implemented for FFS;
>>>>
>>>> compile_prog() during ./configure fails to catch this as it doesn't
>>>> run the test code after compilation (and it needs to use a valid fd
>>>> in order to do runtime test).
>>>>
>>>> This commit simply disables CONFIG_POSIX_FALLOCATE on NetBSD regardless
>>>> of compilation result on ./configure. It doesn't check the fs type,
>>>> but it should be enough provided that UFS is the fs used by majority
>>>> of users and there's also no real alternative for disk fs.
>>>
>>> I'd much rather we just avoid it if we get EOPNOTSUPP at runtime. That
>>> way we don't have to change anything later on, when/if NetBSD does get
>>> support for fallocate.
>>
>> Yes, so the next one 2/11 actually mostly reverts this, and replace it
>> with runtime check, so that it works not only with this specific
>> NetBSD/UFS case, but also for e.g. Linux fs (something other than
>> ext4, XFS, etc).
>> I wasn't sure if runtime check (execute $TMPE) is preferred.
>
> Let's just drop 1/11 then, and have the first patch cover the runtime of
> it. But don't do that from configure. Whatever fs is hosting configure
> is less interesting. Maybe that doesn't support fallocate, but whatever
> you end up running on does. Or vice versa.

Thanks.
Yes, you're right.
They could certainly be different fs...

>
>> Any how, I'll resend the 1,2,3,4,11 with --cover-letter as you commented.
>
> Thanks!
>
> --
> Jens Axboe
>

