Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CY4PR10MB14942012DEB923224A03FAE28C360@CY4PR10MB1494.namprd10.prod.outlook.com>
References: <CY4PR10MB1494804E84709ACA355AE6AE8C530@CY4PR10MB1494.namprd10.prod.outlook.com>
 <CALjAwxjoaJpLoFxW9YO2C=RSnzbZK_pm9QadRJzLcJbBKkUkmA@mail.gmail.com>
 <CY4PR10MB1494958C30757B38661B3B4F8C560@CY4PR10MB1494.namprd10.prod.outlook.com>
 <CALjAwxhvLBAaYyJk9hTfUXVTWfdkHwLJ4-fKPqNOgZYPV7WbFg@mail.gmail.com>
 <CY4PR10MB1494E32B79F27E052200698F8C280@CY4PR10MB1494.namprd10.prod.outlook.com>
 <CALjAwxiwMA89bJHs9-_MN9eNNibJTtPUBqrMCN6LbMD+kF_Ddw@mail.gmail.com> <CY4PR10MB14942012DEB923224A03FAE28C360@CY4PR10MB1494.namprd10.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 2 Apr 2017 09:07:21 +0100
Message-ID: <CALjAwxjQD_U0M67Ty0LNt3fqo+ccALPv+ww9eADvfpHu0Sxj1g@mail.gmail.com>
Subject: Re: FIO log averaging issue with --write_bw_log and --write_iops_log
 using > 1000 log_avg_msec values
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: Chris Taylor <ctaylor@pivot3.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

Chris has found that timing inaccuracy creeps when adding times
results in a two or more second overflow:

On 2 March 2017 at 21:52, Chris Taylor <ctaylor@pivot3.com> wrote:
> Tests pretty much prove we are getting close to what we expect:
> fio --eta=3Dnever --ioengine=3Dlibaio --readwrite=3Dwrite --time_based=3D=
1 --runtime=3D60 --filename=3D/tmp/fio --size=3D1M --direct=3D1 --name=3Dte=
st --write_iops_log=3D/tmp/test --log_avg_msec=3D5500 --log_unix_epoch=3D1
> 1488489137632, 6413, 1, 0
> 1488489143131, 5503, 1, 0
> 1488489148631, 5585, 1, 0
> 1488489154131, 5883, 1, 0
> 1488489159631, 5726, 1, 0
> 1488489165131, 5331, 1, 0
> 1488489170631, 5772, 1, 0
> 1488489176131, 5661, 1, 0
> 1488489181631, 5970, 1, 0
> 1488489187131, 5776, 1, 0
> [5499, 5500, 5500, 5500, 5500, 5500, 5500, 5500, 5500]
>
> However, the problem still exists where in timeval_add_msec gets a value =
greater than 1000 msecs the tv->tv_usec it will grow beyond usecs (1000000)=
 and causes unexpected behavior.  Possibly this is the better fix to avoid =
other callers having to adjust for  the overflow in timeval_add_msecs?\
> diff --git a/time.c b/time.c
> index f5dc049..a318ad5 100644
> --- a/time.c
> +++ b/time.c
> @@ -9,10 +9,9 @@ static unsigned long ns_granularity;
>  void timeval_add_msec(struct timeval *tv, unsigned int msec)
>  {
>         tv->tv_usec +=3D 1000 * msec;
> -       if (tv->tv_usec >=3D 1000000) {
> -               tv->tv_usec -=3D 1000000;
> -               tv->tv_sec++;
> -       }
> +    tv->tv_sec +=3D tv->tv_usec / 1000000;
> +    tv->tv_usec %=3D 1000000;
> +
>  }
>  /*
> Running the same job as above with the change:
> 1488489763099, 5773, 1, 0
> 1488489768599, 5852, 1, 0
> 1488489774099, 5654, 1, 0
> 1488489779599, 5482, 1, 0
> 1488489785099, 5650, 1, 0
> 1488489790599, 5752, 1, 0
> 1488489796099, 5390, 1, 0
> 1488489801599, 5746, 1, 0
> 1488489807099, 5610, 1, 0
> 1488489812599, 5361, 1, 0
> [5500, 5500, 5500, 5500, 5500, 5500, 5500, 5500, 5500]

Something like the proposed patch looks necessary because you need to
know how many seconds need to be deducted from tv->tv_usec and added
to tv->sec . The only snag I see is with the patch is the introduction
a division and a modulus (https://godbolt.org/g/xrhz7X suggests it's
the division that's most costly). I tried rearranging the code to look
like https://www.dovecot.org/list/dovecot-cvs/2014-September/024976.html
but that actually seemed slower.

Looking at some cachegrind results over on
https://gist.github.com/sitsofe/45fa767f72439cd1f8c148794382003b
suggests the existing code takes the branch 25% of the time and the
branch is mis-predicted around 25% of the time. Looking only at
instructions retired shows the patch doubles the number of
instructions that need to be retired but eliminates branch
mis-predictions. You could reintroduce the if thus skipping the extra
work 75% of the time but whether doing so is a win depends on the cost
of mis-predicting a branch. If you assume a mis-predict costs nothing
there's a difference of 3000 cycles over one minute and
since mis-predictions will reduce the difference I think the patch should
go in as is.

--=20
Sitsofe | http://sucs.org/~sits/

