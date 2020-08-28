Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] thread_options: Add cgroup_use_bfq
References: <20200828100230.GG6041@suselix> <20200828100435.GH6041@suselix>
 <DF4PR8401MB10491D443BCBDD8B9586F4FFAB520@DF4PR8401MB1049.NAMPRD84.PROD.OUTLOOK.COM>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <031cac45-076a-6e9a-ba5e-2af51ca3f095@kernel.dk>
Date: Fri, 28 Aug 2020 17:52:11 -0600
MIME-Version: 1.0
In-Reply-To: <DF4PR8401MB10491D443BCBDD8B9586F4FFAB520@DF4PR8401MB1049.NAMPRD84.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Servers)" <elliott@hpe.com>, Andreas Herrmann <aherrmann@suse.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 8/28/20 12:36 PM, Elliott, Robert (Servers) wrote:
> 
> 
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> On Behalf
>> Of Andreas Herrmann
>> Sent: Friday, August 28, 2020 5:05 AM
>> To: Jens Axboe <axboe@kernel.dk>
>> Cc: fio@vger.kernel.org
>> Subject: [PATCH 1/2] thread_options: Add cgroup_use_bfq
>>
> ...
>> @@ -593,11 +594,13 @@ struct thread_options_pack {
>>  	uint8_t profile[FIO_TOP_STR_MAX];
>>
>>  	/*
>> -	 * blkio cgroup support
>> +	 * (blk)io cgroup support
>>  	 */
>>  	uint8_t cgroup[FIO_TOP_STR_MAX];
>>  	uint32_t cgroup_weight;
>>  	uint32_t cgroup_nodelete;
>> +	uint32_t cgroup_use_bfq;
>> +	uint32_t padding;       /* remove when possible to maintain alignment */
>>
>>  	uint32_t uid;
>>  	uint32_t gid;
> 
> Since the structure already has three pad fields:
>         uint32_t pad;
> 
>         uint64_t size;
> 	...
>         uint32_t pad2;
>         uint64_t rand_seed;
> 	...
>         uint32_t pad3;
>         fio_fp64_t percentile_list[FIO_IO_U_LIST_MAX_LEN];
> 
> pad4 would seem like the natural name for another padding field, and
> the comment doesn't seem necessary.

Also worth checking if you can actually remove padding when updating it,
rather than adding more.

BTW, this is also missing a FIO_SERVER_VER increment, that's needed
whenever thread_options are changed.

-- 
Jens Axboe


