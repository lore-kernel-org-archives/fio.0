Return-Path: <axboe@kernel.dk>
Message-ID: <54F63117.7000601@kernel.dk>
Date: Tue, 03 Mar 2015 15:09:27 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] fio: fix smalloc strdop allocation failure
References: <1425383086-9188-1-git-send-email-ehrhardt@de.ibm.com>
In-Reply-To: <1425383086-9188-1-git-send-email-ehrhardt@de.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Christian Ehrhardt <ehrhardt@de.ibm.com>, fio@vger.kernel.org
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
List-ID: <fio@vger.kernel.org>

On 03/03/2015 04:44 AM, Christian Ehrhardt wrote:
> From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
>
> smalloc_strdup didn't check for allocation success and thereby ran into
> segfaults if the single pool went out of memory.
> Now with this patch applied it is still failing, but in a more consistent
> way than segfaulting.
>
> You still get a bad allocation, but it looks like this now:
>    fio: smalloc OOM
>    fio: filesetup.c:1495: dup_files: Assertion `0' failed.
>    Aborted
>
> In fact the upper layers expected smalloc_strdup to retrun NULL on failure.
>
> Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>

Applied, thanks.

-- 
Jens Axboe


