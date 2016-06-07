Return-Path: <axboe@kernel.dk>
Subject: Re: System IOPS vs. fio IOPS
References: <CAKapHkMhGrnb1g=b9Pz_D_Frx8OSP65aiXBBM_KgVy5wpSz-kw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5756D05D.2050205@kernel.dk>
Date: Tue, 7 Jun 2016 07:47:09 -0600
MIME-Version: 1.0
In-Reply-To: <CAKapHkMhGrnb1g=b9Pz_D_Frx8OSP65aiXBBM_KgVy5wpSz-kw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Karan Singh <karan@redhat.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/06/2016 03:41 PM, Karan Singh wrote:
> #1  : Is r/s and w/s fields in iostat output corresponds to read and
> write IOPS ? ( https://serverfault.com/questions/342273/disk-iops-count-in-gnu-linux
> mentions r/s and w/s as IOPS)
> #2  : If yes then why does they dont match with FIO IOPS results ?

The answer is no, and that goes for any application. You could have an 
app that does sequential ios in 4k chunks, and the kernel merges them 
into 512k IOs. From the application perspective, it's doing 128 as many 
iops as the device is. The converse can also be true, like in your case, 
since the application is submitting IO that is larger than the device 
can handle. Hence it's broken up, and the result is that the device is 
now doing a lot more IOPS than the application is issuing.

-- 
Jens Axboe


