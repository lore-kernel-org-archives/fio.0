Return-Path: <axboe@kernel.dk>
Subject: Re: what is the sample logger doing when the buffer fills up?
References: <CAJ9yE1DPWmV0Hx_AAS5cKZR5qSFeqmqJVg7dgikQK=ZBje-e3A@mail.gmail.com>
 <20160707183605.GB8567@kernel.dk>
 <CAJ9yE1Ayvzkq5iNYCWEfhzunA7pLoJrS-YBb9TtBR3RM1xyWDg@mail.gmail.com>
 <BN3PR0401MB1457BF2D349098BBF7F579A2F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <577ECD29.2090204@kernel.dk>
 <BN3PR0401MB1457786D4450A0AA7A6571D1F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <577ECE94.2080105@kernel.dk>
Date: Thu, 7 Jul 2016 15:50:12 -0600
MIME-Version: 1.0
In-Reply-To: <BN3PR0401MB1457786D4450A0AA7A6571D1F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jeff Furlong <jeff.furlong@hgst.com>, Karl Cronburg <kcronbur@redhat.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 07/07/2016 03:47 PM, Jeff Furlong wrote:
> There are more.  In a 60s test, logging every 1s, I see 6 to 7 samples
> get dropped.  But I only see it when numjobs > 1.

OK, I'll take a look.

-- 
Jens Axboe


