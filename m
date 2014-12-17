Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <548EFB15.8080704@kernel.dk>
References: <2028599731.63796.1418644100540.JavaMail.zimbra@thomas-krenn.com>
	<548EFB15.8080704@kernel.dk>
Date: Tue, 16 Dec 2014 16:49:57 -0800
Message-ID: <CAF+0mvk7JkLVsqU5tDvfO7XrJyRR=8R4ZUcDhdpmfp6ST9cYzQ@mail.gmail.com>
Subject: Re: SSD write latency lower than read latency
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: =?UTF-8?Q?Georg_Sch=C3=B6nberger?= <gschoenberger@thomas-krenn.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Just FYI, this is also the case with the DC S3700 based on my testing.

On Mon, Dec 15, 2014 at 7:15 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 12/15/2014 04:48 AM, Georg Sch=C3=B6nberger wrote:
>>
>> Hi Fio users and Jens,
>>
>> I am currently analyzing read and write latencies of Solid State Disks
>> (SSDs). My assumption was that
>> write latencies are usually higher than read latencies. But my tests wit=
h
>> Fio on an Intel DCS3500 show
>> that average latency while writing is lower than while reading (using
>> fio-2.1.3):
>>
>> * $ sudo /usr/bin/fio --rw=3Drandrw --name=3DintelDCS3500 --bs=3D4k --di=
rect=3D1
>> --filename=3D/dev/sda --rwmixread=3D0
>>      --numjobs=3D1 --ioengine=3Dlibaio --runtime=3D60 --iodepth=3D1 --ti=
me_based
>>      [...]
>>      lat (usec): min=3D30, max=3D1010, avg=3D43.32, stdev=3D 3.42
>>      [...]
>> * $ sudo /usr/bin/fio --rw=3Drandrw --name=3DintelDCS3500 --bs=3D4k --di=
rect=3D1
>> --filename=3D/dev/sda --rwmixread=3D100
>>      --numjobs=3D1 --ioengine=3Dlibaio --runtime=3D60 --iodepth=3D1 --ti=
me_based
>>      [...]
>>      lat (usec): min=3D103, max=3D2315, avg=3D121.92, stdev=3D11.02
>>
>> I have made this observation on two different machines with different
>> SSDs, always producing similar results.
>> Am I doing anything wrong with my tests?
>> Are write latencies in general lower than read latencies?
>>
>> One guess I have is a SSD cache to enhance write access (in particular t=
he
>> Intel datacenter SSDs, as they have
>> a "Enhanced power-loss data protection" feature).
>
>
> Your guess is exactly right, that's what most flash based devices (worth
> their salt) do. That's also why sync write latencies are mostly independe=
nt
> of the type of nand used, whereas the read latency will easily reflect th=
at.
>
> --
> Jens Axboe
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

