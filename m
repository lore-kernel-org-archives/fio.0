Return-Path: <axboe@kernel.dk>
Subject: Re: [io_uring] Problems using io_uring engine
References: <4f70c99f-e5c8-08f7-ebe9-1bbdea73305d@eafit.edu.co>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <f552027a-25bd-d953-9b19-58e5e44121c6@kernel.dk>
Date: Mon, 25 May 2020 13:21:22 -0600
MIME-Version: 1.0
In-Reply-To: <4f70c99f-e5c8-08f7-ebe9-1bbdea73305d@eafit.edu.co>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Hamilton Tobon Mosquera <htobonm@eafit.edu.co>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/25/20 11:45 AM, Hamilton Tobon Mosquera wrote:
> Hi there,
> 
> I'm trying to run sequential and random reads/writes in parallel using 
> the io_uring engine with the HIPRI flag activated to enable polling. The 
> file size is 200G, the number of fio threads is 4. The --size flags is 
> set to 200/4, and the --offset_increment is set to 25%. I could 
> effectively do it with pvsync2 engine but when I switch to io_uring the 
> workloads immediately (they do not even work for 1 sec) fail with these 
> errors:
> 
> fio: io_u error on file /path/to/file: Operation not supported: write 
> offset=3238043648, buflen=4096
> fio: io_u error on file /path/to/file: Operation not supported: write 
> offset=88715874304, buflen=4096
> fio: io_u error on file /path/to/file: Operation not supported: write 
> offset=174739943424, buflen=4096
> fio: io_u error on file /path/to/file: Operation not supported: write 
> offset=112642154496, buflen=4096
> 
> 
> The offsets are under 200G, I don't understand why it's returning those 
> errors. Can someone help please?.

What file system are you using? I don't think it supports IO polling.
io_uring actually checks for this, with preadv you just get normal
schedule based IO.

-- 
Jens Axboe


