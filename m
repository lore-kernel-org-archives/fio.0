Return-Path: <krish.reddy@samsung.com>
Date: Fri, 3 Jul 2020 14:39:14 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 4/4] t/zbd: Add support to verify Zone Append command
 with libaio, io_uring IO engine tests
Message-ID: <20200703090914.GB27933@test-zns>
MIME-Version: 1.0
In-Reply-To: <CY4PR04MB375109E8E368191896248011E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
Content-Type: multipart/mixed;
	boundary="----FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_c6213_"
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
	<CGME20200625174133epcas5p1eace8f03319bee805b93c50fe6c690c7@epcas5p1.samsung.com>
	<1593106733-19596-5-git-send-email-krish.reddy@samsung.com>
	<CY4PR04MB375109E8E368191896248011E7930@CY4PR04MB3751.namprd04.prod.outlook.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>
List-ID: <fio@vger.kernel.org>

------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_c6213_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Jun 26, 2020 at 05:45:49AM +0000, Damien Le Moal wrote:
>On 2020/06/26 2:41, Krishna Kanth Reddy wrote:
>> Modify the test-zbd-support script to verify the Zone Append command
>> for NVMe Zoned Namespaces (ZNS) defined in NVM Express TP4053.
>> Added a new FIO option zone_append.
>> When zone_append option is enabled, the existing write path will
>> send Zone Append command with LBA offset as start of the Zone.
>>
>> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
>> ---
>>  t/zbd/test-zbd-support | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 48 insertions(+)
>>
>> diff --git a/t/zbd/test-zbd-support b/t/zbd/test-zbd-support
>> index 4001be3..ddade22 100755
>> --- a/t/zbd/test-zbd-support
>> +++ b/t/zbd/test-zbd-support
>> @@ -801,6 +801,54 @@ test48() {
>>  	    >> "${logfile}.${test_number}" 2>&1 || return $?
>>  }
>>
>> +# Zone append to sequential zones, libaio, 1 job, queue depth 1
>> +test49() {
>> +    local i size
>> +
>> +    size=$((4 * zone_size))
>> +    run_fio_on_seq --ioengine=libaio --iodepth=1 --rw=write --zone_append=1 \
>> +                   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
>> +                   --do_verify=1 --verify=md5                           \
>> +                   >>"${logfile}.${test_number}" 2>&1 || return $?
>> +    check_written $size || return $?
>> +    check_read $size || return $?
>> +}
>> +
>> +# Random zone append to sequential zones, libaio, 8 jobs, queue depth 64 per job
>> +test50() {
>> +    local size
>> +
>> +    size=$((4 * zone_size))
>> +    run_fio_on_seq --ioengine=libaio --iodepth=64 --rw=randwrite --bs=4K \
>> +                   --group_reporting=1 --numjobs=8 --zone_append=1 \
>> +                   >> "${logfile}.${test_number}" 2>&1 || return $?
>> +    check_written $((size * 8)) || return $?
>> +}
>> +
>> +# Zone append to sequential zones, io_uring, 1 job, queue depth 1
>> +test51() {
>> +    local i size
>> +
>> +    size=$((4 * zone_size))
>> +    run_fio_on_seq --ioengine=io_uring --iodepth=1 --rw=write --zone_append=1 \
>> +                   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
>> +                   --do_verify=1 --verify=md5                           \
>> +                   >>"${logfile}.${test_number}" 2>&1 || return $?
>> +    check_written $size || return $?
>> +    check_read $size || return $?
>> +}
>> +
>> +# Random zone append to sequential zones, io_uring, 8 jobs, queue depth 64 per job
>> +test52() {
>> +    local size
>> +
>> +    size=$((4 * zone_size))
>> +    run_fio_on_seq --ioengine=io_uring --iodepth=64 --rw=randwrite --bs=4K \
>> +                   --group_reporting=1 --numjobs=8 --zone_append=1 \
>> +                   >> "${logfile}.${test_number}" 2>&1 || return $?
>> +    check_written $((size * 8)) || return $?
>> +}
>> +
>>  tests=()
>>  dynamic_analyzer=()
>>  reset_all_zones=
>>
>
>If the test script was called using an SG node with -l option for libzbc tests,
>these tests will fail. Please add conditions to not run them when they cannot.
>
Sure, we will add the conditions to not execute tests in such cases.

>
>-- 
>Damien Le Moal
>Western Digital Research
>

------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_c6213_
Content-Type: text/plain; charset="utf-8"


------FBC7EIImzEv-3WQrgwRbJYn4xAlwhlhWWV1zALX9mq8rjZSB=_c6213_--

