Return-Path: <krish.reddy@samsung.com>
Date: Fri, 5 Mar 2021 11:16:31 +0530
From: Krishna Kanth Reddy <krish.reddy@samsung.com>
Subject: Re: [PATCH 0/1] Intoducing a new option max_latency_rw
Message-ID: <20210305054631.GA30850@test-zns>
MIME-Version: 1.0
In-Reply-To: <20210212103045.28534-1-krish.reddy@samsung.com>
Content-Type: multipart/mixed;
	boundary="----nR-p-cl6vqczMRPvmH-5N4fjQJa_8TPvHPXG_fMvH_3sPSZb=_13e3b4_"
References: <CGME20210212103117epcas5p49dd1cc38a1590e2f007b90b0e708889d@epcas5p4.samsung.com>
	<20210212103045.28534-1-krish.reddy@samsung.com>
To: axboe@kernel.dk
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

------nR-p-cl6vqczMRPvmH-5N4fjQJa_8TPvHPXG_fMvH_3sPSZb=_13e3b4_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

Hello Jens,
Please review this patch and let us know if it looks fine or if it needs
some modification.

On Fri, Feb 12, 2021 at 04:00:44PM +0530, Krishna Kanth Reddy wrote:
>The current max_latency option exits the FIO job, if latency of an I/O exceeds max_latency.
>
>For mixed workload if user wants to exit the FIO job only if latency
>exceeds for a particular workload, i.e. either for read / write the support is not present.
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

------nR-p-cl6vqczMRPvmH-5N4fjQJa_8TPvHPXG_fMvH_3sPSZb=_13e3b4_
Content-Type: text/plain; charset="utf-8"


------nR-p-cl6vqczMRPvmH-5N4fjQJa_8TPvHPXG_fMvH_3sPSZb=_13e3b4_--

