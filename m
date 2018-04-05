Return-Path: <rebecca@bluestop.org>
Subject: Re: [PATCH] Fix return value checking of fread() in iolog.c
References: <20180404231842.35916-1-rebecca@bluestop.org>
 <992e2db4-0bba-8363-3706-ea39cb62c698@kernel.dk>
From: Rebecca Cran <rebecca@bluestop.org>
Message-ID: <7fa07227-d0ef-5cc5-10aa-ed1798c9f19a@bluestop.org>
Date: Wed, 4 Apr 2018 21:12:45 -0600
MIME-Version: 1.0
In-Reply-To: <992e2db4-0bba-8363-3706-ea39cb62c698@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 4/4/2018 7:19 PM, Jens Axboe wrote:
> On 4/4/18 5:18 PM, Rebecca Cran wrote:
>> According to http://pubs.opengroup.org/onlinepubs/7908799/xsh/fread.html
>> fread() returns a size_t, not ssize_t, and returns a value of 0 on
>> both eof and an error. Therefore, check both feof() and ferror() to
>> determine whether the call succeeded.
> Thanks Rebecca, applied.

By the way, this fixes the --inflate-log option on Windows - it would 
previously error out reporting a short read.

-- 
Rebecca

