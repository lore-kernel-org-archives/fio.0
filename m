Return-Path: <krish.reddy@samsung.com>
Date: Fri, 3 Jul 2020 14:16:18 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 4/4] t/zbd: Add support to verify Zone Append command
 with libaio, io_uring IO engine tests
Message-ID: <20200703084618.GA27933@test-zns>
MIME-Version: 1.0
In-Reply-To: <MN2PR04MB5951416AEA2856F350725EF8E1920@MN2PR04MB5951.namprd04.prod.outlook.com>
Content-Type: multipart/mixed;
	boundary="----LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_c65c1_"
References: <1593106733-19596-1-git-send-email-krish.reddy@samsung.com>
	<CGME20200625174133epcas5p1eace8f03319bee805b93c50fe6c690c7@epcas5p1.samsung.com>
	<1593106733-19596-5-git-send-email-krish.reddy@samsung.com>
	<MN2PR04MB5951416AEA2856F350725EF8E1920@MN2PR04MB5951.namprd04.prod.outlook.com>
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Ankit Kumar <ankit.kumar@samsung.com>, Damien Le Moal <Damien.LeMoal@wdc.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
List-ID: <fio@vger.kernel.org>

------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_c65c1_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, Jun 25, 2020 at 06:44:19PM +0000, Dmitry Fomichev wrote:
>Will these tests succeed if t/zbd/test-zbd-support script is run against an SMR HDD?
>Since zoned HDDs don't support Zone Append, I would expect the i/o to fail.
>I think you need to check if this device is an NVMe drive and expect the i/o failure in
>the tests below if this is not the case.
>
>More inline...
>
No, these tests fail for SMR HDD.
We will modify the script to run these tests only for NVMe drives.

>> -----Original Message-----
>> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
>> Of Krishna Kanth Reddy
>> Sent: Thursday, June 25, 2020 1:39 PM
>> To: axboe@kernel.dk
>> Cc: fio@vger.kernel.org; Krishna Kanth Reddy <krish.reddy@samsung.com>;
>> Ankit Kumar <ankit.kumar@samsung.com>
>> Subject: [PATCH 4/4] t/zbd: Add support to verify Zone Append command
>> with libaio, io_uring IO engine tests
>>
>> Modify the test-zbd-support script to verify the Zone Append command
>> for NVMe Zoned Namespaces (ZNS) defined in NVM Express TP4053.
>> Added a new FIO option zone_append.
>> When zone_append option is enabled, the existing write path will
>> send Zone Append command with LBA offset as start of the Zone.
>>
>> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
>> ---
>>  t/zbd/test-zbd-support | 48
>> ++++++++++++++++++++++++++++++++++++++++++++++++
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
>> +    run_fio_on_seq --ioengine=libaio --iodepth=1 --rw=write --
>> zone_append=1 \
>> +                   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
>> +                   --do_verify=1 --verify=md5                           \
>> +                   >>"${logfile}.${test_number}" 2>&1 || return $?
>> +    check_written $size || return $?
>> +    check_read $size || return $?
>> +}
>> +
>> +# Random zone append to sequential zones, libaio, 8 jobs, queue depth 64
>> per job
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
>> +    run_fio_on_seq --ioengine=io_uring --iodepth=1 --rw=write --
>> zone_append=1 \
>> +                   --bs="$(max $((zone_size / 64)) "$logical_block_size")"\
>> +                   --do_verify=1 --verify=md5                           \
>> +                   >>"${logfile}.${test_number}" 2>&1 || return $?
>> +    check_written $size || return $?
>> +    check_read $size || return $?
>> +}
>> +
>> +# Random zone append to sequential zones, io_uring, 8 jobs, queue depth
>> 64 per job
>> +test52() {
>> +    local size
>> +
>> +    size=$((4 * zone_size))
>
>Maybe try some different size? It is the same in all tests.
>
Sure, we will add different sizes for the tests.

>> +    run_fio_on_seq --ioengine=io_uring --iodepth=64 --rw=randwrite --
>> bs=4K \
>
>All tests do 4K i/o, but maybe try to run with a different block size?
>It could be a good idea to add a test that will write with bs=ZASL(or MDTS).
>Yet another test issuing i/o with bs exceeding the maximum i/o size would
>be very useful.
>
Ok, this input is very helpful. We will implement the tests as per your
review comments.

>> +                   --group_reporting=1 --numjobs=8 --zone_append=1 \
>> +                   >> "${logfile}.${test_number}" 2>&1 || return $?
>> +    check_written $((size * 8)) || return $?
>> +}
>> +
>>  tests=()
>>  dynamic_analyzer=()
>>  reset_all_zones=
>> --
>> 2.7.4
>

------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_c65c1_
Content-Type: text/plain; charset="utf-8"


------LJmyoXw8O9.Ba._wAgamKaSQQ_oizdakYzSktnuewvRJuSc2=_c65c1_--

