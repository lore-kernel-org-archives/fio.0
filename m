Return-Path: <axboe@kernel.dk>
Subject: Re: what is the sample logger doing when the buffer fills up?
References: <CAF+0mvnTM6Rv3Vh1oOZd=9TQ1wVtWWrHMVkbKxdisufiYvZ0Zw@mail.gmail.com>
 <BN3PR0401MB1457463C7131E975F7ED0812F7370@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAJ9yE1CkoXrkK2PowRkSyby6zbb+ngWFAD-AariWcp64FNTZNw@mail.gmail.com>
 <BN3PR0401MB145725E84C509D7F14BC2C2FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <BN3PR0401MB14573F44F190D9B11CCF836FF7080@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <805ada82-a3be-5b0f-226c-258d7e6f7711@kernel.dk>
 <CAJ9yE1CXNBvGFnJ1FNnodRKanXrqMgEfJsBrCz1dXBcNq4Qwxg@mail.gmail.com>
 <BN3PR0401MB1457787C3D5632BD79FFFC5BF7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CAJ9yE1AYiuwX2tZbybqQw25YtGC8U40_JRz_iFQWypei_EVcMg@mail.gmail.com>
 <BN3PR0401MB1457883E34BC695500DEAF57F7090@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <20160722144702.GA7328@kernel.dk>
 <87c24164-a129-c6cd-b9bf-49ae52f7034f@kernel.dk>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <39517e39-daeb-29ed-a4e3-8d5e759d9382@kernel.dk>
Date: Fri, 22 Jul 2016 12:37:10 -0600
MIME-Version: 1.0
In-Reply-To: <87c24164-a129-c6cd-b9bf-49ae52f7034f@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>
Cc: Karl Cronburg <kcronbur@redhat.com>, Matthew Eaton <m.eaton82@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/22/2016 09:55 AM, Jens Axboe wrote:
> Actually, I think it's missing one more thing. Try the attached v2
> instead. Karl, you mentioned the iops = 0 trick. I don't think that's
> the right fix, but I think you were getting close. I suspect that we
> sometimes wake up a little early. Let's say we want to log the 6000
> entry, but we wake up at 5999 instead. We add the regular stat sample,
> and clear interval. But we don't add the averaged log entry, since the
> time hasn't passed yet, we're missing 1 msec. Hence when we do wake up
> 1msec later, spent/iops will be zero. You're continue adds the log
> entry, but misses the data.

I'm feeling good about this change, so I committed it:

http://git.kernel.dk/cgit/fio/commit/?id=d454a205f81e1b122020cb4fb469c5a0c9d3195f

So just test current -git, would love to hear if it fixes the issue for 
you guys.

-- 
Jens Axboe


