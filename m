Return-Path: <brianclam@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAAAK+WUuorByrFOnf=ii-XMQahd7LLOfXORoKGueAOzo1qC9Fw@mail.gmail.com>
References: <522F3BD4.80400@enovance.com> <522F639E.6020907@kernel.dk> <CAAAK+WUuorByrFOnf=ii-XMQahd7LLOfXORoKGueAOzo1qC9Fw@mail.gmail.com>
From: "Brian L." <brianclam@gmail.com>
Date: Tue, 10 Sep 2013 13:53:08 -0700
Message-ID: <CAAAK+WWAqrZYgT9nHc8aGV6MfmG=haShUrxT6zfe9uMNS6+apw@mail.gmail.com>
Subject: Re: A blog article presenting my work on FIO
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: Erwan Velu <erwan@enovance.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Nice work Erwan.

I am doing something similar to what you are doing, using FIO + perl
(to parse the data) + gnuplot.

I am testing drives from multiple vendors and graphing the following
attributes over different blocksize + io queue depth + different read /
write pattern and % distribution:

o iops
o bandwidth
o latency (max and avg)

As an example, I am overlaying multiple drives for each attribute
(y-axis) at fixed io queue depth over different block size (x-axis).

I will look at your work.

Brian

Resending using plain text...  Hopefully, this works.

