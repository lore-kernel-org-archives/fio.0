Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3 2/4] fio: enable cross-thread overlap checking with
 processes
References: <20181017160325.16866-1-vincentfu@gmail.com>
 <20181017160325.16866-3-vincentfu@gmail.com>
 <41102acc-d07a-01ad-7f9c-efbc0d9f3b4a@gydle.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0d5cc1c0-28df-f807-f150-99cff4c1079c@kernel.dk>
Date: Wed, 17 Oct 2018 10:26:44 -0600
MIME-Version: 1.0
In-Reply-To: <41102acc-d07a-01ad-7f9c-efbc0d9f3b4a@gydle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: =?UTF-8?Q?S=c3=a9bastien_Boisvert?= <sboisvert@gydle.com>, vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 10/17/18 10:25 AM, Sébastien Boisvert wrote:
>> @@ -10,14 +11,18 @@ struct align_footer {
>>  	unsigned int offset;
>>  };
>>  
>> -void *fio_memalign(size_t alignment, size_t size)
>> +void *fio_memalign(size_t alignment, size_t size, bool shared)
>>  {
>>  	struct align_footer *f;
>>  	void *ptr, *ret = NULL;
>>  
>>  	assert(!(alignment & (alignment - 1)));
>>  
>> -	ptr = malloc(size + alignment + sizeof(*f) - 1);
>> +	if (shared)
>> +		ptr = smalloc(size + alignment + sizeof(*f) - 1);
>> +	else
>> +		ptr = malloc(size + alignment + sizeof(*f) - 1);
> 
> Hello Vincent,
> 
> In your patch serives version 2, you removed the memset() call because
> smalloc() is already zeroing memory, according to Jens.
> 
> From the hunk above, the memory pointed by ptr is not zeroed, when
> being allocated by malloc.
> 
> I don't think that malloc is guaranteed to return zeroed memory.
> 
> Sure, if the malloc from the glibc just called brk() or mmap(), then,
> maybe those pages will be zeroed by the kernel, and the glibc malloc
> arena from which the chunk is drawn may be zeroed.
> 
> But otherwise, if it's a malloc that stays in user-space (existing
> arenas can fulfill the call), then, it is not zeroed, I think.

malloc() isn't zeroed, the code was using calloc() before (which is fine.

-- 
Jens Axboe


