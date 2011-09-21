Return-Path: <01jay.ly@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4E78EFBD.2060603@kernel.dk>
References: <CAG1+85Fp3HRn+MMQho8X4-34P7mDDdQPj455jCUW3O=wfzPRcQ@mail.gmail.com>
	<4E78EFBD.2060603@kernel.dk>
Date: Wed, 21 Sep 2011 15:34:16 +0800
Message-ID: <CAG1+85GrkLk6ccpYWTUF9HF-Dmv30txpXFDXeoCFCxpC4=GHJA@mail.gmail.com>
Subject: Re: Fio benchmark output "error=Too many open files
From: yan li <01jay.ly@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens;
     Thanks for your help. As you asked me, I checked again in the
benchmark system. Selinux is disabled.
     Sorry about my careless, Because setting of limit.conf is not work.

When I ran fio, only 1600 files have opened.
# cat /proc/sys/fs/file-nr
576	0	390196

run fio:
#cat /proc/sys/fs/file-nr
1600	0	390196

# cat /proc/sys/fs/file-max
390196

#cd /proc/fio_pid/fd
# ls -l | grep -c rw
1003

At this time, I knew, the limit.conf setting is not work.
#ulimit -n
1024

I add another line in /etc/security/limits.conf
*	soft	nofile	20480

Now, it 's ok. when I run fio, there are no the error messages.
#ulimit -n
20480


--
Homer Li



2011/9/21 Jens Axboe <axboe@kernel.dk>:
> On 2011-09-20 12:06, yan li wrote:
>> Hi fio users and developers,
>> =C2=A0 =C2=A0 When I run fio benchmark, there are some error in the scre=
en.
>> =C2=A0 =C2=A0 Does someone meet the same circumstances ?
>> =C2=A0 =C2=A0 Thanks, ^_^
>>
>> #fio fio.cfg
>> ......
>> fio: pid=3D29128, err=3D24/file:filesetup.c:529,
>> func=3Dopen(/mnt/rw1/rw1.168.2), error=3DToo many open files
>> fio: pid=3D29039, err=3D24/file:filesetup.c:529, func=3Dopen(/mnt/rw.79.=
2),
>> error=3DToo many open files
>> fio: pid=3D29040, err=3D24/file:filesetup.c:529, func=3Dopen(/mnt/rw.80.=
2),
>> error=3DToo many open files
>> fio: pid=3D29074, err=3D24/file:filesetup.c:529, func=3Dopen(/mnt/rw.114=
.2),
>> error=3DToo many open files
>> fio: pid=3D29026, err=3D24/file:filesetup.c:529, func=3Dopen(/mnt/rw.66.=
2),
>> error=3DToo many open files
>> ......
>
> Fio keeps all of its data files open, and from the jobs below, you have
>
> 3*8*128 =3D 3072
>
> in data files alone, add some house keeping, and perhaps you hit the
> limit? Seems a bit odd, given that the typical max is somewhat larger,
> and your selinux settings allow higher as well. What do
>
> /proc/sys/fs/file-{nr,max}
>
> show when this happens? You could also freeze fio at this point and ls
> -l /proc/pid-of-fio/fd/ to see if something strange is being held open.
>
> --
> Jens Axboe
>
>



--=20
Let one live alone doing no evil, care-free, like an elephant in the
elephant forest

