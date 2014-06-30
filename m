Return-Path: <axboe@kernel.dk>
Message-ID: <53B1DBB8.4080901@kernel.dk>
Date: Mon, 30 Jun 2014 15:50:48 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Log offsets of I/O operations
References: <87pphr7g5d.fsf@gmail.com>
In-Reply-To: <87pphr7g5d.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Abutalib Aghayev <agayev@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-06-29 11:43, Abutalib Aghayev wrote:
>
> This is a quick and dirty patch to log offsets of I/O operations as
> well.  It is useful if you would like to make offset vs latency plot for
> random I/O, which may not be interesting to many people, so feel free to
> ignore it.

I can definitely see this being useful. But adding 8 bytes to every log 
entry complicates things, as fio is already memory intensive there when 
logging longer runs.

I'd suggest having two logging types:

struct io_sample {
           uint64_t time;
           uint64_t val;
           uint32_t ddir;
           uint32_t bs;
           uint64_t offset;
};

struct io_sample_offset {
           struct io_sample s;
           uint64_t offset;
};

and using the right type for what you are logging. This means you'd need 
an option to switch on the offset logging, and that you'd need to store 
this in the iolog struct (whether to log offset or not) and use the 
appropriate size for allocating and extending the log entries when needed.

Make sense?

-- 
Jens Axboe


