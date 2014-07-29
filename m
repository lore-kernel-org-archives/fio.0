Return-Path: <axboe@kernel.dk>
Message-ID: <53D74395.6070900@kernel.dk>
Date: Tue, 29 Jul 2014 08:47:49 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Pull an external [global] section into an .fio file?
References: <CANvN+e=7M4A=g9ro1dmOJdC2NBj4+iEUaCYrwGfmGY+bpUsnNA@mail.gmail.com>
In-Reply-To: <CANvN+e=7M4A=g9ro1dmOJdC2NBj4+iEUaCYrwGfmGY+bpUsnNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-07-28 19:42, Andrey Kuzmin wrote:
> When dealing with a growing number of fio test scripts, copy/pasting
> global section becomes error-prone and cumbersome. Is it possible (or
> how much effort would it be to add such a feature) to pull a named set
> of global settings into the .fio file?

Not currently possible, but I can see it being a useful feature. I'll 
add it to the list. Something ala

fio --shared globals.fio actual-job.fio

I added something similar back in April for command line jobs, where you 
can now do

fio --some-setting=1 --other-setting=2 actual-job.fio

and have that those settings be part of the global namespace.

-- 
Jens Axboe


