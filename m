Return-Path: <axboe@kernel.dk>
Message-ID: <55919868.4010504@kernel.dk>
Date: Mon, 29 Jun 2015 13:11:36 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: competime_assert failure without -O3 optimization flag expected
 ?
References: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com> <5591687D.6040803@kernel.dk> <CAB-428=EKjcxK6J9OvKU1nM34Q998fN=LFQKgNgofeMb_cuY1g@mail.gmail.com> <55916A66.5080303@kernel.dk> <55916C87.1030408@kernel.dk> <CAB-428=ToOGYb=5r6VhORWiFqXoHk6N8tMX8HbUr2_Cctf9oWw@mail.gmail.com> <55918558.8090006@kernel.dk> <CAB-428=30M7HXTfL4P3KpyjAG3dqMA9vVirc8iyjbO-8eAgDrQ@mail.gmail.com> <55918E78.2050706@kernel.dk> <CAB-428kYoWm-SqfCpQRa2z6-fb=7X+kkNC7hfOV8HOUU-TV4PQ@mail.gmail.com>
In-Reply-To: <CAB-428kYoWm-SqfCpQRa2z6-fb=7X+kkNC7hfOV8HOUU-TV4PQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/29/2015 12:58 PM, Alireza Haghdoost wrote:
> Make sens Jens. I did not get what you told me in the first place. Let
> me know if this would fix it. It works for me with GCC 4.6 (patch file
> is also attached):

This is perfect! Thanks, committed:

http://git.kernel.dk/cgit/fio/commit/?id=5018f79f6d8da82b6fafbbeeebdecb3799788bc3

-- 
Jens Axboe


