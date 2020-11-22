Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20201030111147.19175-1-aherrmann@suse.com>
In-Reply-To: <20201030111147.19175-1-aherrmann@suse.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 22 Nov 2020 14:52:17 +0000
Message-ID: <CALjAwxj01DOmcn=YPHnvWAVAo-kA18N3Dz4nnbzkLkiOMwYVNw@mail.gmail.com>
Subject: Re: [PATCH v3 resend 0/4] cgroup: Support cgroup-v2 weight and BFQ weight
Content-Type: text/plain; charset="UTF-8"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, Andreas Herrmann <aherrmann@suse.com>
List-ID: <fio@vger.kernel.org>

Hi Jens,

I've just looked over this series and it looks OK to me.

On Fri, 30 Oct 2020 at 11:16, Andreas Herrmann <aherrmann@suse.com> wrote:
>
> These are changes to support weight with cgroup-v2, and also BFQ's
> weight attribute. In recent kernels with cgroup v1 only
> blkio.bfq.weight is available to set weight.
>
> v3: - rebased on fio-3.23-28-g7064f894
>       (now rebased on fio-3.23-48-ga0b72421 w/o changes)
>
> v2: - bumped FIO_SERVER_VER
>     - regrouped patches
>
> Andreas Herrmann (4):
>   cgroup: Fix handling when cgroup blkio and cgroup-v2 are mounted
>   cgroup: Allow to use weights with cgroup-v2
>   thread_options: Introduce cgroup_use_bfq
>   cgroup: Support BFQ's weight attributes
>
>  HOWTO            |   6 +++
>  cconv.c          |   2 +
>  cgroup.c         | 110 ++++++++++++++++++++++++++++++++++++-----------
>  fio.1            |   5 +++
>  options.c        |  11 +++++
>  server.h         |   2 +-
>  thread_options.h |   7 ++-
>  7 files changed, 116 insertions(+), 27 deletions(-)
>
> --
> 2.29.0
>


--
Sitsofe | http://sucs.org/~sits/

