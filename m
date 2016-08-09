Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f178.google.com ([209.85.217.178]:33901 "EHLO
	mail-ua0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbcHIEfH (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 9 Aug 2016 00:35:07 -0400
Received: by mail-ua0-f178.google.com with SMTP id k90so2675599uak.1
        for <fio@vger.kernel.org>; Mon, 08 Aug 2016 21:35:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANfUGLbSKVO=9+rEnQ-1YZMVs=+diO4Ae9VRczwA0kJ_-nkrgQ@mail.gmail.com>
References: <CANfUGLbSKVO=9+rEnQ-1YZMVs=+diO4Ae9VRczwA0kJ_-nkrgQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 9 Aug 2016 05:35:05 +0100
Message-ID: <CALjAwxjGa7fOU6gkvX+pKVhbiNOTfEEaeozLQKKQR8FH0jt3rw@mail.gmail.com>
Subject: Re: Fio latency inconsistent
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "j.Lucas" <j_lucas@wp.pl>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 9 August 2016 at 00:02, j.Lucas <j_lucas@wp.pl> wrote:
>
> From output:
> Run time = 600001 ms
> queue depth = 1
> performed IO = 25740
>
> So correct me if i am wrong, but 600001 / 25740 = 23.31 ms
> However, fio reports an average latency of 38.24 ms.
> Should those numbers be consistent?

Let me repost some excerpts of your fio output:

> fio-2.1.10
[...]
>   read : io=7541.2MB, bw=12870KB/s, iops=25740, runt=600001msec
[...]
>      lat (usec): min=28, max=12057, avg=38.24, stdev=24.21
[...]
>      issued    : total=r=15444203/w=0/d=0, short=r=0/w=0/d=0

25740 represents I/O operations *per second* (as opposed to total
I/Os) and as such is already an average. Further, the latency was
reported in microseconds whereas the runtime in milliseconds.

However what you pasted says the total I/Os issued were 15444203 so:
600001/15444203*1000 = 38.84 (us)
which is only slightly more than fio's reported 38.24 us. The higher
number could be due to overhead inbetween each submitted I/O and
differences between where we start and stop counting time.

PS: Your fio version is quite old - you may want to upgrade...

-- 
Sitsofe | http://sucs.org/~sits/
