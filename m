Return-Path: <axboe@kernel.dk>
Message-ID: <53189A5D.1070602@kernel.dk>
Date: Thu, 06 Mar 2014 08:55:09 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio replay
References: <651fd21aaf304da0b24902febae3c345@BN1PR07MB437.namprd07.prod.outlook.com> <76F46F78-8F5A-45CF-BBCE-3ADC63AFF541@nellans.org> <934f861a97f2443aa35296c2d6d8c848@BN1PR07MB437.namprd07.prod.outlook.com> <530E2933.2080903@kernel.dk> <530E6056.2020309@kernel.dk> <c79c5d2e1b3f4a3487815ca851a8399e@BN1PR07MB437.namprd07.prod.outlook.com> <70dc0e01a5674f159ed9e02dc61b64ce@BN1PR07MB437.namprd07.prod.outlook.com>
In-Reply-To: <70dc0e01a5674f159ed9e02dc61b64ce@BN1PR07MB437.namprd07.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "Lamkin, Eric" <Eric.Lamkin@lsi.com>, David Nellans <david@nellans.org>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 03/03/2014 06:25 AM, Lamkin, Eric wrote:
> Here's my update with a blktrace captured on a single device with no dropped events.
> Also switched to fio 2.1.4.
>
> Capture a single device trace with no dropped events.

[snip]

Thanks for the detailed report. But why are you replaying with 
fio-2.1.4? If there's a bug here (and it looks like it), then please 
replay the blktrace with fio-2.1.6 and I can take a look at it.

-- 
Jens Axboe


