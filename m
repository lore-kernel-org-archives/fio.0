Return-Path: <krish.reddy@samsung.com>
Date: Fri, 3 Jul 2020 16:17:48 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 2/4] libaio: support for Zone Append command
Message-ID: <20200703104748.GD27933@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB3751B98A411CC5C6B29CA442E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: multipart/mixed;
	boundary="----HLsVUhwo1NnMf0MkEybe_TfPnfOwGw2mguf7MLxPvWAMWj5A=_c6e51_"
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
	<CGME20200625174129epcas5p304bf58bb381b4b0c39e0ff91b50a23a9@epcas5p3.samsung.com>
	<1593106733-19596-3-git-send-email-krish.reddy@samsung.com>
	<CY4PR04MB3751B98A411CC5C6B29CA442E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

------HLsVUhwo1NnMf0MkEybe_TfPnfOwGw2mguf7MLxPvWAMWj5A=_c6e51_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jun 26, 2020 at 05:38:53AM +0000, Damien Le Moal wrote:
>On 2020/06/26 2:41, Krishna Kanth Reddy wrote:
>> From: Ankit Kumar <ankit.kumar@samsung.com>
>>
>> The zone append command uses the write path with offset as
>> start of the zone. Upon successful completion, multiple of
>> sectors relative to the zone's start offset, where the data
>> has been placed is returned.
>>
>> Signed-off-by: Krishna Kanth Reddy <krish.reddy@samsung.com>
>> ---
>>  engines/libaio.c | 20 +++++++++++++++++++-
>>  1 file changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/engines/libaio.c b/engines/libaio.c
>> index 398fdf9..4ffe831 100644
>> --- a/engines/libaio.c
>> +++ b/engines/libaio.c
>> @@ -123,7 +123,13 @@ static int fio_libaio_prep(struct thread_data *td, struct io_u *io_u)
>>  		if (o->nowait)
>>  			iocb->aio_rw_flags |= RWF_NOWAIT;
>>  	} else if (io_u->ddir == DDIR_WRITE) {
>> -		io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
>> +		if ((td->o.zone_mode == ZONE_MODE_ZBD) && td->o.zone_append) {
>> +			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->zone_start_offset);
>> +		}
>
>No need for the added braces. And see my comment in the previous patch about
>zone_start_offset. You can calculate it from io_u->offset.
>
Sure, will remove the braces and zone_start_offset. Offset will be
calculated as per your comments.

>> +		else
>> +			io_prep_pwrite(iocb, f->fd, io_u->xfer_buf, io_u->xfer_buflen, io_u->offset);
>> +		if (td->o.zone_append)
>> +			iocb->aio_rw_flags |= RWF_ZONE_APPEND;
>>  		if (o->nowait)
>>  			iocb->aio_rw_flags |= RWF_NOWAIT;
>>  	} else if (ddir_sync(io_u->ddir))
>> @@ -228,6 +234,18 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
>>  		} else {
>>  			r = io_getevents(ld->aio_ctx, actual_min,
>>  				max, ld->aio_events + events, lt);
>> +			if (td->o.zone_mode == ZONE_MODE_ZBD) {
>> +				struct io_event *ev;
>> +				struct io_u *io_u;
>
>Add a blank line after declarations please.
>
Sure.

>> +				for (unsigned event = 0; event < r; event++) {
>
>Better declare event above instead of here. I know C allows it, but this looks
>like C++ to me :)
>
Yeah sure :) Will modify this.

>> +					ev = ld->aio_events + event;
>> +					io_u = container_of(ev->obj, struct io_u, iocb);
>> +					if (td->o.zone_append
>> +					    && td->o.do_verify && td->o.verify
>> +					    && (io_u->ddir == DDIR_WRITE))
>
>So this is done only if verify is on ? Then why do the loop at all if verify is
>off ? Move the "td->o.zone_append && td->o.do_verify && td->o.verify" condition
>outside the loop.
>
Yes, right. Will move this outside the loop.

>> +						io_u->ipo->offset = io_u->zone_start_offset + (ev->res2 << 9);
>
>same here about start offset.
>
Ok, sure.

>> +				}
>> +			}
>>  		}
>>  		if (r > 0)
>>  			events += r;
>>
>
>
>-- 
>Damien Le Moal
>Western Digital Research
>

------HLsVUhwo1NnMf0MkEybe_TfPnfOwGw2mguf7MLxPvWAMWj5A=_c6e51_
Content-Type: text/plain; charset="utf-8"


------HLsVUhwo1NnMf0MkEybe_TfPnfOwGw2mguf7MLxPvWAMWj5A=_c6e51_--

