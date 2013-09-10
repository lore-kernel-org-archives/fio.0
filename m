Return-Path: <erwan@enovance.com>
Message-ID: <522F899D.4090605@enovance.com>
Date: Tue, 10 Sep 2013 23:05:33 +0200
From: Erwan Velu <erwan@enovance.com>
MIME-Version: 1.0
Subject: Re: A blog article presenting my work on FIO
References: <522F3BD4.80400@enovance.com> <522F639E.6020907@kernel.dk> <CAAAK+WUuorByrFOnf=ii-XMQahd7LLOfXORoKGueAOzo1qC9Fw@mail.gmail.com> <CAAAK+WWAqrZYgT9nHc8aGV6MfmG=haShUrxT6zfe9uMNS6+apw@mail.gmail.com>
In-Reply-To: <CAAAK+WWAqrZYgT9nHc8aGV6MfmG=haShUrxT6zfe9uMNS6+apw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Brian L." <brianclam@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/09/2013 22:53, Brian L. wrote:
> Nice work Erwan.
>
> I am doing something similar to what you are doing, using FIO + perl
> (to parse the data) + gnuplot.
>
> I am testing drives from multiple vendors and graphing the following
> attributes over different blocksize + io queue depth + different read /
> write pattern and % distribution:
>
> o iops
> o bandwidth
> o latency (max and avg)
>
> As an example, I am overlaying multiple drives for each attribute
> (y-axis) at fixed io queue depth over different block size (x-axis).
>
> I will look at your work.
>
>
Feel free to play with it !

That would be lovely to see people using it or extending its capabilities.
I'm sure many are doing this stuff on their own. It would be nice to 
share this work to get a very good tool that works for many.

Cheers,
Erwan

