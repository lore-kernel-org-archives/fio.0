Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] smalloc fixes
References: <20190903174445.1212-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <6801732c-cae4-4d09-dff3-0733e719bed0@kernel.dk>
Date: Tue, 3 Sep 2019 12:32:43 -0600
MIME-Version: 1.0
In-Reply-To: <20190903174445.1212-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/3/19 11:44 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Jens, please consider these patches that are a follow up to the smalloc
> patch from last week.
> 
> I broke up last week's patch into two: one that implements your
> suggested fix for the synchronization issue and a second that fixes the
> SMALLOC_BPB/SMALLOC_BPI issue.

Thanks Vincent, applied.

-- 
Jens Axboe


