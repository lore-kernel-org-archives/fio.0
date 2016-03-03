Return-Path: <axboe@kernel.dk>
Date: Thu, 3 Mar 2016 09:20:37 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Fio high IOPS measurement mistake
Message-ID: <20160303162037.GD22164@kernel.dk>
References: <56D525E1.6010407@vlnb.net>
 <CALjAwxjLb7L8sZCensSNXZ4kDyHb683bu-zuwDvgk5sFoeMckw@mail.gmail.com>
 <56D66B1C.6050506@vlnb.net>
 <56D7A97F.9080800@vlnb.net>
 <CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjAwxgU06EEYCw9VV7S8UzDtgpo-KUQtS90HK=KpfffkCKn2A@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Thu, Mar 03 2016, Sitsofe Wheeler wrote:
> On 3 March 2016 at 03:03, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> > For those who asked about perf profiling, it remained the same as before with the CPU
> > consumption is all about timekeeping and memset:
> >
> > -  55.74%  fio  fio                [.] clock_thread_fn
> >      clock_thread_fn
> 
> Perhaps this is what is already included above but could you use the
> -g option on perf to collect it into a call-graph and post the top
> results?

The above looks like a side effect of using gtod_cpu, it'll burn one
core. For the original poster - did you verify whether using gtod_cpu
was faster than using the CPU clock source in each CPU?

-- 
Jens Axboe


