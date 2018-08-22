Return-Path: <guochao@nutstore.net>
MIME-Version: 1.0
In-Reply-To: <b0ba9833-7739-e9ea-0b36-e8744734c9ed@kernel.dk>
References: <CADhrBQRs9AnEwucJi01ydagqZjuZ=CYeWKeBG+Ds0P46sb-g+Q@mail.gmail.com>
 <b0ba9833-7739-e9ea-0b36-e8744734c9ed@kernel.dk>
From: Chao Guo <guochao@nutstore.net>
Date: Wed, 22 Aug 2018 18:40:44 +0800
Message-ID: <CADhrBQQZ=AUmsAcTUpv6YSFdL27v7NsZD98Q0Cd8p8UhORk-zQ@mail.gmail.com>
Subject: Re: [Bug-Report] fio cannot handle some situation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

ok. that makes sense.

i thought that the file fio created was already written with verify data.

thanks a lot

On Tue, Aug 21, 2018 at 11:19 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 8/21/18 4:21 AM, Chao Guo wrote:
>> 1) A description of what you think the bug is:
>>
>>   when using readwrite=3Drandread and do_verify=3D1, fio always fails wi=
th
>> 'Invalid or incomplete multibyte or wide character'
>>
>>
>> 2) Environment (Linux distro version, kernel version). This is mostly
>>    needed if it's a build bug.
>>
>>    CentOS 7(fio 3.1-2)
>>
>>    CentOS 7(build from github.com/axboe/fio, master)
>>
>>    Ubuntu 18.04(fio 3.1-1)
>>
>> 3) The output from fio --version.
>>
>>    See above
>>
>> 4) How to reproduce. Please include a full list of the parameters
>>    passed to fio and the job file used (if any).
>>
>> [global]
>> ioengine=3Dlibaio
>> direct=3D1
>> group_reporting
>> iodepth=3D128
>> bs=3D1M
>> readwrite=3Drandread
>> size=3D500MB
>> do_verify=3D1
>> verify=3Dcrc32c-intel
>>
>> [test]
>> filename=3Dtest
>
> You're asking fio to verify a file, which assumes that the file
> has already been written with verify data. That's not the case
> (unless you ran another job to do that first), so the verify will
> naturally fail.
>
> Change your readwrite=3Drandread to readwrite=3Drandwrite, and fio
> will randomly write it first, them randomly read and verify.
>
> --
> Jens Axboe
>



--=20
=E5=85=B3=E6=B3=A8=E5=AE=98=E5=BE=AE=EF=BC=8C=E8=8E=B7=E5=AE=9E=E6=97=B6=E5=
=B8=AE=E5=8A=A9

 =E9=83=AD=E8=B6=85 Guo Chao

=E4=B8=8A=E6=B5=B7=E4=BA=A6=E5=AD=98=E7=BD=91=E7=BB=9C=E7=A7=91=E6=8A=80=E6=
=9C=89=E9=99=90=E5=85=AC=E5=8F=B8 Yicun Network Tech Co., Ltd.
=E9=82=AE=E7=AE=B1 Email: guochao@nutstore.net
=E6=89=8B=E6=9C=BA Mobile: 18729085840

