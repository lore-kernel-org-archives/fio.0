Return-Path: <axboe@kernel.dk>
Subject: Re: Windows crash in ctime_r()
References: <f803f397a70446f98a8af0a14634cb31@bowex36a.micron.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <573A72DA.2080208@kernel.dk>
Date: Mon, 16 May 2016 19:24:42 -0600
MIME-Version: 1.0
In-Reply-To: <f803f397a70446f98a8af0a14634cb31@bowex36a.micron.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Michael Schoberg (mschoberg)" <mschoberg@micron.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/16/2016 03:50 PM, Michael Schoberg (mschoberg) wrote:
> I think I found an issue in os\windows\posix.c that results in a FIO
> crash (on Windows.)  I'm including a patch that resolves the crash for
> us, but includes another (optional) fix.  > > Crash issue:  possix.c  -
> ctime_r() will reference a negative array index on Sunday.  SYSTEMTIME
> states the days of the week as: "0=Sunday, .. , 6=Saturday."  The "fix"
> can likely be dialed back to safely assume the days/months will adhere
> to how they're documented.
>
>
> Optional - StringCchPrintfA() calls should allow for the string plus a
> NULL character.  Instead, the value getting passed in is for the entire
> string size.

Thanks, both look good, applied.

-- 
Jens Axboe


