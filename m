Return-Path: <gschoenberger@thomas-krenn.com>
MIME-Version: 1.0
From: =?iso-8859-15?Q?Georg_Sch=F6nberger?= <gschoenberger@thomas-krenn.com>
Date: Fri, 8 Jun 2012 11:20:03 -0600
Subject: Re: Error running Fio SSD example
Message-ID: <4FD23443.6020705@thomas-krenn.com>
References: <4FC8942A.6090805@thomas-krenn.com>
 <4FD1F462.4070404@fusionio.com>
In-Reply-To: <4FD1F462.4070404@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Am 2012-06-08 14:47, schrieb Jens Axboe:
> On 06/01/2012 12:06 PM, Georg Sch=F6nberger wrote:
>> Hello again,
>>
>> I am having some troubles with running the fio example "ssd-test". I
>> changed the global section to decrease the size:
>> [global]
>> bs=3D4k
>> ioengine=3Dlibaio
>> iodepth=3D4
>> size=3D100M
>> direct=3D1
>> runtime=3D60
>> filename=3Dssd.test.file
>>
>> If I am running Fio I get the following error:
>> ----------------------------------------
>> fio.git/examples$ fio ssd-test
>> seq-read: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iodep=
th=3D4
>> rand-read: (g=3D1): rw=3Drandread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, =
iodepth=3D4
>> seq-write: (g=3D2): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iod=
epth=3D4
>> rand-write: (g=3D3): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio=
, iodepth=3D4
>> fio-2.0.8
>> Starting 4 processes
>> fio: pid=3D17997, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.fi=
le),
>> error=3DInvalid argument
>> fio: pid=3D17998, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.fi=
le),
>> error=3DInvalid argument
>> fio: pid=3D17999, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.fi=
le),
>> error=3DInvalid argument
>> fio: pid=3D18000, err=3D22/file:filesetup.c:529, func=3Dopen(ssd.test.fi=
le),
>> error=3DInvalid argument
> Looks like the file system hosting the test file does not support
> O_DIRECT.
>
The file system is ext4.
Kernel Version 3.2.0-24-generic

-Georg

