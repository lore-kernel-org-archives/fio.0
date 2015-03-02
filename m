Return-Path: <axboe@kernel.dk>
Message-ID: <54F4BD49.9040806@kernel.dk>
Date: Mon, 02 Mar 2015 12:43:05 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: diskutil output explained
References: <CAA6fs6=Dj+ZbCJ2vRSLBy6u+C2TdJZV1neq2PZBFfVuC7kwVWQ@mail.gmail.com>
In-Reply-To: <CAA6fs6=Dj+ZbCJ2vRSLBy6u+C2TdJZV1neq2PZBFfVuC7kwVWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Georgios Koloventzos <g.koloventzos@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/27/2015 06:19 PM, Georgios Koloventzos wrote:
> Hello,
>
> I am running fio to test some virtual machines of mine and I am having some
> difficulties.
> So my question as it is written on the subject.
> What exactly are the output of the --debug=diskutil command?
> I have seen the code of diskutil.c but I will like a bit more
> explanatory answer.

As the option hints at, it's just debug output. Mostly deals with how it 
resolves md/dm devices to the underlying devices, and so forth. So not 
sure there's that much interesting there to you, unless you are trying 
to debug a problem with it.

In general, fio figures out what devices to monitor, and then 
continually opens the stat files and collects the appropriate 
information every 250msecs.

-- 
Jens Axboe


