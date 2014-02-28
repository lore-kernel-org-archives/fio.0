Return-Path: <oberpar@linux.vnet.ibm.com>
Message-ID: <5310BD68.101@linux.vnet.ibm.com>
Date: Fri, 28 Feb 2014 17:46:32 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [patch 8/9] fio: fix last block never being touched by random
 offsets
References: <20140220132051.624645398@linux.vnet.ibm.com> <20140220171832.GC30251@kernel.dk>
In-Reply-To: <20140220171832.GC30251@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, ehrhardt@linux.vnet.ibm.com
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 20.02.2014 18:18, Jens Axboe wrote:
> On Thu, Feb 20 2014, ehrhardt@linux.vnet.ibm.com wrote:
>> *Resend with hopefully non mangled patches*
>> References: <20140220131958.965092001@linux.vnet.ibm.com>
>> Content-Disposition: inline; filename=fix_last_block.diff
>>
>> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>>
>> Fix the available range for random offsets which never touched the last block.
>>
>> Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
>> ---
>> [diffstat]
>>  io_u.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- a/io_u.c
>> +++ b/io_u.c
>> @@ -104,7 +104,7 @@ static int __get_next_rand_offset(struct
>>  
>>  		dprint(FD_RANDOM, "off rand %llu\n", (unsigned long long) r);
>>  
>> -		*b = (lastb - 1) * (r / ((uint64_t) rmax + 1.0));
>> +		*b = lastb * (r / ((uint64_t) rmax + 1.0));
>>  	} else {
>>  		uint64_t off = 0;
> 
> Wont this generate lastb as the potentially last block? We want lastb-1
> as the last one, otherwise the length of IO from it will be 0.
> 
> I might be missing something here.

I would expect that the last I/O would be at offset size-blocksize and
size blocksize. Consider this example test case that should generate 1
second of random reads with offsets 0 and 512:

[job]
filename=datafile
blocksize=512
size=1024
time_based
runtime=1
rw=randread
norandommap
write_iolog=/dev/stdout

Running it with FIO_VERSION = fio-2.1.5-44-ga1fc produces the following
result:

> fio job | grep datafile | sort | uniq
datafile add
datafile close
datafile open
datafile read 0 512

-> I/O is only generated for offset 0

Running it with the same version and the subject patch applied:

> fio job | grep datafile | sort | uniq
datafile add
datafile close
datafile open
datafile read 0 512
datafile read 512 512

-> Both offsets are covered

-- 
Peter Oberparleiter
Linux on System z Development - IBM Germany


