Return-Path: <axboe@kernel.dk>
Message-ID: <5447D0F5.7090403@kernel.dk>
Date: Wed, 22 Oct 2014 09:44:53 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: --status-interval output race
References: <CAE56cDu7ctJfTLbFRUGh+VwyHdJ=_rtLYLL_b-kJ=YmeeGaopA@mail.gmail.com>
In-Reply-To: <CAE56cDu7ctJfTLbFRUGh+VwyHdJ=_rtLYLL_b-kJ=YmeeGaopA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Michael Mattsson <michael.mattsson@gmail.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/21/2014 05:54 PM, Michael Mattsson wrote:
> Hey,
> I'm trying to get predictable output from --status-interval. I believe
> there's some output racing going on and can't think of a way of
> working around it at this point. Is there a way to redirect
> --status-interval to a separate file and have the summary go to
> --output? That would be useful.
> 
> Anyhow.
> 
> Attached is a --side-by-side diff by a custom --minimal parser, this
> is the command line used: fio --minimal --direct=1 --group_reporting
> --filesize=100m --norandommap --blocksize=32k --time_based --iodepth=1
> --ramp_time=0 --ioengine=libaio --status-interval=5
> --percentage_random=100 --name=randrw-workload --rw=randrw
> --rwmixread=0 --numjobs=2 --filename=/fut1/rs-dev2_2:/fut2/rs-dev2_2
> --runtime=60 --output fio_w.dat
> 
> What happens is that intermittently I get a <1s splurge on the last
> line which is suppose to be final output but it screws up the summary
> fields, more explictly:
> 
> Bandwidth KB
> IOPS
> Runtime (ms)
> 
> Sometime it happens with this workload but it happens more
> infrequently: fio --minimal --direct=1 --group_reporting
> --filesize=100m --norandommap --blocksize=32k --time_based --iodepth=1
> --ramp_time=0 --ioengine=libaio --status-interval=5
> --percentage_random=100 --name=rainscaler-randrw --rw=randrw
> --rwmixread=100 --numjobs=2 --filename=/fut1/rs-dev2_1:/fut2/rs-dev2_1
> --runtime=60 --output fio_r.dat
> 
> What is good to know here is that both these run in parallel as two
> independent fio jobs on the same host if there is some communication
> between fio processes that are run independently on the same host that
> promotes this behavior. I can't use /tmp/fio-dump-status as there will
> be a race between master processes who unlink the file first.
> 
> fio-2.1.4 and fio-2.1.13 on CentOS 6.5.

Can you see if it works better if you revert commit 83f7b64ea773?

-- 
Jens Axboe


