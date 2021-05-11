Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v3] Make fill_device to stop writing on EDQUOT
References: <YJo0j+luAzHGFWQ+@dione.lan>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2ab50ac4-2e4f-3975-602e-2837e8666fd6@kernel.dk>
Date: Tue, 11 May 2021 07:45:25 -0600
MIME-Version: 1.0
In-Reply-To: <YJo0j+luAzHGFWQ+@dione.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Martin Bukatovic <martin.bukatovic@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 5/11/21 1:38 AM, Martin Bukatovic wrote:
> Option fill_device stops writing when we run out of quota as well.

Applied, thanks.

-- 
Jens Axboe


