Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:35492 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3AWRrT (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Jan 2013 12:47:19 -0500
Received: by mail-vc0-f180.google.com with SMTP id fo13so3047678vcb.25
        for <fio@vger.kernel.org>; Wed, 23 Jan 2013 09:47:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJdxx77Yq=Df4eS-iQVfFNXzjBusF3zG+ZLhLnGQVuVHhdkA=g@mail.gmail.com>
References: <CAJdxx76y1m6NG9_D86XXY4xz2mJc4guP1Qa_DCqNQNamNPxK7w@mail.gmail.com>
	<50F3CB5F.8070507@kernel.dk>
	<CAJdxx75-H7LOQ3Kf13U6h7TskpvCKuwL4pbkG16PzHinYwHRsw@mail.gmail.com>
	<CAJdxx77Yq=Df4eS-iQVfFNXzjBusF3zG+ZLhLnGQVuVHhdkA=g@mail.gmail.com>
Date: Wed, 23 Jan 2013 09:47:18 -0800
Message-ID: <CAJdxx74Tu3LHhJ9LUOTg=K3NfiwY6iD9mrDS=_3EXcqEKNaENg@mail.gmail.com>
Subject: Re: asking for an example job file
From: Hong Jiang <hong@maginatics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi there,

This is a followup question - the attached sample job file, I could
run it successfully on linux but on Windows, even though the files are
created, fio never exit.  I tried same test on local system directory
on Windows, the same situation.  Does anyone know why?  Thanks!

; Keep adding 1024kb/s reading clients at 4 seconds
[global]
size=32m
rw=read
directory=C:\Users\xxxx\test
rate=1250
#ratemin=1024

[file1]
startdelay=0

[file2]
startdelay=4

[file3]
startdelay=8

[file4]
startdelay=12

[file5]
startdelay=16

[file6]
startdelay=20

[file7]
startdelay=24

[file8]
startdelay=28

[file9]
startdelay=32

[file10]
startdelay=36

On Mon, Jan 14, 2013 at 9:21 AM, Hong Jiang <hong@maginatics.com> wrote:
> Thanks for all the suggestions.  Yes I did observe files being
> created.  I will play more with it taking your inputs.
>
> On Mon, Jan 14, 2013 at 1:09 AM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2013-01-11 20:24, Hong Jiang wrote:
>>> Hi there,
>>>
>>> I am pretty new to this tool, and currently evaluating it on both
>>> linux and windows platforms.  Would appreciate if someone shows me an
>>> example of job file that can test this scenario:
>>>
>>> I have a share that's created out of the "cloud", on windows client
>>> side it's mounted as a new drive, on linux it's mounted to a
>>> directory.  I would like to run some file op tests against the share.
>>>
>>> I tried to use the example job file that came with the package -
>>> 1mbs_clients, modifying the "directory" parameter setting in the file,
>>> but I am not sure it's really running against the share, as the result
>>> looks exact the same when I ran the test on 2 different shares.
>>>
>>> Thanks in advance for your help!
>>
>> Delete the output files and run the test again? If the files are
>> created, then you should be able to safely confirm that it is running
>> where you think it is running. Fio will prefix any file with the
>> --directory= setting. So if you did set it, it should work...
>>
>> --
>> Jens Axboe
>>
