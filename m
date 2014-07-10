Return-Path: <axboe@kernel.dk>
Message-ID: <53BEF29E.3040500@kernel.dk>
Date: Thu, 10 Jul 2014 22:07:58 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio hangs with --status-interval
References: <CAE56cDuAUkhEnjMqCSWDcWrdwJrbffMcDG+FeCw6+7GN+jrWUg@mail.gmail.com> <53BE5286.2060203@kernel.dk> <CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>
In-Reply-To: <CAE56cDvPKq31NrawN_KZF2+eDHiMY2A7azsx8z_DQfG1=-_cnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Michael Mattsson <michael.mattsson@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-07-10 16:55, Michael Mattsson wrote:
> Hey,
> Thanks for the patch. I got log output but I had two clients hanging
> in the same way with the attached patch.
>
> $ patch -p0 < stat.patch
> patching file b/stat.c
> patching file b/stat.h
> Hunk #1 succeeded at 213 (offset -5 lines).
>
> I was using --output <filename>
>
> Worth mentioning here is that on the NFS server the output file is
> written to is issuing a stat(1) on the above output file once per
> second. Could it cause any prolems?

OK, so next question. If you leave it long enough, do you get "stuck 
process" dumps from the kernel? In any case, a:

# echo t > /proc/sysrq-trigger

dump would be handy to see for all the fio processes, this doesn't smell 
like a fio issue.

-- 
Jens Axboe


