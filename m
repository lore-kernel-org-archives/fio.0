Return-Path: <axboe@kernel.dk>
Message-ID: <54D8CF9D.6050402@kernel.dk>
Date: Mon, 09 Feb 2015 08:17:49 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] verify: Fix latency log for verify commands.
References: <1423454000-7730-1-git-send-email-gwendal@chromium.org> <CANvN+emftqHL8e9NUyYvCQQbKPgxhOWsZNZvNgz-txgW-Qpkdg@mail.gmail.com>
In-Reply-To: <CANvN+emftqHL8e9NUyYvCQQbKPgxhOWsZNZvNgz-txgW-Qpkdg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, Gwendal Grignou <gwendal@chromium.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/09/2015 02:39 AM, Andrey Kuzmin wrote:
> On Mon, Feb 9, 2015 at 6:53 AM, Gwendal Grignou <gwendal@chromium.org> wrote:
>> When commands when requeued for the verify operation,
>> their start time was not reset, resulting in bogus latency graphs.
>
> Does it really make sense to account for the verification pass in the
> latency profile?

Why not? If you are doing a full write then verification, you get a full 
set of separate read and write latencies.

-- 
Jens Axboe


