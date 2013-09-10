Return-Path: <brianclam@gmail.com>
MIME-Version: 1.0
In-Reply-To: <522F899D.4090605@enovance.com>
References: <522F3BD4.80400@enovance.com> <522F639E.6020907@kernel.dk>
 <CAAAK+WUuorByrFOnf=ii-XMQahd7LLOfXORoKGueAOzo1qC9Fw@mail.gmail.com>
 <CAAAK+WWAqrZYgT9nHc8aGV6MfmG=haShUrxT6zfe9uMNS6+apw@mail.gmail.com> <522F899D.4090605@enovance.com>
From: "Brian L." <brianclam@gmail.com>
Date: Tue, 10 Sep 2013 15:04:41 -0700
Message-ID: <CAAAK+WVT47MLYgYCjA9meOPcoNpwgnmWJ94PGuS-EkGFvhy4aw@mail.gmail.com>
Subject: Re: A blog article presenting my work on FIO
Content-Type: text/plain; charset=ISO-8859-1
To: Erwan Velu <erwan@enovance.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Tue, Sep 10, 2013 at 2:05 PM, Erwan Velu <erwan@enovance.com> wrote:
> On 10/09/2013 22:53, Brian L. wrote:
>>
>> Nice work Erwan.
>>
>> I am doing something similar to what you are doing, using FIO + perl
>> (to parse the data) + gnuplot.
>>
>> I am testing drives from multiple vendors and graphing the following
>> attributes over different blocksize + io queue depth + different read /
>> write pattern and % distribution:
>>
>> o iops
>> o bandwidth
>> o latency (max and avg)
>>
>> As an example, I am overlaying multiple drives for each attribute
>> (y-axis) at fixed io queue depth over different block size (x-axis).
>>
>> I will look at your work.
>>
>>
> Feel free to play with it !
>
> That would be lovely to see people using it or extending its capabilities.
> I'm sure many are doing this stuff on their own. It would be nice to share
> this work to get a very good tool that works for many.

Definitely, I will see what I can contribute as I am very new at fio,
just using a couple of weeks ago.  Let see how that goes - it will be
really first open source project.  :)

I wish I knew your project sooner.  I think I would have save quite a
bit of effort.  At this pt, I think I am locked in my path because of
deadline.

>
> Cheers,
> Erwan

