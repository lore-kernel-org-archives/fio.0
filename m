Return-Path: <axboe@kernel.dk>
Message-ID: <55612636.4000504@kernel.dk>
Date: Sat, 23 May 2015 19:15:34 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Testing write master and multiple read clients on NFS share
References: <55551D18.2000405@micxer.de>	<CALjAwxgWOokmtXWtN3GvZnvNoC-FTCJX=c3xFiuH5PrB97_kBw@mail.gmail.com>	<55590055.1080005@micxer.de> <CALjAwxjze_LWfTgp=PTn3uOfYwF_cUq3uDZoB1Q8QffCwpdojQ@mail.gmail.com> <555C752C.20806@micxer.de>
In-Reply-To: <555C752C.20806@micxer.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Michael Weinrich <micxer@micxer.de>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/20/2015 05:51 AM, Michael Weinrich wrote:
> Yeah, well, I needed a process that writes to the same files the others
> are reading from to somehow simulate expiring local caches (and to see,
> if NFS handles that the right way). And yes, it took me quite some time
> to dig through most of the options to tailor the tests to my needs
>
> But I'm also glad to hear, that it doesn't look completely wrong for a
> first try :-)

I think it looks very reasonable. I'd like to include your job file in 
the examples/ directory, if that's OK with you.

In general, I'd love to have a richer repository of job files included 
(or available, at least). It's much easier for new users to find 
something roughly like what they want and then modify it, than it is to 
start from scratch.

-- 
Jens Axboe


