Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Mon, 29 Jun 2015 09:46:01 -0500
Message-ID: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com>
Subject: competime_assert failure without -O3 optimization flag expected ?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

> +struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
> +{
> +       struct all_io_list *rep;
> +       struct thread_data *td;
> +       size_t depth;
> +       void *next;
> +       int i, nr;
> +
> +       compiletime_assert(sizeof(struct all_io_list) == 8, "all_io_list");


I am getting compile time assertion failure on the following line of
code when I remove the optimization flag (-O3) in the Makefile. Is
this something expected ? I want to remove optimizations in order to
debug my code based on original source code line order not optimized
code order.


--Alireza

