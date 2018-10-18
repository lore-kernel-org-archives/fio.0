Return-Path: <axboe@kernel.dk>
Subject: Re: Cannot verify dedupe data, is it a bug?
References: <319f5589.a4d1.1668201794f.Coremail.feng_changyu@126.com>
 <CALjAwxiqYiErO0uh9E4oL8ub_jMQ2MDPgNiCon51s_yaWVrcUA@mail.gmail.com>
 <3cce6ba4-cfe3-1309-9852-f8cecff4131b@kernel.dk>
 <3e72c6b8.73aa.166863f1110.Coremail.feng_changyu@126.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <984e4b86-eb7e-c4e2-c99f-7f794aa7aa7f@kernel.dk>
Date: Thu, 18 Oct 2018 08:31:33 -0600
MIME-Version: 1.0
In-Reply-To: <3e72c6b8.73aa.166863f1110.Coremail.feng_changyu@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Changyu <feng_changyu@126.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/18/18 2:16 AM, Changyu wrote:
> 
> Hi Jens Axboe & Sitsofe Wheeler
> 
> 
> Thank you very much for your help.
> 
> get_io_u finally call fill_io_buffer to fill the buffer, function
> fill_io_buffer uses td->buf_state and td->buf_state_prev to generate
> duplicated data if the dedupe_percentage is set.
> 
> populate_verify_io_u finally call  fill_random_buf_percentage to fill
> the buffer, it use td->verify_state to generate random data.
> 

As I said, I'm fine with that getting unified. The only thing to keep in
mind is that for verification data, we rely on being able to re-generate
the buffer contents, as long as we have a valid verify header. This can
be used to diagnose the nature of the corruption. As long as we retain
that property, the buffer generation for verify writes should follow the
same settings as non-verify writes.

> Should I create a issue on https://github.com/axboe/fio/issues?

Sure, probably check if it's a dupe of the issue Sitsofe referenced
first.


-- 
Jens Axboe


