Return-Path: <krish.reddy@samsung.com>
Date: Fri, 26 Feb 2021 15:22:56 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 0/1] Intoducing a new option max_latency_rw
Message-ID: <20210226095256.GA16434@test-zns>
MIME-Version: 1.0
In-Reply-To: <20210212075301.24490-1-krish.reddy@samsung.com>
Content-Type: multipart/mixed;
	boundary="----pvzBjhK5fP1.KeQ-5dwBpovzJaerh-PGsnhLH_SWOUXx7Kue=_10644f_"
References: <CGME20210212075335epcas5p1d9c49cbfc7fecc841010960bd8f93ff4@epcas5p1.samsung.com>
	<20210212075301.24490-1-krish.reddy@samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

------pvzBjhK5fP1.KeQ-5dwBpovzJaerh-PGsnhLH_SWOUXx7Kue=_10644f_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

Hi Jens,

Did you have a chance to look at this?

On Fri, Feb 12, 2021 at 01:23:00PM +0530, Krishna Kanth Reddy wrote:
>The current max_latency option exits the FIO job, if latency of an I/O exceeds the max_latency.
>
>For mixed workload if user wants to exit the FIO job, only if latency
>exceeds for a particular workload, i.e. either for read / write, the support is not present.
>
>The new option max_latency_rw accepts read, write or mixed (Default) as option.
>If user specifies read, the FIO job will exit only if read latency exceeds max_latency.
>
>Ankit Kumar (1):
>  Intoducing a new option max_latency_rw. The current max_latency option
>    exits the FIO job, if latency of an I/O exceeds max_latency.
>
> HOWTO            | 17 +++++++++++++++++
> cconv.c          |  2 ++
> fio.1            | 18 ++++++++++++++++++
> init.c           |  3 +++
> io_u.c           | 10 ++++++++--
> options.c        | 23 +++++++++++++++++++++++
> thread_options.h |  8 ++++++++
> 7 files changed, 79 insertions(+), 2 deletions(-)
>
>-- 
>2.30.0-rc0
>
>

------pvzBjhK5fP1.KeQ-5dwBpovzJaerh-PGsnhLH_SWOUXx7Kue=_10644f_
Content-Type: text/plain; charset="utf-8"


------pvzBjhK5fP1.KeQ-5dwBpovzJaerh-PGsnhLH_SWOUXx7Kue=_10644f_--

