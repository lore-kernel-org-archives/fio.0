Return-Path: <daniel.menzel@menzel-it.net>
Subject: Re: io_uring on CentOS8?
References: <6d57985d-b784-f9a5-68d0-3a0c3857b4a4@menzel-it.net>
 <99539c2d-15e0-db7c-d7bc-e1624bd1e43f@kernel.dk>
 <CO1PR11MB48044A2F300CE9B9FCE08D0B8B879@CO1PR11MB4804.namprd11.prod.outlook.com>
From: Daniel Menzel <daniel.menzel@menzel-it.net>
Message-ID: <47fb82fb-ede0-de4c-b230-c4bb8fe14b57@menzel-it.net>
Date: Tue, 16 Feb 2021 20:46:11 +0100
MIME-Version: 1.0
In-Reply-To: <CO1PR11MB48044A2F300CE9B9FCE08D0B8B879@CO1PR11MB4804.namprd11.prod.outlook.com>
Content-Type: multipart/alternative;
 boundary="------------086848DCCC46204E381BCD5D"
Content-Language: en-US
To: "Ober, Frank" <frank.ober@intel.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

This is a multi-part message in MIME format.
--------------086848DCCC46204E381BCD5D
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Hi Frank,

thanks a lot for that input! Currently I'm switching to Ubuntu for my
tests - hoping that /io_uring/ will help. But I will definitely try out
pvsync2 as well.

Thanks!
Daniel

Am 16.02.21 um 20:00 schrieb Ober, Frank:
> Hi Daniel, Intel uses pvsync2 for QD1 testing so if you cannot use spdk or io_uring (these are the fastest ways to test a device), you can switch your engine to pvsync2 on this kernel and this will work. 
>
> Here's what I tried on PCIe Gen3 system with an Optane drive and your drive.
>
>
> [root@fm42adsdemo001 block]# fio --bs=1M --rw=randwrite --numjobs=1 --iodepth=1  --size=10000M \
>> --filename=/dev/nvme6n1 --name=mylittletest --direct=1 --fsync=1 \
>> --refill_buffers --ioengine=pvsync2 --group_reporting \
>> --fallocate=none --runtime=60 --time_based --hipri
> mylittletest: (g=0): rw=randwrite, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=pvsync2, iodepth=1
> fio-3.24-5-g2ee2
> Starting 1 process
> Jobs: 1 (f=1): [w(1)][100.0%][w=2048MiB/s][w=2048 IOPS][eta 00m:00s]
>
> I ran the same exact job on this mid-range Intel Xeon cpu and found io_uring only very slightly faster than pvsync2
> Jobs: 1 (f=1): [w(1)][100.0%][w=2057MiB/s][w=2057 IOPS][eta 00m:00s]
>
> HTH,
> Frank Ober
>
>
> -----Original Message-----
> From: Jens Axboe <axboe@kernel.dk> 
> Sent: Sunday, February 14, 2021 8:50 AM
> To: Daniel Menzel <daniel.menzel@menzel-it.net>; fio@vger.kernel.org
> Subject: Re: io_uring on CentOS8?
>
> On 2/14/21 8:17 AM, Daniel Menzel wrote:
>> /Somehow it seems as if I'm receiving messages from the mailing list - 
>> but mine do not seem to get through. So I'm trying again./
>>
>> Hi,
>>
>> currently I started testing fairly fast NVMe-drives and I for the first time I dealt with the question whether the io engine is sufficient (up till now I just the default /libaio/). I found some information on io_uring online and now tried to switch to that engine:
>>
>> fio --bs=1M --rw=randwrite --numjobs=1 --iodepth=1  --size=10000M 
>> --filename=/dev/nvme0n1 --name=mylittletest --direct=1 --fsync=1  
>> --refill_buffers --ioengine=io_uring --group_reporting 
>> --fallocate=none --runtime=60 --time_based --hipri
>>
>> But it crashes with the following information: fio: pid=2490, 
>> err=38/file:engines/io_uring.c:699, func=io_queue_init, error=Function 
>> not implemented
>>
>> My system:
>>
>>  1. fio-3.25
>>  2. CentOS8 (Kernel 4.18.0-240.1.1.el8_3.x86_64)  3. I have installed 
>> the packes liburing and liburing-devel
>>
>> Am I doing something wrong?
> You are not, but since you get -ENOSYS from the system call, that means that the kernel doesn't support io_uring. It was officially added with the 5.1 kernel, so 4.18 predates that.
>
>
> --
> Jens Axboe
>
-- 
Daniel Menzel
Geschäftsführer

Menzel IT GmbH
Charlottenburger Str. 33a
13086 Berlin

+49 (0) 30 / 5130 444 - 00
daniel.menzel@menzel-it.net
https://menzel-it.net

Geschäftsführer: Daniel Menzel, Josefin Menzel
Unternehmenssitz: Berlin
Handelsregister: Amtsgericht Charlottenburg
Handelsregister-Nummer: HRB 149835 B
USt-ID: DE 309 226 751


--------------086848DCCC46204E381BCD5D
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>Hi Frank,</p>
    <p>thanks a lot for that input! Currently I'm switching to Ubuntu
      for my tests - hoping that <i>io_uring</i> will help. But I will
      definitely try out pvsync2 as well.</p>
    <p>Thanks!<br>
      Daniel<br>
    </p>
    <div class="moz-cite-prefix">Am 16.02.21 um 20:00 schrieb Ober,
      Frank:<br>
    </div>
    <blockquote type="cite"
cite="mid:CO1PR11MB48044A2F300CE9B9FCE08D0B8B879@CO1PR11MB4804.namprd11.prod.outlook.com">
      <pre class="moz-quote-pre" wrap="">Hi Daniel, Intel uses pvsync2 for QD1 testing so if you cannot use spdk or io_uring (these are the fastest ways to test a device), you can switch your engine to pvsync2 on this kernel and this will work. 

Here's what I tried on PCIe Gen3 system with an Optane drive and your drive.


[root@fm42adsdemo001 block]# fio --bs=1M --rw=randwrite --numjobs=1 --iodepth=1  --size=10000M \
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">--filename=/dev/nvme6n1 --name=mylittletest --direct=1 --fsync=1 \
--refill_buffers --ioengine=pvsync2 --group_reporting \
--fallocate=none --runtime=60 --time_based --hipri
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">mylittletest: (g=0): rw=randwrite, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=pvsync2, iodepth=1
fio-3.24-5-g2ee2
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][w=2048MiB/s][w=2048 IOPS][eta 00m:00s]

I ran the same exact job on this mid-range Intel Xeon cpu and found io_uring only very slightly faster than pvsync2
Jobs: 1 (f=1): [w(1)][100.0%][w=2057MiB/s][w=2057 IOPS][eta 00m:00s]

HTH,
Frank Ober


-----Original Message-----
From: Jens Axboe <a class="moz-txt-link-rfc2396E" href="mailto:axboe@kernel.dk">&lt;axboe@kernel.dk&gt;</a> 
Sent: Sunday, February 14, 2021 8:50 AM
To: Daniel Menzel <a class="moz-txt-link-rfc2396E" href="mailto:daniel.menzel@menzel-it.net">&lt;daniel.menzel@menzel-it.net&gt;</a>; <a class="moz-txt-link-abbreviated" href="mailto:fio@vger.kernel.org">fio@vger.kernel.org</a>
Subject: Re: io_uring on CentOS8?

On 2/14/21 8:17 AM, Daniel Menzel wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">/Somehow it seems as if I'm receiving messages from the mailing list - 
but mine do not seem to get through. So I'm trying again./

Hi,

currently I started testing fairly fast NVMe-drives and I for the first time I dealt with the question whether the io engine is sufficient (up till now I just the default /libaio/). I found some information on io_uring online and now tried to switch to that engine:

fio --bs=1M --rw=randwrite --numjobs=1 --iodepth=1  --size=10000M 
--filename=/dev/nvme0n1 --name=mylittletest --direct=1 --fsync=1  
--refill_buffers --ioengine=io_uring --group_reporting 
--fallocate=none --runtime=60 --time_based --hipri

But it crashes with the following information: fio: pid=2490, 
err=38/<a class="moz-txt-link-freetext" href="file:engines/io_uring.c:699">file:engines/io_uring.c:699</a>, func=io_queue_init, error=Function 
not implemented

My system:

 1. fio-3.25
 2. CentOS8 (Kernel 4.18.0-240.1.1.el8_3.x86_64)  3. I have installed 
the packes liburing and liburing-devel

Am I doing something wrong?
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
You are not, but since you get -ENOSYS from the system call, that means that the kernel doesn't support io_uring. It was officially added with the 5.1 kernel, so 4.18 predates that.


--
Jens Axboe

</pre>
    </blockquote>
    <pre class="moz-signature" cols="72">-- 
Daniel Menzel
Geschäftsführer

Menzel IT GmbH
Charlottenburger Str. 33a
13086 Berlin

+49 (0) 30 / 5130 444 - 00
<a class="moz-txt-link-abbreviated" href="mailto:daniel.menzel@menzel-it.net">daniel.menzel@menzel-it.net</a>
<a class="moz-txt-link-freetext" href="https://menzel-it.net">https://menzel-it.net</a>

Geschäftsführer: Daniel Menzel, Josefin Menzel
Unternehmenssitz: Berlin
Handelsregister: Amtsgericht Charlottenburg
Handelsregister-Nummer: HRB 149835 B
USt-ID: DE 309 226 751</pre>
  </body>
</html>

--------------086848DCCC46204E381BCD5D--

