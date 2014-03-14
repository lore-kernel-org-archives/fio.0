Return-Path: <axboe@kernel.dk>
Message-ID: <532349BF.4010307@kernel.dk>
Date: Fri, 14 Mar 2014 12:26:07 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Possible bug when setting compression
References: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>
In-Reply-To: <CAF+0mvm1bjy99fbM_jkr9Sp7bbgnQSpr3WkeZ7Zgju9hFdNaSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Eaton <m.eaton82@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 03/14/2014 09:52 AM, Matthew Eaton wrote:
> I have been testing iops performance using different compression
> settings and found that setting either zero_buffers or
> buffer_compress_percentage was not enough, I had to also set
> scramble_buffers=0 in order to get the desired compression.  But this
> was not the case when setting refill_buffers.  I tested with fio 2.1.5
> and fio from git (fio-2.1.6.1-10-g4e59d).

Interesting, it would make sense to simply not scramble if the 
compression settings are set. That is what happens with refill_buffers 
right now, it has precedence over the scrambling. Or if you give a 
buffer pattern, that also disables the scrambling. I'll add the same for 
the compression settings.

http://git.kernel.dk/?p=fio.git;a=commit;h=0574c885b82aea0332ab5fa35af84db0f3946726

Care to give it a test spin, just to be on the safe side?

-- 
Jens Axboe


