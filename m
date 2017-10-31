Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:51135 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdJaT7y (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 31 Oct 2017 15:59:54 -0400
Received: by mail-vk0-f47.google.com with SMTP id h142so107652vkf.7
        for <fio@vger.kernel.org>; Tue, 31 Oct 2017 12:59:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <MWHPR11MB2045095AA21ED4BF8BA38021875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
References: <MWHPR11MB2045B4FFEB905261E1FAFD1E875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <863271c2-eeb4-b770-bdfa-89746d4d9c70@kernel.dk> <MWHPR11MB2045DFA579DB2BDC5B1EA466875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
 <2feebb78-c436-3187-f28d-588f18b9dfc4@kernel.dk> <CALjAwxiwWDghXZpsN9vzR7AjwTgHU-g+iYeogbWvO5p6itMd6A@mail.gmail.com>
 <ddbb5d83-cc30-db5f-5c98-0b5809a15d76@kernel.dk> <MWHPR11MB2045095AA21ED4BF8BA38021875E0@MWHPR11MB2045.namprd11.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 31 Oct 2017 19:59:23 +0000
Message-ID: <CALjAwxhx45=uTivppp3A1ACdGmon-oaH9S4b41MJQ6TfQCP7ZA@mail.gmail.com>
Subject: Re: FIO windows
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David Hare <david.hare@primarydata.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Any chance you could cut your job file down to the smallest number of
options that still show the problem?

On 31 October 2017 at 19:55, David Hare <david.hare@primarydata.com> wrote:
> Jens,
>
> Still getting the error below when I add a 9th drive:
>
> fio: pid=6040, err=22/file:ioengines.c:333, func=td_io_queue, error=Invalid
> argument
> fio: pid=5880, err=22/file:ioengines.c:333, func=td_io_queue, error=Invalid
> argument
>
> I will follow you direction from this morning and submit a bug report.
>
> -Dave
>
>
> FIO file:
>
> [global]
> ioengine=windowsaio
> blocksize=64k
> direct=1
> iodepth=256
> group_reporting
>
> rw=read
> size=1g
> numjobs=2
>
> thread=8
> time_based
> runtime=10
>
> ;cpus_allowed=1-43
> ;cpus_allowed_policy=shared
> ;verify_async_cpus=shared
>
> [asdf]
> filename=F\:\\testfile:G\:\\testfile:H\:\\testfile:I\:\\testfile:J\:\\testfile:K\:\\testfile:L\:\\testfile:M\:\\testfile:P\:\\testfile:

For example - should you have a trailing : in this line?

-- 
Sitsofe | http://sucs.org/~sits/
