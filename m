Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-it1-f176.google.com ([209.85.166.176]:40622 "EHLO
        mail-it1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbeJaA2V (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 30 Oct 2018 20:28:21 -0400
Received: by mail-it1-f176.google.com with SMTP id i191-v6so14176380iti.5
        for <fio@vger.kernel.org>; Tue, 30 Oct 2018 08:34:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AT5PR8401MB1169A4654019B7EA12C5DD93ABCC0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAFF4W0UAVN49BsfKa+nkzgCd8XKEPi57f9v8785YR5wjXqzepQ@mail.gmail.com>
 <AT5PR8401MB1169A4654019B7EA12C5DD93ABCC0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
From: Mohanraj B <bmohanraj91@gmail.com>
Date: Tue, 30 Oct 2018 21:04:23 +0530
Message-ID: <CAFF4W0XQ8096s_XGQsULoU=tMhA8BDHs4CrP=pmjv-DS0840Tw@mail.gmail.com>
Subject: Re: Understanding --section=name option.
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Cc: fio <fio@vger.kernel.org>

Thanks for the info Elliott, Its working fine now.

Mohan

On 10/30/18, Elliott, Robert (Persistent Memory) <elliott@hpe.com> wrote:
>
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Mohanraj B
>> Sent: Tuesday, October 30, 2018 5:01 AM
>> Subject: Understanding --section=name option.
> ...
>>
>> [job1]
>> rw=randread
>> size=100M
>>
>> [job2]
>> rw=read
>> size=10m
>>
>> I want to run the job2 only, so used --section option.
>> Below is the docker command have used to test --section option.
>>
>> docker run -v /home/:/tmp/fio-data/ fio:5.0 --section job2 --client
>> 172.17.0.3 read.fio
>> May be I am not using the option properly, please explain how to use
>> the option based on the job file I have given here.
>
> The convention for most command line tools, not just fio, is
> 	--option=value
> not
> 	--option value
>
> The one-character shorthand options, when they exist, use spaces:
> 	-o value
>
> See https://www.gnu.org/software/libc/manual/html_node/Argument-Syntax.html
>
> ---
> Robert Elliott, HPE Persistent Memory
>
>
>
>
>
>

