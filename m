Return-Path: <axboe@kernel.dk>
Subject: Re: Double output
References: <FE26B714-2A33-4B51-BD30-40FF089A6BE8@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56411706.4060900@kernel.dk>
Date: Mon, 9 Nov 2015 14:58:30 -0700
MIME-Version: 1.0
In-Reply-To: <FE26B714-2A33-4B51-BD30-40FF089A6BE8@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: GrAnt <626542@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 11/09/2015 10:45 AM, GrAnt wrote:
> Hello!
>
> Is there way to get normal and terse output for one execution at the same time? Thx

If you have a new enough version:

$ fio --output-format=normal,terse [...]

-- 
Jens Axboe


