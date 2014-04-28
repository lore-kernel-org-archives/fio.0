Return-Path: <bruce@cran.org.uk>
Message-ID: <535ED089.9000707@cran.org.uk>
Date: Mon, 28 Apr 2014 16:04:57 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: ioengine=sync issue on Windows
References: <8a71414766f34cfe98805c5dd2e94d2e@DB4PR03MB572.eurprd03.prod.outlook.com> <53208C60.8090708@kernel.dk> <533B7FC4.70700@cran.org.uk> <533DE3DC.6020605@cran.org.uk> <533E1172.6010803@kernel.dk> <533E1590.1070109@cran.org.uk> <533E163B.2080605@kernel.dk> <533E1856.4080109@cran.org.uk> <533E1A5E.5070104@kernel.dk> <533E230D.8050301@cran.org.uk> <533E26C9.9040609@kernel.dk>
In-Reply-To: <533E26C9.9040609@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, =?ISO-8859-1?Q?S=E9bastien_Bouchex_?= =?ISO-8859-1?Q?Bellomi=E9?= <sbouchex@infovista.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, bcran@fusionio.com
List-ID: <fio@vger.kernel.org>

On 4/3/2014 9:28 PM, Jens Axboe wrote:
> This really sounds like an issue with write() on windows. The change 
> looks fine, and the fact that moving the memset around makes a 
> difference - well, that's just bizarre. Do you have time to dig into 
> this? Was read/write really completely reliable before this change?

It turns out it was a problem with open() - you need to pass _O_BINARY 
to avoid Windows trying to interpret file contents.

-- 
Bruce

