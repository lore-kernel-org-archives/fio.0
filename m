Return-Path: <axboe@kernel.dk>
Subject: Re: IO merge in engine
References: <599D12BD-A1A9-42D7-ADE1-70ADACA9E177@orange.fr>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <560EA9C4.6010402@kernel.dk>
Date: Fri, 2 Oct 2015 17:59:00 +0200
MIME-Version: 1.0
In-Reply-To: <599D12BD-A1A9-42D7-ADE1-70ADACA9E177@orange.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Fabrice Bacchella <fabrice.bacchella@orange.fr>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 10/02/2015 04:04 PM, Fabrice Bacchella wrote:
> When writing my new hdfs engine, I met a problem with IO merge.
>
> If I submit IO that are bigger that what the hdfs can manage, I return them to fio as incomplete IO, the net engine works the same way :
> in engines/net.c, line 668+
> 			io_u->resid = io_u->xfer_buflen - ret;
> 			io_u->error = 0;
> 			return FIO_Q_COMPLETED;
>
> But the fio count them as two or more fast IO. I'm not sure it's a good measurement because if I'm simulating an application with fio, I expect to get the full IO latency and operations/s count. I don't mesure to mesure sub-io for that. For example, reducing the maximum transfer size will increase IO/s and reduce latency, even if the simulated application really sees reduced performance, because more of it's high level IO operation generated more real IO.
>
> Is there a way to prevent that in fio, or is that up to my engine to manage that and merge IO ?--

It sounds like a bug in the fio accounting, for the case of short 
reads/writes. That doesn't happen very often elsewhere, so not 
unreasonable to expect that is the case. Feel free to poke around and 
figure it out. Let me know if that doesn't work out, and I'll take a 
stab at fixing it up.

-- 
Jens Axboe


