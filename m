Return-Path: <axboe@kernel.dk>
Subject: Re: Fwd: segmentation fault in flist from workqueue.c
References: <CAMHrwcQSQ+NO2Nd0Y8FkF9WQF=UYY7pM3cmQj_0TZbTH9oQyHA@mail.gmail.com>
 <CAMHrwcTuHiYLFPYTg7ZGP_LNDOKisp4MUmGXJP+-vSHRUSRdyA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f23d9865-4daf-cf4f-2b8b-43e5e4c8c22f@kernel.dk>
Date: Thu, 22 Jun 2017 17:18:39 -0600
MIME-Version: 1.0
In-Reply-To: <CAMHrwcTuHiYLFPYTg7ZGP_LNDOKisp4MUmGXJP+-vSHRUSRdyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Ido Ben-Tsion <idob@infinidat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/22/2017 03:15 AM, Ido Ben-Tsion wrote:
> hi,
> 
> I'm using fio-2.21 built without optimization on Centos based distribution
> Linux ... 3.10.0-... + #1 SMP Thu May 18 13:39:20 UTC 2017 x86_64
> x86_64 x86_64 GNU/Linux
> 
> fio crashed on segmentation fault.
> it happened several times, with a different set of parameters, always
> with ioqueue depth higher than 1.
> 
> details from one of the crashes follow.

Can you try current -git? I just committed multiple fixes for this.
It's a problem with the runtime log compression.
 
-- 
Jens Axboe


