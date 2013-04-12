Return-Path: <gavin_martin@xyratex.com>
MIME-Version: 1.0
In-Reply-To: <20130412111318.GP12244@kernel.dk>
References: <CANUChTygO-6HnaDU+eufAAtJoGCn9J0UgcEd16+7dgeOXa-92Q@mail.gmail.com>
 <20130412081324.GL12244@kernel.dk> <CANUChTysujbj-TQR3MK8_CErA68sVP=H9-+3TXri4S4v5Zs9ZA@mail.gmail.com>
 <20130412084236.GM12244@kernel.dk> <CANUChTzQ8yhoyD5v8ZetpqDe_9TWmskeR=wi_o4nYHLSUb8Puw@mail.gmail.com>
 <20130412094630.GO12244@kernel.dk> <20130412111318.GP12244@kernel.dk>
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Fri, 12 Apr 2013 12:31:49 +0100
Message-ID: <CANUChTxzB1TshHFZ5dgbNiG-8sWR2xLQabosrGaOBzQTmc8TJw@mail.gmail.com>
Subject: Re: Unable to Configure latest build
Content-Type: text/plain; charset=US-ASCII
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12 April 2013 12:13, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, Apr 12 2013, Jens Axboe wrote:
>> But sounds like it would be a good idea to turn zlib into a soft
>> requirement.
>
> The below does that, I have committed it. Please test.
>
>
> diff --git a/client.c b/client.c
> index eb695ff..13e84f6 100644
> --- a/client.c
> +++ b/client.c

Hi Jens,

Tested the above (with ./configure) and it does work now without the
zlib-devel package installed.  Don't you need that if the
--enable-gfio argument is used?  Just as a quick test I ran
./configure --enable-gfio, and it didn't fail because of not finding
zlib?

Sorry to be a pain, I'm not sure if it was just my install or if
others would have the same problem?

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------

