Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] zbd: Restore check_swd()
References: <20180927021648.28313-1-damien.lemoal@wdc.com>
 <40ca898f-febc-b403-74ec-f7df39c0bb7f@kernel.dk>
 <BN3PR0401MB1640312E62830C451665E507E7EC0@BN3PR0401MB1640.namprd04.prod.outlook.com>
 <BLUPR0401MB16361E2E31658E293C266970E7EC0@BLUPR0401MB1636.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b3169357-303b-30e2-9018-d889e53c6a97@kernel.dk>
Date: Fri, 28 Sep 2018 08:54:12 -0600
MIME-Version: 1.0
In-Reply-To: <BLUPR0401MB16361E2E31658E293C266970E7EC0@BLUPR0401MB1636.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

On 9/27/18 11:48 PM, Damien Le Moal wrote:
> Jens,
> 
> On 2018/09/28 13:04, Damien Le Moal wrote:
>> Jens,
>>
>> On 2018/09/28 12:53, Jens Axboe wrote:
>>> On 9/26/18 8:16 PM, Damien Le Moal wrote:
>>>> As check_swd() is useful for debugging, revert its removal done with
>>>> commit d60be7d51cbb ("zbd: Remove unused function and variable").
>>>
>>> The problem with dead code is that it's often forgotten when
>>> other changes are made, and then it doesn't even compile or
>>> work anymore.
>>>
>>> I'd be happier if this was dependent on some debug static
>>> bool instead, ala:
>>>
>>> static bool zbd_debug;
>>>
>>> And then have check_swd() do
>>>
>>> if (!zbd_debug)
>>>     return;
>>>
>>> instead of hiding everything behind an #if 0.
>>
>> OK. No problem. I will update and send a v2.
>>
>> (and another patch to fix the incorrect comments signaled by Bart)
>>
>> Thanks !
> 
> Not sending a fix after all: with check_swd() enabled, I am getting a deadlock
> between check_swd() and zbd_file_reset() on a zone mutex in test 29 when running
> against regular nullb.
> 
> That needs to be investigated. But I do not have the time to do so right away.
> 
> Bart,
> 
> If you can, please also look at it ? I do not see anything obviously wrong. It
> may be a very subtle race.

+	for (z = zb; z < ze; z++) {
+		pthread_mutex_lock(&z->mutex);
+		swd += z->wp - z->start;
+	}
+	pthread_mutex_lock(&f->zbd_info->mutex);

Can 'z' ever end up being f->zbd_info? That would surely explain the
deadlock.

-- 
Jens Axboe


