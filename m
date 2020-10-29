Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] zbd: Fix test case #48 failure
References: <20201013064926.901831-1-shinichiro.kawasaki@wdc.com>
 <20201029074259.sesqdwbkysw552yl@shindev.dhcp.fujisawa.hgst.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c8735dd3-9b7d-52f5-735c-c7aa6e006a43@kernel.dk>
Date: Thu, 29 Oct 2020 08:00:02 -0600
MIME-Version: 1.0
In-Reply-To: <20201029074259.sesqdwbkysw552yl@shindev.dhcp.fujisawa.hgst.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>
List-ID: <fio@vger.kernel.org>

On 10/29/20 1:43 AM, Shinichiro Kawasaki wrote:
> On Oct 13, 2020 / 15:49, Shin'ichiro Kawasaki wrote:
>> When t/zbd/test-zoned-support is run for zoned block devices with slow zone
>> reset command operation, test case #48 fails. This series addresses the failure
>> with two fixes. First patch avoids excessive and repeated zone resets which
>> resulted in too long runtime and test timeout. Second patch fixes wrong test
>> target range of the test case which triggered unnecessary zone resets.
> 
> Hi Jens, could you consider to pick this series up for the upstream?
> Thanks in advance.

I don't seem to have the actual patches in my mailbox, just the cover
letter. Can you resend them?

-- 
Jens Axboe


