Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Restore check_swd()
References: <20180927021648.28313-1-damien.lemoal@wdc.com>
 <40ca898f-febc-b403-74ec-f7df39c0bb7f@kernel.dk>
 <BN3PR0401MB1640312E62830C451665E507E7EC0@BN3PR0401MB1640.namprd04.prod.outlook.com>
 <BLUPR0401MB16361E2E31658E293C266970E7EC0@BLUPR0401MB1636.namprd04.prod.outlook.com>
 <b3169357-303b-30e2-9018-d889e53c6a97@kernel.dk>
 <1538166304.53591.6.camel@acm.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <382f413d-fb3f-6b7f-86cc-0e8dd4ffddea@kernel.dk>
Date: Fri, 28 Sep 2018 14:31:09 -0600
MIME-Version: 1.0
In-Reply-To: <1538166304.53591.6.camel@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 9/28/18 2:25 PM, Bart Van Assche wrote:
> On Fri, 2018-09-28 at 08:54 -0600, Jens Axboe wrote:
>> +	for (z = zb; z < ze; z++) {
>> +		pthread_mutex_lock(&z->mutex);
>> +		swd += z->wp - z->start;
>> +	}
>> +	pthread_mutex_lock(&f->zbd_info->mutex);
>>
>> Can 'z' ever end up being f->zbd_info? That would surely explain the
>> deadlock.
> 
> Hi Jens,
> 
> f->zbd_info and z have a different type so unless something very weird is going
> on &z->mutex can't be identical to &f->zbd_info->mutex.

Obviously I didn't look too closely :-)

> What I think is going on is traditional lock inversion: check_swd() triggers
> lock inversion if it is called while any of the z->mutex objects are held. One
> such mutex is held where Damien tried to restore the calls of this function. I
> will submit a patch that inserts these calls elsewhere.

That makes sense.

-- 
Jens Axboe


