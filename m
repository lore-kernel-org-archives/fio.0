Return-Path: <axboe@kernel.dk>
Subject: Re: systemd-udevd triggered?
References: <CALjAwxj+KoD2ipRH5=+08Xb9KyKonX9NX-QAPvBkwvHSRux2Hw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <fc6c1128-bbef-ad19-8888-485aa0d2c842@kernel.dk>
Date: Thu, 22 Jun 2017 14:14:47 -0600
MIME-Version: 1.0
In-Reply-To: <CALjAwxj+KoD2ipRH5=+08Xb9KyKonX9NX-QAPvBkwvHSRux2Hw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, Tarek <cashew250@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/14/2017 12:33 AM, Sitsofe Wheeler wrote:
> On 31 March 2017 at 18:34, Tarek <cashew250@gmail.com> wrote:
>> As an aside to the thread I have going about 0 clat min
>>
>> Why am I seeing udev events in the BTT summary? Why is systemd-udevd
>> generating anything when fio is ran?
>>
>> Q2C           MIN           AVG           MAX           N
>> --------------- ------------- ------------- ------------- -----------
>> fio               0.000017381   0.000018851   0.000077907      436012
>> systemd-udevd     0.000012019   0.000150024   0.000481010          76
> 
> Ulp, you dropped the CC to the mailing list so this disappeared into a
> different mailbox that I didn't see until now. Please send fio
> questions to the fio mailing list rather than only me directly.
> Thanks!
> 
> I'm not sure but perhaps you "inserted" the disk afresh or changed the
> sectors where a partition table lives? It could be the case this can
> trigger other tools to initiate a rescan to see if new partitions have
> arrived and other tasks in turn need to be triggered...

Just a guess, but if you are doing a write of any kind, fio will
(naturally) open the device read/write. On some systems, this can
trigger a partition scan of the device.


-- 
Jens Axboe


