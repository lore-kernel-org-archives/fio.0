Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37955 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751770AbdAWVtu (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 16:49:50 -0500
Received: by mail-wm0-f44.google.com with SMTP id r144so178280529wme.1
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 13:49:50 -0800 (PST)
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com>
 <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com>
 <CANvN+emM2xeKtEgVofOyKri6WBtjqc_o1LMT8Sfawb_RMRXT0g@mail.gmail.com>
 <4b7ca744-9b23-5f55-b3f7-354aa618288a@gmail.com>
 <CANvN+e=ASW14ShvY6dmVvUDY3PJVWwY9oQSbOT9EiOnQbSZHzA@mail.gmail.com>
 <CANvN+ek0DgHF4gFAVep9ygdi=4pi9O9Fp5u3-VOd0iEVCSS0=Q@mail.gmail.com>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <14bc36ca-83ea-484e-152b-9856d2e528ac@gmail.com>
Date: Mon, 23 Jan 2017 22:49:48 +0100
MIME-Version: 1.0
In-Reply-To: <CANvN+ek0DgHF4gFAVep9ygdi=4pi9O9Fp5u3-VOd0iEVCSS0=Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org

Hi Andrey,

> Thanks again for your tips .. the psync thingy in particular. I need to
> verify if that applies to PostgreSQL, because it brings huge gains compared
> to sync!
>
>
> That's easy to explain, it just does one syscall less per IO. It should
> indeed bring home a measurable gain as, with synchronous I/O, I believe
> you're cpu-limited.

Sadly, it seems PostgreSQL currently does lseek/read/write. (I'll double 
check tomorrow running perf against an active PostgreSQL instance).

There was a patch discussed here using pread/pwrite when avail

https://www.postgresql.org/message-id/flat/CABUevEzZ%3DCGdmwSZwW9oNuf4pQZMExk33jcNO7rseqrAgKzj5Q%40mail.gmail.com#CABUevEzZ=CGdmwSZwW9oNuf4pQZMExk33jcNO7rseqrAgKzj5Q@mail.gmail.com

which ends with a comment by Tom Lane (PostgreSQL core developer)

"Well, my point remains that I see little value in messing with
long-established code if you can't demonstrate a benefit that's clearly
above the noise level."

=(

I will post the findings from our discussion here to the PG hackers 
list. Maybe ...

Cheers,
/Tobias
