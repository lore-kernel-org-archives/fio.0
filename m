Return-Path: <zhangtl@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4E70E6BB.6060708@kernel.dk>
References: <CADson1wk9astwdroeAtPXb4A3+yrAcDcCXaEPvEGJPhM4TBfqQ@mail.gmail.com>
	<CADson1wi5=W-WDbDGy1j2T4FZD_2yoGGzOG8Af7GKKppiY7Lrg@mail.gmail.com>
	<4E70E6BB.6060708@kernel.dk>
Date: Thu, 15 Sep 2011 10:49:46 +0800
Message-ID: <CADson1y9VBx_gvHHafaQddA9NHjpwFwgtWZ854HHGE+EgfBvZw@mail.gmail.com>
Subject: Re: memory leak bug? when do write with verify
From: Zhang Taile <zhangtl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi ,
Understand now.
One more question, what backlog for?  Why read only with verify do not need=
 it?

Thanks!

On Thu, Sep 15, 2011 at 1:39 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-09-14 11:53, Zhang Taile wrote:
>> HI
>> When I do RandWrite with verify, fio will use a lot of memory. The fio
>> will increase memory about 10MB in every second. And, the system will
>> become very slow, after fio start to use swap partition.
>>
>> For example, =C2=A0if use fio with following configuration,
>> [rand-write]
>> rw=3Drandwrite
>> numjobs=3D32
>> loops=3D10
>> thread=3D1
>> filename=3D/dev/sdb
>> verify=3Dmd5
>> verify_interval=3D4k
>>
>> after =C2=A0minutes, top will Like this :
>> =C2=A0PID USER =C2=A0 =C2=A0 =C2=A0PR =C2=A0NI =C2=A0VIRT =C2=A0RES =C2=
=A0SHR S %CPU %MEM =C2=A0 =C2=A0TIME+ =C2=A0COMMAND
>> =C2=A03749 root =C2=A0 =C2=A0 =C2=A015 =C2=A0 0 2672m 1.5g 304m S 169.4 =
40.4 =C2=A0 4:10.04 fio
>>
>>
>> If remove the verify from the configuration, there will be no the
>> memory problem.
>>
>> I guess it is a memory leak problem?
>
> It's probably not a leak, fio will use a lot of memory for your job
> file. Each job will maintain a full backlog of meta data for blocks
> written, so it can safely verify it. And you have 32 jobs, so it'll be a
> lot of memory.
>
> --
> Jens Axboe
>
>



--=20
Zhang, Taile=C2=A0 =E5=BC=A0=E6=B3=B0=E4=B9=90
zhangtl@gmail.com
MP:18611745290
msn:zhangtaile@hotmail.com
skype: zhangtaile

