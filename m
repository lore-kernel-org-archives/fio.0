Return-Path: <mogwaing@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANvN+e=iv05VXis+QzYScYE=ietfXhetq-KxZ8etBEi0igU9Fw@mail.gmail.com>
References: <CAPDOW77bBKw7dm1e+jHdN+PXMnAddEzQOxnL6nPY25nZU2FCfQ@mail.gmail.com>
	<1582502590.159531.1354372015482.JavaMail.root@thomas-krenn.com>
	<CAPDOW77s0v6mrEr_DMUm1O4dBrFmD6aMbuDwj-Wsq6TiHU2Ysw@mail.gmail.com>
	<CAPDOW74vcyU6fj5xfL8rtbX1bRRXRv6KH0musfVEoq-GFm+aVQ@mail.gmail.com>
	<50BCAC6C.6010009@kernel.dk>
	<CANvN+e=iv05VXis+QzYScYE=ietfXhetq-KxZ8etBEi0igU9Fw@mail.gmail.com>
Date: Tue, 4 Dec 2012 02:09:40 +0900
Message-ID: <CAPDOW77MYSa8goV12f4A+RusQSgnP0hcw5GBD-a6D+VztkGmPw@mail.gmail.com>
Subject: Re: I/O is issued twice at scsi level
From: Hiroyuki Yamada <mogwaing@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, =?ISO-8859-1?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Sorry for update.
I figured it out.
It's from ext3's indirect block mapping.
There is one mapping block in each 1024 blocks,
so accessing a large file randomly has high chance of accessing the
mapping block and the requested block.

Ext4 has different and more efficient addressing called extent (tree), and
we can avoid the issue.

On Mon, Dec 3, 2012 at 10:59 PM, Andrey Kuzmin
<andrey.v.kuzmin@gmail.com> wrote:
> And where is the corresponding updated atime write? Buffered?
> Regards,
> Andrey
>
>
> On Mon, Dec 3, 2012 at 5:43 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> Quick guess - it's updating the mtime/atime on the inode?
>>
>>
>> On 2012-12-02 10:23, Hiroyuki Yamada wrote:
>>> I figured out what is going on, but I don't know what it is for.
>>>
>>> Ext3 filesystem has some 4KB data in each 4096KB(8192 sectors) data.
>>> Visually, data is aligned like the following.
>>>
>>> |4KB|4096KB|4KB|4096KB|4KB|4096KB| ...
>>>
>>> And 4096KB area in only accessible by application programs.
>>> When accessing the first 4096KB area for the first time,
>>> then OS reads the 4KB just before the 4096KB area first
>>> and then read the requested data in the 4096KB area.
>>>
>>> When accessing a large file (compared to the DRAM size) randomly,
>>> every I/O has rare chance of hitting page cahce,
>>> so every I/O request comes together with 4KB I/O.
>>>
>>> The thing is what the 4KB data is for ?
>>> Is this location metadata for filesystem ?
>>> Is there any way I can remove this ?
>>> Or Is there any way I can clear the 4096KB area only ?
>>>
>>> Any comments and advices are appreciated.
>>>
>>> (I tested in many machines with many kernel versions. this happens in
>>> all machines.)
>>>
>>> Thanks.
>>>
>>> On Sat, Dec 1, 2012 at 11:51 PM, Hiroyuki Yamada <mogwaing@gmail.com> w=
rote:
>>>> Hi Georg,
>>>>
>>>> I am using CentOS 5.7 and 5.8.
>>>> Using ext3 FS on LVM.
>>>> This issue happens without LVM, so LVM is not the cause, I think.
>>>>
>>>> I changed the I/O size at the application level to 16KB then,
>>>> 16KB I/O and 4KB I/O are issued at scsi level as following.
>>>> (SYSPREAD is application level I/O and SCSI is scsi i/o dispatching
>>>> from systemtap.)
>>>>
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> SYSPREAD random(8472) 3, 0x16fc5200, 16384, 128137183232
>>>> SCSI random(8472) 0 1 0 0 start-sector: 226321183 size: 4096 bufflen
>>>> 4096 FROM_DEVICE 1354354008068009
>>>> SCSI random(8472) 0 1 0 0 start-sector: 226323431 size: 16384 bufflen
>>>> 16384 FROM_DEVICE 1354354008075927
>>>> SYSPREAD random(8472) 3, 0x16fc5200, 16384, 21807710208
>>>> SCSI random(8472) 0 1 0 0 start-sector: 1889888935 size: 4096 bufflen
>>>> 4096 FROM_DEVICE 1354354008085128
>>>> SCSI random(8472) 0 1 0 0 start-sector: 1889891823 size: 16384 bufflen
>>>> 16384 FROM_DEVICE 1354354008097161
>>>> SYSPREAD random(8472) 3, 0x16fc5200, 16384, 139365318656
>>>> SCSI random(8472) 0 1 0 0 start-sector: 254092663 size: 4096 bufflen
>>>> 4096 FROM_DEVICE 1354354008100633
>>>> SCSI random(8472) 0 1 0 0 start-sector: 254094879 size: 16384 bufflen
>>>> 16384 FROM_DEVICE 1354354008111723
>>>> SYSPREAD random(8472) 3, 0x16fc5200, 16384, 60304424960
>>>> SCSI random(8472) 0 1 0 0 start-sector: 58119807 size: 4096 bufflen
>>>> 4096 FROM_DEVICE 1354354008120469
>>>> SCSI random(8472) 0 1 0 0 start-sector: 58125415 size: 16384 bufflen
>>>> 16384 FROM_DEVICE 1354354008126343
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>
>>>> Do you have any idea what's going on ?
>>>>
>>>>
>>>>
>>>> On Sat, Dec 1, 2012 at 11:26 PM, Georg Sch=F6nberger
>>>> <gschoenberger@thomas-krenn.com> wrote:
>>>>> ----- Original Message -----
>>>>>> From: "Hiroyuki Yamada" <mogwaing@gmail.com>
>>>>>> To: fio@vger.kernel.org
>>>>>> Sent: Saturday, 1 December, 2012 9:31:42 AM
>>>>>> Subject: I/O is issued twice at scsi level
>>>>>>
>>>>>> Hi,
>>>>>>
>>>>>> I am using fio for benchmarking random read IOPS of files.
>>>>>> (Test configuration is listed at the bottom.)
>>>>>>
>>>>>> I have traced I/Os from fio by systemtap and
>>>>>> noticed that the number of I/Os at scsi level is twice as many as th=
e
>>>>>> number of I/Os at vfs level.
>>>>>> But, I/O size at both scsi level and vfs level shown as 4KB, so
>>>>>> simply
>>>>>> measured 1/2 performance.
>>>>>> I also tried by benchmarking tools and the same issue happend.
>>>>>> so, it's not fio specific issue.
>>>>>> But, I am wondering if any of you knows the reason for that or some
>>>>>> hints.
>>>>>>
>>>>>>
>>>>>> Test configuration.
>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>> ioengine=3Dpsync
>>>>>> rw=3Drandread
>>>>>> numjobs=3D1
>>>>>> blocksize=3D4096
>>>>>> filename=3Dfile_morethan_100G
>>>>>> thread
>>>>>> runtime=3D60
>>>>>> randrepeat=3D0
>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>> (I clean up page caches every time before mesurement.)
>>>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Hiroyuki
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>>>
>>>>> This is very interesting as I am currently investigating a 50% perfor=
mance gap between two performance systems.
>>>>> I am inspecting a 50% difference concerning 4k random read IOPS for t=
he same device on different systems (a SCSI SSD), one Ubuntu 12.04 and one =
CentOS.
>>>>>
>>>>> Can you provide some more information about your platform?
>>>>>
>>>>> Thanks, Georg
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> --
>> Jens Axboe
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

