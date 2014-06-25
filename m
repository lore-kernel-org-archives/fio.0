Return-Path: <axboe@kernel.dk>
Message-ID: <53AA268B.4030604@kernel.dk>
Date: Tue, 24 Jun 2014 19:31:55 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Cast input argument for json_object_add_value_int to
 long long
References: <1403650793-7086-1-git-send-email-puthik@chromium.org>
In-Reply-To: <1403650793-7086-1-git-send-email-puthik@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Puthikorn Voravootivat <puthik@chromium.org>
Cc: FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>
List-ID: <fio@vger.kernel.org>

On 2014-06-24 16:59, Puthikorn Voravootivat wrote:
> The latency related (and some other) variables type is uint32_t
> but the JSON integer type is long long. So we need to cast
> the numbers to long long type to make JSON output correctly.

Thanks a lot, applied.

-- 
Jens Axboe


