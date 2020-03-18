Return-Path: <prvs=33927013d=Damien.LeMoal@wdc.com>
From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 0/6] Fix zone lock deadlock
Date: Wed, 18 Mar 2020 02:00:32 +0000
Message-ID: 
 <CO2PR04MB2343A4F193A769DE229D683EE7F70@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200228071248.3981623-1-naohiro.aota@wdc.com>
 <20200317025007.4zjark6b5ywea4v7@naota.dhcp.fujisawa.hgst.com>
 <dc8ad84c-2439-7df0-e02d-ce200068e7c8@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, Naohiro Aota <Naohiro.Aota@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2020/03/18 10:49, Jens Axboe wrote:=0A=
> On 3/16/20 8:50 PM, Naohiro Aota wrote:=0A=
>> On Fri, Feb 28, 2020 at 04:12:42PM +0900, Naohiro Aota wrote:=0A=
>>> With zonemode=3Dzbd and asynchronous ioengine, a thread takes a zone lo=
ck=0A=
>>> before an I/O submission (in zbd_adjust_block() or=0A=
>>> zbd_convert_to_open_zone()) and releases the lock after the I/O is put =
(in=0A=
>>> zbd_put_io()).  With a small number of open zones and/or a large number=
 of=0A=
>>> jobs, threads can easily end up circular lock dependency and deadlocks.=
 For=0A=
>>> example, thread A sends an I/O to zone 0, so thread A holds a zone lock=
 #0.=0A=
>>> Then, thread A continues on zone 1 and try to acquire zone lock #1. At =
the=0A=
>>> same time, thread B held zone lock #1, sent I/O to zone 1, and try to=
=0A=
>>> acquire zone #0. Now, both threads are waiting for each other's lock, w=
hich=0A=
>>> is never released.=0A=
>>>=0A=
>>> This series fixes three problems to eliminate the deadlock. First, taki=
ng=0A=
>>> all the zone locks should be avoided. zbd_process_swd() and=0A=
>>> zbd_reset_zones() take the lock for all zones of the specified device,=
=0A=
>>> preventing other threads from accessing different zones in parallel. Wh=
ile=0A=
>>> it is not the root cause of the deadlock, such all zone locking easily=
=0A=
>>> trigger a deadlock. So, this series reduces such contentions by (1)=0A=
>>> eliminating unnecessary invocation of zbd_process_swd() and (2) changin=
g to=0A=
>>> take single zone at at time in zbd_reset_zones().=0A=
>>>=0A=
>>> Secondly, zbd's I/O issuing path should expect lock contention with oth=
er=0A=
>>> threads and handle the case properly. Commit 6f0c608564c3 ("zbd: Avoid=
=0A=
>>> async I/O multi-job workload deadlock") also addressed this issue by us=
ing=0A=
>>> pthread_mutex_try_lock() and io_u_quiesce(). However, there are more=0A=
>>> pthread_mutex_lock() left to be fixed in the same way.=0A=
>>>=0A=
>>> Finally, fio should clean up I/Os properly on an error case. Currently,=
=0A=
>>> cleanup_pending_aio() and io_u_quiesce() fail to clean up I/Os with an=
=0A=
>>> error. As a result, zone locks, which are held by an erroneous thread, =
are=0A=
>>> kept held and blocks other threads to acquire the locks.=0A=
>>>=0A=
>>> This series also add a test case to cause the deadlock with unpatched f=
io.=0A=
>>>=0A=
>>> Patches 1 and 2 avoid long range lock holding to reduce lock contention=
s.=0A=
>>>=0A=
>>> Patch 3 introduces zone_lock and use it to handle the lock contention c=
ase.=0A=
>>>=0A=
>>> Patches 4 and 5 fix error path to clean up all the pending I/Os left.=
=0A=
>>>=0A=
>>> Patch 6 adds the test.=0A=
>>>=0A=
>>> Naohiro Aota (6):=0A=
>>>  zbd: avoid initializing swd when unnecessary=0A=
>>>  zbd: reset one zone at a time=0A=
>>>  zbd: use zone_lock to lock a zone=0A=
>>>  backend: always clean up pending aios=0A=
>>>  io_u: ensure io_u_quiesce() to process all the IOs=0A=
>>>  zbd: add test for stressing zone locking=0A=
>>>=0A=
>>> backend.c              |  5 ---=0A=
>>> io_u.c                 |  6 +--=0A=
>>> t/zbd/test-zbd-support | 30 +++++++++++++++=0A=
>>> zbd.c                  | 84 ++++++++++++++++--------------------------=
=0A=
>>> 4 files changed, 65 insertions(+), 60 deletions(-)=0A=
>>>=0A=
>>> -- =0A=
>>> 2.25.1=0A=
>>=0A=
>> Ping on this series (also on this=0A=
>> https://www.spinics.net/lists/fio/msg08322.html ).=0A=
> =0A=
> Damien, can you take a look please?=0A=
> =0A=
=0A=
My apologies. I should have sent a reviewed-by tag earlier.=0A=
I worked on these with Naohiro (who did all the heavy lifting).=0A=
Tested too and at least for SMR disks workloads, no problems detected.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
Tested-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=

