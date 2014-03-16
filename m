Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:63816 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbaCPXQn (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 16 Mar 2014 19:16:43 -0400
Received: by mail-ve0-f179.google.com with SMTP id db12so4910107veb.38
        for <fio@vger.kernel.org>; Sun, 16 Mar 2014 16:16:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com>
References: <53243539.5010405@adon.li>
	<CACVXFVNbNpwH44DHfN+BU2a7KvF=Ah7As3+UwKHB8eGOX6b7ug@mail.gmail.com>
Date: Sun, 16 Mar 2014 16:16:42 -0700
Message-ID: <CAF+0mvmJqfvzdDrj8qWxmfgAh7jM9=f20v2pMTpFU-75vuTFRw@mail.gmail.com>
Subject: Re: correct file size to use
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: jvogt <jvogt@adon.li>, fio@vger.kernel.org

On Sun, Mar 16, 2014 at 5:12 AM, Ming Lei <tom.leiming@gmail.com> wrote:
> On Sat, Mar 15, 2014 at 7:10 PM, jvogt <jvogt@adon.li> wrote:
>> Hi list
>>
>> I was wondering:
>> When i start
>> fio --name=/srv/mail/test --size=10M --direct=1 --runtime=60 --time_based
>> --group_reporting --refill_buffer --rw=read --numjobs=1
>>
>> I get as result:
>> read : io=1177.4MB, bw=20093KB/s, iops=5023, runt= 60000msec
>
> From fio/HOWTO:
>
> time_based  If set, fio will run for the duration of the runtime
>         specified even if the file(s) are completely read or
>         written. It will simply loop over the same workload
>         as many times as the runtime allows.
>
> The same 10M file will be read many times(118), so most
> of times it is read from page cache instead of the file, and
> the result can't be accurate enough.
>
>
>
> Thanks,
> --
> Ming Lei
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Tested on my system and saw no difference in performance.  Direct io
will bypass the page cache so the only thing that comes to mind would
be an on-device cache, though, I would think the difference in
performance would be more dramatic if that were the case.
