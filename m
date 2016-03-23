Return-Path: <axboe@kernel.dk>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Linux OS killed fio process because fio invoked oom_killer
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADvrUP9duNxzfMuQum-e_YXqVUjG_K8any52e7sQn6ZcBy9o8Q@mail.gmail.com>
Date: Tue, 22 Mar 2016 18:42:27 -0600
Content-Transfer-Encoding: quoted-printable
Message-Id: <61A20AC4-3F8E-4B1E-A2C9-81BE827B188F@kernel.dk>
References: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com> <56F17326.3000908@kernel.dk> <CADvrUP9duNxzfMuQum-e_YXqVUjG_K8any52e7sQn6ZcBy9o8Q@mail.gmail.com>
To: flash yan <flashyan83@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

What job did you run? When reporting a potential issue, always include that.=
 Hard to help or advise otherwise.=20

> On Mar 22, 2016, at 5:12 PM, flash yan <flashyan83@gmail.com> wrote:
>=20
> This issue happened after about 20 minutes. The iscsi device is very
> small, only 128MB.
> As you said, I have enabled verify=3D options.
> I will try big iscsi device and no verify.
>=20
> Thanks
>=20
> Liang Yan
>=20
> 2016-03-23 0:30 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
>>> On 03/22/2016 08:06 AM, flash yan wrote:
>>>=20
>>> Hi all,
>>>=20
>>> I have run fio-2.7 to test iscsi device, one unusual issue happened.
>>> If I set the io_size to 4096, queue_depth to 16 ,rw to randwrite and
>>> run_time to 3000,
>>> the fio would invoke oom_killer and the Linux OS would kill the fio
>>> process.
>>> The machine have about 11 GB memory and I have tried the machine with
>>> 23GB, the issue also happened.
>>> I think fio have problem when dealing with 4KB io_size then used too
>>> many memory.
>>=20
>>=20
>> When did this happen - shortly after the job is started, or long after? H=
ow
>> big is the iscsi device? Did you have verify=3D options enabled?
>>=20
>> --
>> Jens Axboe
>>=20

