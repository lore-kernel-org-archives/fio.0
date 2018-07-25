Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] idle-prof: append output cpu idleness data to terse log
References: <925A83423110DA4D836092D40AC7A7E8084E0DEE@APYOKXMS108.ap.sony.com>
 <AT5PR8401MB116995DF0FE7729E290EEAB5AB5C0@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <CAB-428=sjscbp4UoagO41K102Ba=Ng5uoXhVgCO4Uix4+zEg_g@mail.gmail.com>
 <CALjAwxgEqChgK++6YHxg7gCyGxT4=dCAy7cZNqOgHhC==cHuQA@mail.gmail.com>
 <CAB-428m9DFwvCUu6VOpF-mQkYxFWeb5VM-s4HcQC_F+DGw1xgg@mail.gmail.com>
 <AT5PR8401MB1169740953CAF420D64D20DCAB530@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
 <183ae5ea-594e-5197-d54a-3a8955e6b5f1@kernel.dk>
 <925A83423110DA4D836092D40AC7A7E8084E52B0@APYOKXMS108.ap.sony.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c7bfede5-7711-12eb-8d6d-9dc2ca886700@kernel.dk>
Date: Wed, 25 Jul 2018 07:48:28 -0700
MIME-Version: 1.0
In-Reply-To: <925A83423110DA4D836092D40AC7A7E8084E52B0@APYOKXMS108.ap.sony.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Friendy.Su@sony.com, elliott@hpe.com, haghdoost@gmail.com, sitsofe@gmail.com
Cc: fio@vger.kernel.org, No.Tanaka@sony.com, Hajime.Tomura@sony.com
List-ID: <fio@vger.kernel.org>

On 7/25/18 1:47 AM, Friendy.Su@sony.com wrote:
> Many people are still used to process, plot data by excel. As a format which can be opened directly by excel, terse is welcome.
> Exactly terse log has already trailing the normal/json log, improving it inside fio looks a redundant work. Instead, how about provide a script to convert json to terse under tools/?Meanwhile, in HOWTO doc, tell user to use that script to get a 'perfect' terse.

Yeah, I was thinking the exact same thing while mulling over this yesterday.
I think that'd be great, and would allow us to kill the terse code in fio
proper.

-- 
Jens Axboe


