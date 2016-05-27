Return-Path: <axboe@kernel.dk>
Subject: Re: problem with fio --client and latency logs
References: <1119349874.66202652.1464289871526.JavaMail.zimbra@redhat.com>
 <57485CF7.2070308@kernel.dk> <57487D92.7070306@kernel.dk>
 <991224849.66548485.1464377361166.JavaMail.zimbra@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5748A0FA.6060607@kernel.dk>
Date: Fri, 27 May 2016 13:33:14 -0600
MIME-Version: 1.0
In-Reply-To: <991224849.66548485.1464377361166.JavaMail.zimbra@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ben England <bengland@redhat.com>
Cc: fio@vger.kernel.org, Tim Wilkinson <twilkins@redhat.com>, Andrew Theurer <atheurer@redhat.com>, John Harrigan <jharriga@redhat.com>
List-ID: <fio@vger.kernel.org>

On 05/27/2016 01:29 PM, Ben England wrote:
> it passes my simple test, I'll try it out in the large next, thx Jens.

Super, let me know if you see issues. The difference in your two tests
is that fio will compress the log on the server side, to reduce the
amount of data we have to transfer. The bug was on the compression side,
so the client only got the first chunk of partial data. That meant that
we'd have the correct number of entries in the log, but the majority of
it would be zeroes...

> This is the last commit I saw in master branch upstream just now after
> pulling into my clone:

>
> commit e35fb4c43ecc5b9d35cb5d980e811d3408fc5a4e
> Author: Jens Axboe <axboe@fb.com>
> Date:   Fri May 27 11:01:15 2016 -0600
>
>      server: ensure that we flush compressed logs correctly
>
>      Do chunkwise block compression, and flush at the end, adding more space
>      as needed.
>
>      Signed-off-by: Jens Axboe <axboe@fb.com>

Yes, that's the fix in question.

> When I run fio -h after rebuild, it shows I'm on this commit because
> last 4 hex digits of version "fio-2.11-5-ge35f" are first 4 digits of
> git commit ID, which is reassuring.

That's why I added it :-)

Most people never include the version of fio when they report a bug, at
least we'll have the version if they paste the fio output.

-- 
Jens Axboe


