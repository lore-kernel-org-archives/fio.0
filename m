Return-Path: <krish.reddy@samsung.com>
Date: Fri, 3 Jul 2020 16:07:46 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 3/4] iouring: support for Zone Append command
Message-ID: <20200703103746.GC27933@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB375159898F07C71C4870DE63E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: multipart/mixed;
	boundary="----O02wVW_TA_CRdKetSaQOVhdyQBrcCciqckW4gUYQTxE5eUA6=_c6f09_"
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
	<CGME20200625174131epcas5p36cf7cd413dcb698f117474df71e5648b@epcas5p3.samsung.com>
	<1593106733-19596-4-git-send-email-krish.reddy@samsung.com>
	<CY4PR04MB375159898F07C71C4870DE63E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

------O02wVW_TA_CRdKetSaQOVhdyQBrcCciqckW4gUYQTxE5eUA6=_c6f09_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jun 26, 2020 at 05:43:27AM +0000, Damien Le Moal wrote:
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
>>  engines/io_uring.c | 23 ++++++++++++++++++++++-
>>  1 file changed, 22 insertions(+), 1 deletion(-)
>>
>> diff --git a/engines/io_uring.c b/engines/io_uring.c
>> index cd0810f..cb7c5ba 100644
>> --- a/engines/io_uring.c
>> +++ b/engines/io_uring.c
>> @@ -251,7 +251,13 @@ static int fio_ioring_prep(struct thread_data *td, struct io_u *io_u)
>>  			sqe->ioprio = td->o.ioprio_class << 13;
>>  		if (ld->ioprio_set)
>>  			sqe->ioprio |= td->o.ioprio;
>> -		sqe->off = io_u->offset;
>> +		if (td->o.zone_append && io_u->ddir == DDIR_WRITE)
>> +			sqe->rw_flags |= RWF_ZONE_APPEND;
>> +		if ((td->o.zone_mode == ZONE_MODE_ZBD)
>> +		     && td->o.zone_append && io_u->ddir == DDIR_WRITE) {
>> +			sqe->off = io_u->zone_start_offset;
>> +		} else
>> +			sqe->off = io_u->offset;
>
>Why test twice "td->o.zone_append && io_u->ddir == DDIR_WRITE" ? this can be
>rewritten to not have to test this 2 times:
>
>		if (td->o.zone_append && io_u->ddir == DDIR_WRITE) {
>			sqe->rw_flags |= RWF_ZONE_APPEND;
>			if (td->o.zone_mode == ZONE_MODE_ZBD)
>				sqe->off = io_u->zone_start_offset;
>			else
>				sqe->off = io_u->offset;
>		}
>
>And fix the start offset as already commented, using io_u->offset and
>td->o.zone_size.
>
Sure, will remove the dual check and fix the start offset as per your
comments

>>  	} else if (ddir_sync(io_u->ddir)) {
>>  		if (io_u->ddir == DDIR_SYNC_FILE_RANGE) {
>>  			sqe->off = f->first_write;
>> @@ -324,6 +330,21 @@ static int fio_ioring_getevents(struct thread_data *td, unsigned int min,
>>  	ld->cq_ring_off = *ring->head;
>>  	do {
>>  		r = fio_ioring_cqring_reap(td, events, max);
>> +		if (td->o.zone_mode == ZONE_MODE_ZBD) {
>> +			struct io_uring_cqe *cqe;
>> +			struct io_u *io_u;
>> +			unsigned index;
>
>need blank line.
>
Ok

>> +			for (unsigned event = 0; event < r; event++) {
>> +				index = (event + ld->cq_ring_off) & ld->cq_ring_mask;
>> +
>> +				cqe = &ld->cq_ring.cqes[index];
>> +				io_u = (struct io_u *) (uintptr_t) cqe->user_data;
>> +
>> +				if (td->o.zone_append && td->o.do_verify
>> +				    && td->o.verify && (io_u->ddir == DDIR_WRITE))
>> +					io_u->ipo->offset = io_u->zone_start_offset + (cqe->flags << 9);
>
>cqe->flags needs to be cast to 64bit or the shift could give the wrong result.
>
>Same comments as for libaio regarding structure.
>
Ok. Sure, will add that, as there are chances of overflow happening.

>> +			}
>> +		}
>>  		if (r) {
>>  			events += r;
>>  			if (actual_min != 0)
>>
>
>
>-- 
>Damien Le Moal
>Western Digital Research
>

------O02wVW_TA_CRdKetSaQOVhdyQBrcCciqckW4gUYQTxE5eUA6=_c6f09_
Content-Type: text/plain; charset="utf-8"


------O02wVW_TA_CRdKetSaQOVhdyQBrcCciqckW4gUYQTxE5eUA6=_c6f09_--

