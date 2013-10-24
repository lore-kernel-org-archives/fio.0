Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:53885 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab3JXBQ7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Oct 2013 21:16:59 -0400
Received: by mail-la0-f44.google.com with SMTP id ep20so1329399lab.17
        for <fio@vger.kernel.org>; Wed, 23 Oct 2013 18:16:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49ob6fyl5b.fsf@segfault.boston.devel.redhat.com>
References: <590651218.789538.1382525144344.JavaMail.zimbra@desy.de> <x49ob6fyl5b.fsf@segfault.boston.devel.redhat.com>
From: "Brian L." <brianclam@gmail.com>
Date: Wed, 23 Oct 2013 18:16:37 -0700
Message-ID: <CAAAK+WXN9JS8fvMhA1qBvscRzT+FWifcMrdDp034LEGLp835Qw@mail.gmail.com>
Subject: Re: sequential workload
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Brian L.


On Wed, Oct 23, 2013 at 10:03 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> "Mkrtchyan, Tigran" <tigran.mkrtchyan@desy.de> writes:
>
>> Hi,
>>
>> I need to simulate a workload of generating sequence
>> of files - some thing like creating photos.
>>
>> where is my config:
>> [global]
>> create_on_open=1
>> unlink=1
>> filesize=70m
>> size=7000m
>>
>> [pilatus-sec-write]
>> rw=write
>> openfiles=1
>> nrfiles=100
>> stonewall
>>
>>
>> I will expect that a combination of create_on_open and openfiles
>> will create one file at the time, nevertheless all files get
>> created at the same time.
>
> Try adding file_service_type=sequential to your job file.
>
> Cheers,
> Jeff
> --

if you can't find a soln, try a for loop and create sections like these??:

[pilatus-sec-write_1]
rw=write
openfiles=1
nrfiles=1
stonewall

[pilatus-sec-write_2]
rw=write
openfiles=1
nrfiles=1
stonewall

[pilatus-sec-write_3]
rw=write
openfiles=1
nrfiles=1
stonewall
