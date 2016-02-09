Return-Path: <axboe@kernel.dk>
Subject: Re: output_format=terse,json core dumping
References: <loom.20160209T200431-709@post.gmane.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56BA4A05.7010300@kernel.dk>
Date: Tue, 9 Feb 2016 13:20:21 -0700
MIME-Version: 1.0
In-Reply-To: <loom.20160209T200431-709@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Kurt Dorsey <Kurt_Dorsey@Dell.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/09/2016 12:12 PM, Kurt Dorsey wrote:
> I am trying to get multiple output formats working with fio and I am
> getting a core dump
> fio: diskutil.c:710: show_disk_util: Assertion `parent' failed.
> Aborted (core dumped)
>
> I am utilizing format from
> commit a666cab8ed3d2a2fa782be345425a2e88734a007
> Author: Jens Axboe <axboe@fb.com>
> Date:   Tue Oct 27 13:45:21 2015 +0900
>
>      Enable the use of multiple output formats
>
>      You can now do
>
>      ./fio --output-format=normal,json jobfile.fio
>
>      and get both types of output.
>
>      Signed-off-by: Jens Axboe <axboe@fb.com>
>
>
> fio -v
> fio-2.6-10-g820b
>
>
>
> fio --ioengine=libaio --buffered=0 --direct=1 --norandommap --name=test
> --filename=/dev/sdb --iodepth=32  --ba=4k --rw=randrw --rwmixwrite=65 --
> bs=8K --numjobs=1 --runtime=10 --ramp_time=0 --time_based --output-
> format=terse,json
>
> I have also tried
> --format=normal,json and I get the same issue
>
>
> --output-format=normal,terse
> Works just fine but I really would like to have json output along with
> terse.
>
>
> Is there a workaround to get both terse and json (or json+)?

This should fix it:

http://git.kernel.dk/cgit/fio/commit/?id=6efb21c218d4ec38c1a4d7dbb86f2028f122acaa

Update to latest -git and test, let me know how it goes.

-- 
Jens Axboe


