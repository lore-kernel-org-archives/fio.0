Return-Path: <axboe@kernel.dk>
Message-ID: <544ABA12.9020804@kernel.dk>
Date: Fri, 24 Oct 2014 14:44:02 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: fix alignement to prevent bus error on ARM
References: <1414183357-31504-1-git-send-email-gwendal@chromium.org>
In-Reply-To: <1414183357-31504-1-git-send-email-gwendal@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Gwendal Grignou <gwendal@chromium.org>
Cc: fio@vger.kernel.org, vapier@chromium.org, puthik@chromium.org
List-ID: <fio@vger.kernel.org>

On 10/24/2014 02:42 PM, Gwendal Grignou wrote:
> Add a filler field to be ensure 64bit alignment.
> Otherwise, we would trigger SIGBUS error in sum_stat()

Thanks, applied.


-- 
Jens Axboe


