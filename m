Return-Path: <axboe@kernel.dk>
Subject: Re: Fwd: Trim options for Windows
References: <CAP0A3FUaeY=zmhab1bFzSrtpcR-pA5ZNrAZopCjcScU6dFtgOQ@mail.gmail.com>
 <CAP0A3FXtCvUyK01v6WSGCcu44KqkYdGOx_jJLrDTpoPCKh=sMA@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f6a4f5e0-f18b-7356-4705-0fdcf83262fc@kernel.dk>
Date: Tue, 23 Aug 2016 13:17:03 -0600
MIME-Version: 1.0
In-Reply-To: <CAP0A3FXtCvUyK01v6WSGCcu44KqkYdGOx_jJLrDTpoPCKh=sMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jagatananda Samal <jagata.samal@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 08/23/2016 01:04 PM, Jagatananda Samal wrote:
> Hi,
> Is trim option supported for Windows OS?
> I notice that when I specify trimwrite as IO pattern, it's throwing the
> following error message:
>
> windowsaio: manual TRIM isn't supported on Windows
>
> Command line used:
>
> C:\Program Files\fio>fio  --runtime=10  --filename=\\.\PHYSICALDRIVE1
> --ioengine=windowsaio --direct=1 --verify=md5 --verify_dump=1
> --rw=trimwrite --norandommap --fill_device=1 --time_based --name=trim_2m
> --bs=2m

Right, trim isn't supported on Windows. If someone knows the application
interface for trim on that OS, it should be trivial to add, however.

-- 
Jens Axboe

